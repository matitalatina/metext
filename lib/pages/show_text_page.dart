import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ShowTextPage extends StatelessWidget {
  ShowTextPage({Key key, @required this.visionText}) : super(key: key);

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
          itemBuilder: (context, index) => Card(child: SelectableText(this.visionText.blocks[index].text)),
          ),
        ),
    );
  }
}
