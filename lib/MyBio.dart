import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class myBio extends StatefulWidget {
  const myBio({super.key});

  @override

  State<myBio> createState() => _myBioState();
}

class _myBioState extends State<myBio> {
  String? _image;
  double _score = 0;
  final ImagePicker _Picker = ImagePicker();
  final String _KeyScore = "Score";
  final String _KeyImage = "image";
  late SharedPreferences _preferences;

  void loadData() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      _score = (_preferences.getDouble(_KeyScore) ?? 0);
      _image = _preferences.getString(_KeyImage);
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("My BIO DATA")),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Column(
            children: [
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(color: Colors.red[200]),
                child: _image != null
                  ? Image.file(
                      File(_image!),
                      width: 200.0,
                      height: 200.0,
                      fit: BoxFit.fitHeight,
                    )
                  : Container(
                    decoration: BoxDecoration(
                      color: Color.fromARGB(255, 198, 198, 198)),
                    width: 200,
                    height: 200,
                    child: Icon(Icons.camera_alt, color: Colors.blueGrey
                    ),  
                  ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    XFile? image = await _Picker.pickImage(source: ImageSource.gallery);
                    _setImage(image?.path);
                  }, 
                  child: Text("Take Image")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SpinBox(
                    max: 10.0,
                    min: 0.0,
                    value: _score,
                    decimals: 1,
                    step: 0.1,
                    decoration: InputDecoration(labelText: "Decimals"),
                    onChanged: _setScore,
                  ),
                  ),
            ],
          ),
        ),
        ),
    );
  }
  Future<void> _setScore(double value) async {
  _preferences = await SharedPreferences.getInstance();
  setState(() {
    _preferences.setDouble(_KeyScore, value);
    _score = ((_preferences.getDouble(_KeyScore) ?? 0));
  });
  }

  Future<void> _setImage(String? value) async {
    _preferences =await SharedPreferences.getInstance();
    if (value != null)
    setState(() {
      _preferences.setString(_KeyImage, value);
      _image = _preferences.getString(_KeyImage);
    });
  }
}
