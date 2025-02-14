

import 'dart:html' as html;
import 'dart:ui_web';
import 'package:flutter/material.dart';
import 'dart:js' as js;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Image Display App',
      home: ImageDisplayPage(),
    );
  }
}

class ImageDisplayPage extends StatefulWidget {
  const ImageDisplayPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ImageDisplayPageState createState() => _ImageDisplayPageState();
}

class _ImageDisplayPageState extends State<ImageDisplayPage> {
  String imageUrl = '';
  bool isMenuOpen = false;

  void toggleFullscreen() {
    js.context.callMethod('toggleFullscreen');
  }

  void enterFullscreen() {
    html.document.documentElement?.requestFullscreen();
    setState(() {
      isMenuOpen = false;
    });
  }

  void exitFullscreen() {
    html.document.exitFullscreen();
    setState(() {
      isMenuOpen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Image Display App')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (imageUrl.isNotEmpty)
              GestureDetector(
                onDoubleTap: toggleFullscreen,
                child: SizedBox(
                  width: 600, // Set a fixed width for the image container
                  height: 400, // Set a fixed height for the image container
                  child: HtmlElementView(
                    viewType: 'imageElement_${imageUrl.hashCode}', // Unique key based on URL
                  ),
                ),
              ),
            const SizedBox(height: 20),
            TextField(
              onChanged: (value) {
                imageUrl = value;
              },
              decoration:const InputDecoration(
                labelText: 'Enter Image URL',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  
                });
                _updateImageElement();
              },
              child: const Text('Load Image'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            isMenuOpen = !isMenuOpen;
          });
        },
        child:const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomSheet: isMenuOpen
          ? Container(
              color: Colors.black54,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: TextButton(
                      onPressed: enterFullscreen,
                      child: const Text('Enter Fullscreen',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                  ListTile(
                    title: TextButton(
                      onPressed: exitFullscreen,
                      child:const Text('Exit Fullscreen',
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            )
          : null,
    );
  }

   void _updateImageElement() {
    // Create an HTML image element
    final imgElement = html.ImageElement(src: imageUrl)
      ..style.width = '100%' // Set to 100% to fill the container
      ..style.height = '100%' // Set to 100% to fill the container
      ..style.objectFit = 'cover';

    // Register the view type for the HTML element
    platformViewRegistry.registerViewFactory(
      'imageElement_${imageUrl.hashCode}', // Unique key based on URL
      (int viewId) => imgElement,
    );
  }
}


