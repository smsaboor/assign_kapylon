import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

class AvatarWidget extends StatelessWidget {
  final imagePath;
  final isFile;
  final isEdit;
  final width, height;
  final VoidCallback onClicked;

  const AvatarWidget({
    Key? key,
    required this.imagePath,
    required this.isFile,
    required this.width,
    required this.height,
    required this.isEdit,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          isEdit
              ? Positioned(
                  bottom: 0,
                  right: 4,
                  child: buildEditIcon(color),
                )
              : Container(),
        ],
      ),
    );
  }

  Widget buildImage() {
    final image;
    if (isFile) {
      image = FileImage(imagePath);
    } else {
      image = AssetImage(imagePath);
    }
    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: width,
          height: height,
          child: InkWell(onTap: onClicked),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
        color: Colors.white,
        all: 3,
        child: buildCircle(
          color: color,
          all: 8,
          child: const Icon(
            Icons.edit,
            color: Colors.white,
            size: 20,
          ),
        ),
      );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
