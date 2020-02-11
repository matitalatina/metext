import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:share/share.dart';

class ShowTextPage extends StatefulWidget {
  final String text;

  ShowTextPage({Key key, @required this.text}) : super(key: key);

  @override
  _ShowTextPageState createState() => _ShowTextPageState();
}

class _ShowTextPageState extends State<ShowTextPage> {
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    textController.text = this.widget.text;
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Share"),
        actions: [
          IconButton(
              icon: Icon(Icons.share),
              onPressed: () {
                Share.share(textController.text,
                    subject: "Extracted text using Metext");
              })
        ],
      ),
      body: SafeArea(
          child: TextField(
        controller: textController,
        expands: true,
        maxLines: null,
      )),
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
