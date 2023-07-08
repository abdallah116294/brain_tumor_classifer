import 'dart:io';

import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _loading = true;
 late  File _image;
  List? _output;
   final picker = ImagePicker();
  detectImage(File image) async {
    var output = await Tflite.runModelOnImage(
        path: image.path,
        numResults: 4,
        threshold: 0.6,
        imageMean: 127.5,
        imageStd: 127.5);
    setState(() {
      _output = output;
      _loading = false;
    });
  }

  loadModel() async {
    await Tflite.loadModel(
        model: 'assets/model_unquant.tflite', labels: 'assets/labels.txt');
  }

  Future pickImage() async {
    var image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      return null;
    }
    setState(() {
      _image = File(image!.path);
    });
    
    detectImage(_image);
  }

  Future pickGallery() async {
  
    var image = await picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      return null;
    }
    setState(() {
      _image = File(image.path);
    });
    detectImage(_image);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadModel().then((value) {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SizedBox(
            height: 50,
          ),
          const Text(
            "Tumor Brain",
            style: TextStyle(
                color: Color.fromARGB(221, 235, 176, 13),
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 5,
          ),
          const Text(
            "Tumor Brain Classifer",
            style: TextStyle(
                color: Color.fromARGB(221, 235, 176, 13),
                fontSize: 22,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(
            height: 50,
          ),
          Center(
            child: _loading
                ? Container(
                    width: 400,
                    child: Column(children: [
                      Image.asset('assets/brain2.jpg'),
                      const SizedBox(
                        height: 50,
                      )
                    ]),
                  )
                : Container(
                    child: Column(children: [
                      Container(
                        height: 250,
                        child: Image.file(_image),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      _output != null
                          ? Text(
                              '${_output![0]['label']}',
                              style:
                                 const TextStyle(color:  Color.fromARGB(221, 235, 176, 13), fontSize: 50),
                            )
                          : Container(),
                          const SizedBox(height: 20,)
                    ]),
                  ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Column(children: [
              InkWell(
                onTap: () {
                  pickImage();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 250,
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(221, 235, 176, 13),
                      borderRadius: BorderRadius.circular(6)),
                  child: const Text(
                    'Capture an Image',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              InkWell(
                onTap: () {
                  pickGallery();
                },
                child: Container(
                  width: MediaQuery.of(context).size.width - 250,
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 18),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(221, 235, 176, 13),
                      borderRadius: BorderRadius.circular(6)),
                  child: const Text(
                    'Chose form device',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ]),
          )
        ]),
      ),
    );
  }
}
