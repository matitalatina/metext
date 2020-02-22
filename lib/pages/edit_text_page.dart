import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metext/i18n/l10n.dart';
import 'package:share/share.dart';

class EditTextPage extends StatefulWidget {
  final String text;

  EditTextPage({Key key, @required this.text}) : super(key: key);

  @override
  _EditTextPageState createState() => _EditTextPageState();
}

class _EditTextPageState extends State<EditTextPage> {
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
    final l10n = AppL10n.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(l10n.editPageTitle),
          actions: [
            Builder(builder: (context) => IconButton(
              icon: Icon(Icons.content_copy),
              tooltip: l10n.editPageCopy,
              onPressed: () {
                Clipboard.setData(new ClipboardData(text: textController.text));
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text(l10n.editPageCopied),
                  duration: Duration(seconds: 1),
                ));
              },
            ))
          ],
        ),
        body: SafeArea(
            child: TextField(
          controller: textController,
          expands: true,
          maxLines: null,
              autofocus: true,
        )),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.share),
            tooltip: l10n.editPageShare,
            onPressed: () {
              Share.share(textController.text,
                  subject: l10n.editPageShareContentSubject);
            }));
  }
}
