import 'dart:io';

import 'package:bordered_text/bordered_text.dart';
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage('assets/images/burger.jpg'), context);
    precacheImage(AssetImage('assets/images/salad.jpg'), context);
    precacheImage(AssetImage('assets/images/salmon.jpg'), context);
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  AnimationController controller;
  Animation<Offset> offsetTop;
  Animation fadeOverlay;
  Animation fadeLetsGetStarted;
  Animation<Offset> offsetBottom;
  Animation<Offset> offsetTouchToSeeFood;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    offsetTop = Tween<Offset>(begin: Offset.zero, end: Offset(0.0, 1.0))
        .animate(controller);
    fadeOverlay = Tween(begin: 0.5, end: 0.0).animate(controller);
    fadeLetsGetStarted = Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));
    offsetBottom = Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset.zero)
        .animate(controller);
    offsetTouchToSeeFood =
        Tween<Offset>(begin: Offset(0.0, 1.0), end: Offset(0.0, 0.0)).animate(
            CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<File> getImage(ImageSource imageSource) async {
    return await ImagePicker.pickImage(source: imageSource);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: 75.0,
                  color: Colors.red[900],
                  child: Center(
                    child: Stack(
                      children: <Widget>[
                        BorderedText(
                          strokeWidth: 10.0,
                          strokeColor: Colors.black,
                          child: Text(
                            'SEEFOOD',
                            style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontSize: 50.0,
                              letterSpacing: 5.0,
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  color: Colors.black,
                  height: 3.0,
                ),
                Container(
                  height: 50.0,
                  child: Center(
                    child: Text(
                      '"The Shazam for Food"',
                      style: TextStyle(
                        fontFamily: 'OpenSans',
                        color: Colors.red[900],
                        fontSize: 25.0,
                        letterSpacing: 1.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.black,
                  height: 3.0,
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      controller.forward();
                    },
                    child: Stack(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Expanded(
                              child: Image(
                                image: AssetImage('assets/images/burger.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Image(
                                image: AssetImage('assets/images/salmon.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                            Expanded(
                              child: Image(
                                image: AssetImage('assets/images/salad.jpg'),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        FadeTransition(
                          opacity: fadeOverlay,
                          child: Container(
                            constraints: BoxConstraints(
                              minHeight: double.infinity,
                              minWidth: double.infinity,
                            ),
                            color: Colors.black,
                          ),
                        ),
                        Align(
                          alignment: Alignment.lerp(Alignment.topCenter,
                              Alignment.bottomCenter, 0.25),
                          child: SlideTransition(
                            position: offsetTop,
                            child: FadeTransition(
                              opacity: fadeLetsGetStarted,
                              child: BorderedText(
                                strokeWidth: 5.0,
                                strokeColor: Colors.black,
                                child: Text(
                                  'Let\'s Get Started',
                                  style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      letterSpacing: 1.0,
                                      color: Colors.white.withOpacity(1.0),
                                      fontSize: 35.0,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: SlideTransition(
                position: offsetBottom,
                child: Container(
                  height: 100.0,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    gradient: LinearGradient(
                      begin: FractionalOffset.topCenter,
                      end: FractionalOffset.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.6),
                        Colors.black,
                      ],
                      stops: [0.0, 0.1, 1.0],
                    ),
                  ),
                ),
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: SlideTransition(
                position: offsetTouchToSeeFood,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        SpinKitDualRing(
                          size: 70.0,
                          color: Colors.white,
                          duration: Duration(milliseconds: 4000),
                        ),
                        GestureDetector(
                          onTap: () async {
                            File fileImage = await getImage(ImageSource.camera);
                            if (fileImage != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EvaluationPage(
                                    file: fileImage,
                                  ),
                                ),
                              );
                            }
                          },
                          onLongPress: () async {
                            File fileImage =
                                await getImage(ImageSource.gallery);
                            if (fileImage != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EvaluationPage(
                                    file: fileImage,
                                  ),
                                ),
                              );
                            }
                          },
                          child: Container(
                            height: 70.0,
                            width: 70.0,
                            decoration: BoxDecoration(
                              color: Colors.yellow,
                              shape: BoxShape.circle,
                              gradient: RadialGradient(
                                colors: [Colors.red[900], Colors.black],
                                stops: const [0.8, 1.0],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    BorderedText(
                      strokeWidth: 5.0,
                      strokeColor: Colors.black,
                      child: Text(
                        'Touch to SEEFOOD',
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            letterSpacing: 2.0,
                            color: Colors.white,
                            fontSize: 30.0,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class EvaluationPage extends StatefulWidget {
  final File file;

  EvaluationPage({this.file});

  @override
  _EvaluationPageState createState() => _EvaluationPageState();
}

class _EvaluationPageState extends State<EvaluationPage> {
  final ImageLabeler imageLabeler = FirebaseVision.instance.imageLabeler();
  bool isHotdog;
  String strLabels;

  @override
  void initState() {
    super.initState();

    FirebaseVisionImage visionImage = FirebaseVisionImage.fromFile(widget.file);
    imageLabeler.processImage(visionImage).then((List<ImageLabel> labels) {
      Future.delayed(Duration(seconds: 4), () {}).then((value) {
        setState(() {
          strLabels = labels.map((l) => l.text).join(', ');
          isHotdog = labels.any((ImageLabel label) => label.text == 'Hot dog');
        });
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            Image.file(
              widget.file,
              fit: BoxFit.cover,
            ),
            isHotdog == null
                ? Container(
                    color: Colors.grey.withOpacity(0.5),
                  )
                : _buildEvaluationOverlay(isHotdog),
            isHotdog == null
                ? Align(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SpinKitCircle(
                          size: 200.0,
                          color: Colors.red[900],
                          duration: Duration(milliseconds: 2000),
                        ),
                        SizedBox(height: 20.0),
                        BorderedText(
                          strokeWidth: 7.5,
                          strokeColor: Colors.black,
                          child: Text(
                            'Evaluating...',
                            style: TextStyle(
                                fontFamily: 'OpenSans',
                                letterSpacing: 2.0,
                                color: Colors.white,
                                fontSize: 40.0,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }

  Widget _buildEvaluationOverlay(bool isHotdog) {
    if (isHotdog) {
      return Stack(
        alignment: Alignment.topCenter,
        children: <Widget>[
          Container(
            height: 130.0,
            width: double.infinity,
            color: Colors.green[200],
          ),
          Container(
            margin: EdgeInsets.only(top: 75.0),
            height: 135.0,
            width: 135.0,
            decoration: BoxDecoration(
              color: Colors.green[200],
              shape: BoxShape.circle,
            ),
          ),
          Container(
            height: 125.0,
            width: double.infinity,
            color: Colors.green,
            child: Center(
              child: BorderedText(
                strokeWidth: 7.5,
                strokeColor: Colors.black,
                child: Text(
                  'Hotdog',
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      letterSpacing: 2.0,
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
          GestureDetector(
            onLongPress: () {
              Fluttertoast.showToast(
                  msg: strLabels,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM);
            },
            child: Container(
              margin: EdgeInsets.only(top: 82.5),
              height: 120.0,
              width: 120.0,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check,
                size: 125.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        alignment: Alignment.bottomCenter,
        children: <Widget>[
          Container(
            height: 130.0,
            width: double.infinity,
            color: Colors.white,
          ),
          Container(
            margin: EdgeInsets.only(bottom: 75.0),
            height: 135.0,
            width: 135.0,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          Container(
            height: 125.0,
            width: double.infinity,
            color: Colors.red[900],
            child: Center(
              child: BorderedText(
                strokeWidth: 7.5,
                strokeColor: Colors.black,
                child: Text(
                  'Not hotdog',
                  style: TextStyle(
                      fontFamily: 'OpenSans',
                      letterSpacing: 2.0,
                      color: Colors.white,
                      fontSize: 40.0,
                      fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
          GestureDetector(
            onLongPress: () {
              Fluttertoast.showToast(
                  msg: strLabels,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.BOTTOM);
            },
            child: Container(
              margin: EdgeInsets.only(bottom: 82.5),
              height: 120.0,
              width: 120.0,
              decoration: BoxDecoration(
                color: Colors.red[900],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.clear,
                size: 125.0,
                color: Colors.white,
              ),
            ),
          ),
        ],
      );
    }
  }
}
