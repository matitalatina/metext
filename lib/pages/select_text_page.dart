import 'dart:io';

import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:metext/i18n/l10n.dart';
import 'package:metext/pages/edit_text_page.dart';
import 'package:metext/widgets/background_color.dart';
import 'package:metext/widgets/gradient_bar.dart';

class SelectTextPage extends StatefulWidget {
  SelectTextPage({Key key, @required this.visionText, @required this.image})
      : super(key: key);

  final File image;
  final VisionText visionText;

  @override
  _SelectTextPageState createState() => _SelectTextPageState();
}

class _SelectTextPageState extends State<SelectTextPage> {
  List<ExtractedText> extractedTexts;

  @override
  Widget build(BuildContext context) {
    final l10n = AppL10n.of(context);
    this.extractedTexts = this.extractedTexts ??
        this
            .widget
            .visionText
            .blocks
            .map((b) => ExtractedText(selected: false, text: b.text))
            .toList();
    final selectedCount = this.extractedTexts.where((t) => t.selected).length;
    final hasMoreSelected = selectedCount > this.extractedTexts.length / 2;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "$selectedCount ${selectedCount == 1 ? l10n.selectPageSelectedBlock : l10n.selectPageSelectedBlocks}"),
        flexibleSpace: GradientBar(),
        actions: [
          hasMoreSelected
              ? IconButton(
                  icon: Icon(Icons.check_box),
                  onPressed: () => onSelectAll(false),
                  tooltip: l10n.selectPageDeselectAll,
                )
              : IconButton(
                  icon: Icon(Icons.check_box_outline_blank),
                  onPressed: () => onSelectAll(true),
                  tooltip: l10n.selectPageSelectAll,
                )
        ],
      ),
      backgroundColor: getBackgroundColor(context),
      body: SafeArea(
          child: ReorderableListView(
              onReorder: (oldIndex, newIndex) {
                setState(() {
                  if (oldIndex > newIndex) {
                    final swappedText = this.extractedTexts.removeAt(oldIndex);
                    this.extractedTexts.insert(newIndex, swappedText);
                  } else {
                    final swappedText = this.extractedTexts.removeAt(oldIndex);
                    this.extractedTexts.insert(--newIndex, swappedText);
                  }
                });
              },
              children: this.extractedTexts.map((t) {
                return ListTile(
                  key: Key(t.text),
                  onTap: () => onToggleText(t),
                  title: Text(t.text),
                  leading: Icon(t.selected
                      ? Icons.check_box
                      : Icons.check_box_outline_blank),
                  trailing: Icon(Icons.drag_handle),
                  selected: t.selected,
                );
              }).toList())),
      floatingActionButton: selectedCount != 0
          ? Builder(
              builder: (BuildContext context) => FloatingActionButton(
                child: Icon(Icons.navigate_next),
                tooltip: AppL10n.of(context).selectPageContinue,
                onPressed: () async {
                  final text = this
                      .extractedTexts
                      .where((t) => t.selected)
                      .map((t) => t.text)
                      .join("\n");
                  await Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditTextPage(text: text)));
                },
              ),
            )
          : null,
    );
  }

  onToggleText(ExtractedText index) {
    setState(() {
      index.selected = !index.selected;
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
