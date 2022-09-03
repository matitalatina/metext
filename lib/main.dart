import 'dart:async';
import 'dart:io';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
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
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeServiceLocator();
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
        primarySwatch: Colors.lime,
        accentColor: Colors.lightGreenAccent,
        brightness: Brightness.dark,
        fontFamily: 'Montserrat',
      ),
      home: MyHomePage(title: appName),
      localizationsDelegates: [
        AppLocalizationsDelegate(),
        GlobalWidgetsLocalizations.delegate,
        ...GlobalMaterialLocalizations.delegates,
      ],
      supportedLocales: [
        const Locale('en', ''),
        const Locale('it', ''),
      ],
      navigatorObservers: [
        FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isLoading = false;
  BuildContext? currentContext;
  StreamSubscription? _intentDataStreamSubscription;

  @override
  void initState() {
    super.initState();
    // For sharing images coming from outside the app while the app is in the memory
    _intentDataStreamSubscription = ReceiveSharingIntent.getMediaStream()
        .listen((List<SharedMediaFile> value) {
      processExternalImage(value);
    }, onError: (err) {
      print("getIntentDataStream error: $err");
    });

    // For sharing images coming from outside the app while the app is closed
    ReceiveSharingIntent.getInitialMedia().then((List<SharedMediaFile> value) {
      return processExternalImage(value);
    });
  }

  Future<RecognizedText> extractText(File image) async {
    final recognizer = TextRecognizer();
    return await recognizer.processImage(InputImage.fromFile(image));
  }

  Future<RecognizedText?> processExternalImage(List<SharedMediaFile> files) async {
    if (files.length > 0 &&
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
    File? image;
    try {
      XFile? xfile = await ImagePicker().pickImage(source: source);
      if (xfile != null) {
        image = File(xfile.path);
      }
    } on PlatformException catch (e) {
      if (currentContext != null && e.code == "photo_access_denied" || e.code == "camera_access_denied") {
        showDialog(
            context: currentContext!,
            barrierDismissible: true,
            builder: (context) => AlertDialog(
                  backgroundColor: getBackgroundColor(context),
                  title: Text(l10n.permissionPhotoAccessDeniedTitle),
                  content: Text(e.code == "photo_access_denied"
                      ? l10n.permissionPhotoAccessDeniedDescription
                      : l10n.permissionCameraAccessDeniedDescription),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context, rootNavigator: true).pop();
                      },
                      child: Text(l10n.ok),
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
      final visionText = await extractText(image!);
      await goToSelectBlocks(visionText, image!);
      setLoading(false);
    });
  }

  Future goToSelectBlocks(RecognizedText visionText, File image) async {
    if (currentContext != null) {
      await Navigator.push(
          currentContext!,
          MaterialPageRoute(
              builder: (context) =>
                  SelectTextPage(visionText: visionText, image: image)));
    }
  }

  addAdAfterCall<T>(Future<T> Function() callback) async {
    final ads = getIt<AdService>();
    ads.show();
    await callback();
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
                            : Container(),
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
    _intentDataStreamSubscription?.cancel();
    super.dispose();
  }
}
