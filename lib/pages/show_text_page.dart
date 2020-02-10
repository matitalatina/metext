import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShowTextPage extends StatefulWidget {
  ShowTextPage({Key key, @required this.visionText, @required this.image})
      : super(key: key);

  final File image;
  final VisionText visionText;

  @override
  _ShowTextPageState createState() => _ShowTextPageState();
}

class _ShowTextPageState extends State<ShowTextPage> {
  List<ExtractedText> extractedTexts;

  @override
  Widget build(BuildContext context) {
    this.extractedTexts = this.extractedTexts ??
        this
            .widget
            .visionText
            .blocks
            .map((b) => ExtractedText(selected: false, text: b.text))
            .toList();
    final selectedCount = this.extractedTexts
        .where((t) => t.selected)
        .length;
    final hasMoreSelected = selectedCount > this.extractedTexts.length / 2;
    return Scaffold(
      appBar: AppBar(
        title: Text("$selectedCount selected blocks"),
        actions: [
          hasMoreSelected
              ? IconButton(
            icon: Icon(Icons.check_box),
            onPressed: () => onSelectAll(false),
            tooltip: "Unselect all",
          )
              : IconButton(
            icon: Icon(Icons.check_box_outline_blank),
            onPressed: () => onSelectAll(true),
            tooltip: "Select all",
          )
        ],
      ),
      body: SafeArea(
          child: ReorderableListView(
            onReorder: (oldIndex, newIndex) {
              setState(() {
                if (oldIndex > newIndex) {
                  final swappedText = this.extractedTexts.removeAt(oldIndex);
                  this.extractedTexts.insert(newIndex, swappedText);
                }
                else {
                  final swappedText = this.extractedTexts.removeAt(oldIndex);
                  this.extractedTexts.insert(--newIndex, swappedText);
                }
              });
            } ,
              children:
              this.extractedTexts
                  .map((t) {
                return ListTile(
                  key: Key(t.text),
                  onTap: () => onToggleText(t),
                  title: Text(t.text),
                  leading: Icon(t.selected
                      ? Icons.check_box
                      : Icons.check_box_outline_blank),
                  trailing: Icon(Icons.drag_handle),
                  selected: t.selected
                  ,
                );
              }
              ).toList()
          )),
      floatingActionButton: selectedCount != 0
          ? Builder(
        builder: (BuildContext context) =>
            FloatingActionButton(
              child: Icon(Icons.content_copy),
              tooltip: "Copy selected blocks",
              onPressed: () {
                Clipboard.setData(new ClipboardData(
                    text: this.extractedTexts.map((t) => t.text).join("\n")));
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text("Copied!"),
                  duration: Duration(seconds: 1),
                ));
              },
            ),
      )
          : null,
    );
  }

  onToggleText(ExtractedText index) {
    setState(() {
      index.selected =
      !index.selected;
    });
  }

  onSelectAll(bool selected) {
    setState(() {
      this.extractedTexts.forEach((t) => t.selected = selected);
    });
  }
}

class ExtractedText {
  bool selected;
  String text;

  ExtractedText({this.selected, this.text});
}
