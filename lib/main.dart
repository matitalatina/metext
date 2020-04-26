import 'dart:async';
import 'dart:io';

import 'package:firebase_admob/firebase_admob.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
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
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

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
//      debugShowCheckedModeBanner: false,
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
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics()),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;
  InterstitialAd _adIntertitial;
  BuildContext currentContext;
  StreamSubscription _intentDataStreamSubscription;

  @override
  void initState() {
    super.initState();
    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      return processExternalImage(value);
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      return processExternalImage(value);
    });
  }

  Future<VisionText> extractText(File image) async {
    final recognizer = FirebaseVision.instance.textRecognizer();
    final FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(image);
    return await recognizer.processImage(visionImage);
  }

  Future<VisionText> processExternalImage(List<SharedMediaFile> files) async {
    if (files != null &&
        files.length > 0 &&
        files[0].type == SharedMediaType.IMAGE) {
      await addAdAfterCall(() async {
        setLoading(true);
        final image = File(files[0].path);
        final visionText = await extractText(image);
        await goToSelectBlocks(visionText, image);
        setLoading(false);
      });
    }
    return null;
  }

  processImageFromSource(ImageSource source) async {
    final l10n = AppL10n.of(context);
    var image;
    try {
      image = await ImagePicker.pickImage(source: source);
    } on PlatformException catch (e) {
      if (e.code == "photo_access_denied" || e.code == "camera_access_denied") {
        showDialog(
            context: currentContext,
            barrierDismissible: true,
            builder: (context) => AlertDialog(
                  backgroundColor: getBackgroundColor(context),
                  title: Text(l10n.permissionPhotoAccessDeniedTitle),
                  content: Text(e.code == "photo_access_denied"
                      ? l10n.permissionPhotoAccessDeniedDescription
                      : l10n.permissionCameraAccessDeniedDescription),
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
    addAdAfterCall(() async {
      final visionText = await extractText(image);
      await goToSelectBlocks(visionText, image);
      setLoading(false);
    });
  }

  Future goToSelectBlocks(VisionText visionText, File image) async {
    await Navigator.push(
        currentContext,
        MaterialPageRoute(
            builder: (context) =>
                SelectTextPage(visionText: visionText, image: image)));
  }

  addAdAfterCall<T>(Future<T> Function() callback) async {
    final ads = getIt<AdService>();
    if (_adIntertitial != null) {
      _adIntertitial.dispose();
    }
    _adIntertitial = ads.getInterstitial()..load();

    await callback();

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
    return Scaffold(
        appBar: AppBar(
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
                            processImageFromSource(ImageSource.camera);
                          },
                          onLibraryTap: () async {
                            processImageFromSource(ImageSource.gallery);
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
    if (_intentDataStreamSubscription != null) {
      _intentDataStreamSubscription.cancel();
    }
    super.dispose();
  }
}
