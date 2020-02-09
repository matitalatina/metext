import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShowTextPage extends StatelessWidget {
  ShowTextPage({Key key, @required this.visionText, @required this.image})
      : super(key: key);

  final File image;
  final VisionText visionText;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Extracted text"),
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: this.visionText.blocks.length,
          itemBuilder: (context, index) => ListTile(
            title: SelectableText(this.visionText.blocks[index].text),
            trailing: IconButton(icon: Icon(Icons.content_copy), onPressed: () {
              Clipboard.setData(new ClipboardData(text: this.visionText.blocks[index].text));
              Scaffold.of(context).showSnackBar(
                  SnackBar(content: Text("Copied!"), duration: Duration(seconds: 1),)
              );
            },),
          ),
        ),
      ),
    );
  }
}
