import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/camera_widget.dart';
import '../services/video_service.dart';
import 'video_playback_screen.dart';

class VideoRecordScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const VideoRecordScreen({super.key, required this.cameras});

  @override
  _VideoRecordScreenState createState() => _VideoRecordScreenState();
}

class _VideoRecordScreenState extends State<VideoRecordScreen> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isRecording = false;
  bool _permissionDenied = false;
  int _selectedCameraIdx = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera(_selectedCameraIdx);
  }

  Future<void> _initializeCamera(int cameraIdx) async {
    final cameraPermission = await Permission.camera.request();
    final microphonePermission = await Permission.microphone.request();

    if (cameraPermission.isGranted && microphonePermission.isGranted) {
      _controller = CameraController(
        widget.cameras[cameraIdx],
        ResolutionPreset.max,
        enableAudio: true,
      );
      _initializeControllerFuture = _controller!.initialize();
    } else {
      setState(() {
        _permissionDenied = true;
      });
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _toggleRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }
    if (_isRecording) {
      final file = await _controller!.stopVideoRecording();
      setState(() => _isRecording = false);
      await VideoService.saveVideo(file.path);
    } else {
      await _controller!.startVideoRecording();
      setState(() => _isRecording = true);
    }
  }

  Future<void> _switchCamera() async {
    if (widget.cameras.length < 2) return;

    final cameraIdx = (_selectedCameraIdx + 1) % widget.cameras.length;

    await _controller?.dispose();
    setState(() {
      _selectedCameraIdx = cameraIdx;
      _controller = null;
    });

    await _initializeCamera(cameraIdx);
  }

  Widget _buildBody() {
    if (_permissionDenied) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Camera and Microphone permissions are required.'),
            ElevatedButton(
              child: const Text('Open Settings'),
              onPressed: () => openAppSettings(),
            ),
          ],
        ),
      );
    }

    if (_controller == null || _initializeControllerFuture == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return FutureBuilder<void>(
      future: _initializeControllerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return CameraWidget(controller: _controller!);
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Recorder', style: TextStyle(color: Colors.white),),
        backgroundColor: Colors.blue,),
      body: _buildBody(),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          if (!_permissionDenied) ...[
            FloatingActionButton(
              onPressed: _toggleRecording,
              child: Icon(_isRecording ? Icons.stop : Icons.videocam),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              onPressed: _switchCamera,
              child: const Icon(Icons.switch_camera),
            ),
            const SizedBox(height: 16),
            FloatingActionButton(
              child: const Icon(Icons.photo_library),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const VideoPlaybackScreen()),
                );
              },
            ),
          ],
        ],
      ),
    );
  }
}