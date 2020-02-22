import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:metext/i18n/constants.dart';
import 'package:metext/i18n/l10n.dart';
import 'package:metext/i18n/l10n_delegate.dart';
import 'package:metext/locator.dart';
import 'package:metext/service/ad_mob.dart';
import 'package:metext/widgets/app_icon.dart';
import 'package:metext/widgets/background_color.dart';
import 'package:metext/widgets/choose_source.dart';
import 'package:metext/pages/select_text_page.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:metext/widgets/gradient_bar.dart';

void main() {
  initializeServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        fontFamily: 'Montserrat',
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.lightGreenAccent,
        brightness: Brightness.dark,
        fontFamily: 'Montserrat',
      ),
      home: MyHomePage(title: appName),
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('it', ''),
      ],
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
  BuildContext currentContext;

  Future<VisionText> extractText(File image) async {
    final recognizer = FirebaseVision.instance.textRecognizer();
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
    return await recognizer.processImage(visionImage);
  }

  showTextFromImage(ImageSource source) async {
    final l10n = AppL10n.of(context);
    final ads = getIt<AdService>();
    if (_adIntertitial != null) {
      _adIntertitial.dispose();
    }
    _adIntertitial = ads.getInterstitial()..load();
    var image;
    try {
      image = await ImagePicker.pickImage(source: source);
    } on PlatformException catch (e) {
      if (e.code == "photo_access_denied") {
        showDialog(
            context: currentContext,
            barrierDismissible: true,
            builder: (context) => AlertDialog(
                  title: Text(l10n.permissionPhotoAccessDeniedTitle),
                  content: Text(l10n.permissionPhotoAccessDeniedDescription),
                  actions: <Widget>[
                    FlatButton(
                      child: Text(l10n.ok),
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
        currentContext,
        MaterialPageRoute(
            builder: (context) =>
                SelectTextPage(visionText: visionText, image: image)));
    setLoading(false);
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
    currentContext = context;
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
          flexibleSpace: GradientBar(),
        ),
        backgroundColor: getBackgroundColor(context),
        body: isLoading
            ? Center(child: CircularProgressIndicator())
            : OrientationBuilder(
                builder: (context, orientation) => Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        orientation == Orientation.portrait
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 32),
                                child: AppIcon(),
                              )
                            : null,
                        ChooseSource(
                          onCameraTap: () async {
                            showTextFromImage(ImageSource.camera);
                          },
                          onLibraryTap: () async {
                            showTextFromImage(ImageSource.gallery);
                          },
                        ),
                      ].where((w) => w != null).toList(),
                    ),
                  ),
                ),
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
