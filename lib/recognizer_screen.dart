import 'dart:io';

import 'package:flutter/material.dart';
import 'package:screenshot/screenshot.dart';
import './constants.dart';
import './drawing_painter.dart';
import './brain.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:http/http.dart' as http;
import 'package:async/async.dart';


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
                      //http://25ab84feb44c.ngrok.io/preds
                      print(image);
                      var stream = new http.ByteStream(DelegatingStream.typed(image.openRead()));
                      var length = await image.length();
                      print(length);
                      var uri = Uri.parse("http://1182a12f1022.ngrok.io/preds");

                      print("connection established.");
                      // var request = http.MultipartRequest('POST', uri);
                      //     request.files.add(
                      //       await http.MultipartFile.fromPath(
                      //         'picture',
                      //         "/Internal storage/Pictures/Screenshots/1598347408.png"
                      //       )
                      //     );
                      var request = new http.MultipartRequest("POST", uri);
                      var multipartFile = new http.MultipartFile( 'image', stream, length,
                      filename: "image", 
                      );
                      //contentType: MediaType(‘image’, ‘png’));
                      request.files.add(multipartFile);

                      var response = await request.send();
                      print(response.statusCode);
                      final x = await response.stream.bytesToString();
                            print("Response :  $x");
                      final result =
                            await ImageGallerySaver.saveImage(image.readAsBytesSync());
                          print(result);
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
                              image: AssetImage('./assets/images/meander.jpg'),
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
