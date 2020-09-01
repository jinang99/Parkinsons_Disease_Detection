import 'dart:io';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import './constants.dart';
import './drawing_painter.dart';
import './brain.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';

class RecognizerScreen extends StatefulWidget {
  RecognizerScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RecognizerScreen createState() => _RecognizerScreen();
}

class _RecognizerScreen extends State<RecognizerScreen> {
  List<Offset> points = List();
  AppBrain brain = AppBrain();
  ScreenshotController screenshotController = ScreenshotController();
  File _imageFile;

  void _cleanDrawing() {
    setState(() {
      points = List();
    });
  }

  @override
  void initState() {
    super.initState();
   // brain.loadModel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            // Expanded(
            //   flex: 1,
            //   child: Container(
            //     padding: EdgeInsets.all(16),
            //     color: Colors.red,
            //     alignment: Alignment.center,
            //     child: Text('Header'),
            //   ),
            // ),
            Screenshot(
              controller: screenshotController,
              child: Container(
              decoration: new BoxDecoration(
                border: new Border.all(
                  width: 1.0,
                  color: Colors.blue,
                ),
              ),
              child: Builder(
                builder: (BuildContext context) {
                  return GestureDetector(
                    onPanUpdate: (details) {
                      setState(() {
                        RenderBox renderBox = context.findRenderObject();
                        points.add(
                            renderBox.globalToLocal(details.globalPosition));
                      });
                    },
                    onPanStart: (details) {
                      setState(() {
                        RenderBox renderBox = context.findRenderObject();
                        points.add(
                            renderBox.globalToLocal(details.globalPosition));
                      });
                    },
                    onPanEnd: (details) async {
                      points.add(null);
                      screenshotController
                        .capture(delay: Duration(milliseconds: 10))
                        .then((File image) async {
                      //print("Capture Done");
                      setState(() {
                        _imageFile = image;
                      });
                      final result =
                            await ImageGallerySaver.saveImage(image.readAsBytesSync());
                        print("File Saved to Gallery");
                      }).catchError((onError) {
                        print(onError);
                      });
                      //brain.processCanvasPoints(points);
//                      List predictions = await brain.processCanvasPoints(points);
//                      print(predictions);
//                      setState(() {});
                    },
                    child: ClipRect(
                        child:
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage('./assets/images/spiral2.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: CustomPaint(
                            size: Size(kCanvasSize, kCanvasSize),
                            painter: DrawingPainter(
                              offsetPoints: points,
                            ),
                          ),
                        )

                    ),
                  );
                },
              ),
            ),
            ),
            
            //       Expanded(
            //         flex: 1,
            //         child: Container(
            //           padding: EdgeInsets.all(16),
            //           color: Colors.blue,
            //           alignment: Alignment.center,
            //           child: Text('Footer'),
            //         ),
            //       ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _cleanDrawing();
        },
        tooltip: 'Clean',
        child: Icon(Icons.delete),
      ),
    );
  }
}
