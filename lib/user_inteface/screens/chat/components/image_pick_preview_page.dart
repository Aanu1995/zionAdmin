import 'dart:io';
import 'package:flutter/material.dart';

class ImagePickPreviewPage extends StatefulWidget {
  final File image;
  ImagePickPreviewPage({this.image});

  @override
  _ImagePickPreviewPageState createState() => _ImagePickPreviewPageState();
}

class _ImagePickPreviewPageState extends State<ImagePickPreviewPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Image.file(
            widget.image,
            height: double.maxFinite,
            width: double.maxFinite,
            fit: BoxFit.fitWidth,
          ),
          SizedBox(height: 16.0),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              color: Colors.black54,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                      ),
                      cursorColor: Colors.white,
                      decoration: InputDecoration.collapsed(
                        hintText: 'Add a caption...',
                        hintStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                        fillColor: Colors.black38,
                      ),
                      minLines: 1,
                      maxLines: 6,
                    ),
                  ),
                  SizedBox(width: 8.0),
                  InkWell(
                      child: CircleAvatar(
                        radius: 25.0,
                        backgroundColor: Theme.of(context).primaryColor,
                        child: Icon(Icons.send, color: Colors.white),
                      ),
                      onTap: () =>
                          Navigator.pop(context, _controller.text.toString()))
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
