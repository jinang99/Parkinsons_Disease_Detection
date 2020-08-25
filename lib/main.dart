import 'package:flutter/material.dart';
import './recognizer_screen.dart';

void main() => runApp(handwrittenNumberRecognizerApp());

class handwrittenNumberRecognizerApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Recognizer',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: RecognizerScreen(title: 'Pakinson\'s Trace Test',),
    );
  }
}
