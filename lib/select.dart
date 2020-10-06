import 'package:drawx/recognizer_screen.dart';
import 'package:flutter/material.dart';
import './upload_image.dart';

class Select extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
         Column(
           mainAxisAlignment: MainAxisAlignment.center,
           crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget> [
          RaisedButton(
            
            child: Text("Click/ Upload an image"),
            onPressed: (){
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                            return PhotoPreviewScreen();
                            }));

            } ,
            ),
            RaisedButton(
              child: Text("Trace the shape"),
              onPressed: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
                            return RecognizerScreen(title: 'Pakinson\'s Trace Test',);
                            //return Select();
                            }));
              },
              )

        ]
      )
      
    );
  }
}