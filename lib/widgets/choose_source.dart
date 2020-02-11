import 'package:flutter/material.dart';

class ChooseSource extends StatelessWidget {
  final VoidCallback onCameraTap;
  final VoidCallback onLibraryTap;

  ChooseSource({@required this.onCameraTap, @required this.onLibraryTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      // Center is a layout widget. It takes a single child and positions it
      // in the middle of the parent.
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: OutlineButton.icon(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                onPressed: this.onCameraTap,
                icon: Icon(Icons.camera_alt),
                label: Text("From camera"),

              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: OutlineButton.icon(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 32),
                onPressed: this.onLibraryTap,
                icon: Icon(Icons.photo_library),
                label: Text("From gallery"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
