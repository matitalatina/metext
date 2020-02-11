import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShowTextPage extends StatelessWidget {
  final String text;

  ShowTextPage({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Share"),
        actions: [],
      ),
      body: SafeArea(child: SelectableText(this.text)),
      floatingActionButton: Builder(
        builder: (BuildContext context) => FloatingActionButton(
          child: Icon(Icons.content_copy),
          tooltip: "Copy selected blocks",
          onPressed: () {
            Clipboard.setData(new ClipboardData(text: "ciao"));
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Copied!"),
              duration: Duration(seconds: 1),
            ));
          },
        ),
      ),
    );
  }
}
