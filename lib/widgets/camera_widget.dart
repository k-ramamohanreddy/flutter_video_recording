import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraWidget extends StatelessWidget {
  final CameraController controller;

  const CameraWidget({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      child: AspectRatio(
        aspectRatio: controller.value.aspectRatio,
        child: CameraPreview(controller),
      ),
    );
  }
}