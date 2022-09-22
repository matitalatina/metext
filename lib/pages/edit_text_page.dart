import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:metext/i18n/l10n.dart';
import 'package:metext/widgets/background_color.dart';
import 'package:metext/widgets/gradient_bar.dart';
import 'package:share_plus/share_plus.dart';

class EditTextPage extends StatefulWidget {
  final String text;

  EditTextPage({Key? key, required this.text}) : super(key: key);

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
          title: Text(l10n.editPageTitle, key: Key('editPage-title'),),
          flexibleSpace: GradientBar(),
          actions: [
            Builder(
                builder: (context) => IconButton(
                      icon: Icon(Icons.content_copy),
                      tooltip: l10n.editPageCopy,
                      onPressed: () {
                        Clipboard.setData(
                            new ClipboardData(text: textController.text));
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(l10n.editPageCopied),
                          duration: Duration(seconds: 1),
                        ));
                      },
                    ))
          ],
        ),
        backgroundColor: getBackgroundColor(context),
        body: SafeArea(
            child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: TextField(
            controller: textController,
            expands: true,
            maxLines: null,
            autofocus: true,
          ),
        )),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.share),
            tooltip: l10n.editPageShare,
            onPressed: () {
              Size size = MediaQuery.of(context).size;
              Share.share(textController.text,
                  subject: l10n.editPageShareContentSubject,
                  sharePositionOrigin: Rect.fromLTWH(0, 0, size.width, size.height / 2.5)
              );
            }));
  }
}
