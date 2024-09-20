import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'screens/video_record_screen.dart';
import 'package:permission_handler/permission_handler.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestPermissions();
  final cameras = await availableCameras();
  runApp(MyApp(cameras: cameras));
}

Future<void> requestPermissions() async {
  await [
    Permission.camera,
    Permission.microphone,
    Permission.storage,
  ].request();
}

class MyApp extends StatelessWidget {
  final List<CameraDescription> cameras;

  const MyApp({super.key, required this.cameras});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Recorder App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: VideoRecordScreen(cameras: cameras),
    );
  }
}