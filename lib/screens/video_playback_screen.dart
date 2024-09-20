import 'package:flutter/material.dart';
import '../models/video_file.dart';
import '../services/video_service.dart';
import '../widgets/video_player_widget.dart';

class VideoPlaybackScreen extends StatelessWidget {

  const VideoPlaybackScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Recorded Videos', 
        style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,),
        body: FutureBuilder<List<VideoFile>>(
        future: VideoService.getVideos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No videos found'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final video = snapshot.data![index];
                return Card( 
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0.8,
                  shadowColor: Colors.blue,
                  color: const Color.fromARGB(255, 76, 142, 195),
                  margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: ListTile(
                    title: Text(video.name, style: const TextStyle(color: Colors.white),),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => VideoPlayerWidget(videoPath: video.path),
                        ),
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}