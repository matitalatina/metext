import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:metext/locator.dart';
import 'package:metext/service/ad_mob.dart';
import 'package:metext/widgets/choose_source.dart';
import 'package:metext/pages/select_text_page.dart';


void main() {
  initializeServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Metext',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.lightGreenAccent,
        brightness: Brightness.dark,
      ),
      home: MyHomePage(title: 'Metext'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;
  InterstitialAd _adIntertitial = null;
  Future<VisionText> extractText(File image) async {
    final recognizer = FirebaseVision.instance.textRecognizer();
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
    return await recognizer.processImage(visionImage);
  }

  showTextFromImage(BuildContext context, ImageSource source) async {
    var image;
    try {
      image = await ImagePicker.pickImage(source: source);
    } on PlatformException catch (e) {
      if (e.code == "photo_access_denied") {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) => AlertDialog(
                  title: Text("Need permission"),
                  content: Text(
                      "I can't access to your library, please allow me to do that."),
                  actions: <Widget>[
                    FlatButton(
                      child: Text("Ok"),
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                    )
                  ],
                ));
      }
    }
    setLoading(true);
    if (image == null) {
      setLoading(false);
      return;
    }
    final visionText = await extractText(image);
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SelectTextPage(visionText: visionText, image: image)));
    setLoading(false);
    final ads = getIt<AdService>();
    if (_adIntertitial == null) {
      _adIntertitial = ads.loadInterstitial();
    }
    _adIntertitial.show(
      anchorType: AnchorType.bottom,
      anchorOffset: 0.0,
    );
  }

  void setLoading(bool loading) {
    setState(() {
      isLoading = loading;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
        appBar: AppBar(
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title: Text(widget.title),
        ),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : ChooseSource(
                onCameraTap: () async {
                  showTextFromImage(context, ImageSource.camera);
                },
                onLibraryTap: () async {
                  showTextFromImage(context, ImageSource.gallery);
                },
              ));
  }

  @override
  void dispose() {
    if (_adIntertitial != null) {
      _adIntertitial.dispose();
    }
    _adIntertitial = null;
    super.dispose();
  }

}
