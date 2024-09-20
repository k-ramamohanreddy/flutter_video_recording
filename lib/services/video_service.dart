import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/video_file.dart';

class VideoService {
  static Future<void> saveVideo(String sourcePath) async {
    final directory = await getApplicationDocumentsDirectory();
    final fileName = 'video_${DateTime.now().millisecondsSinceEpoch}.mp4';
    final targetPath = '${directory.path}/$fileName';
    await File(sourcePath).copy(targetPath);
  }

  static Future<List<VideoFile>> getVideos() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync().whereType<File>().where((file) => file.path.endsWith('.mp4')).toList();
    
    return files.map((file) => VideoFile(
      name: file.path.split('/').last,
      path: file.path,
    )).toList();
  }
}