import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:file_picker/file_picker.dart';

class MyBio extends StatefulWidget {
  const MyBio({Key? key}) : super(key: key);

  @override
  State<MyBio> createState() => _MyBioState();
}

class _MyBioState extends State<MyBio> {
  String? _image;
  double _score = 0;
  DateTime? _selectedDate;
  final ImagePicker _picker = ImagePicker();
  final String _keyScore = "Score";
  final String _keyImage = "image";
  final String _keyDate = "date";
  late SharedPreferences _preferences;

  void loadData() async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      _score = (_preferences.getDouble(_keyScore) ?? 0);
      _image = _preferences.getString(_keyImage);
      final storedDate = _preferences.getString(_keyDate);
      if (storedDate != null) {
        _selectedDate = DateTime.parse(storedDate);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> _setScore(double value) async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      _preferences.setDouble(_keyScore, value);
      _score = ((_preferences.getDouble(_keyScore) ?? 0));
    });
  }

  Future<void> _setImage(String? value) async {
    _preferences = await SharedPreferences.getInstance();
    if (value != null) {
      setState(() {
        _preferences.setString(_keyImage, value);
        _image = _preferences.getString(_keyImage);
      });
    }
  }

  Future<void> _setDate(DateTime selectedDate) async {
    _preferences = await SharedPreferences.getInstance();
    setState(() {
      _preferences.setString(_keyDate, selectedDate.toIso8601String());
      _selectedDate = selectedDate;
    });
  }

  Future<void> _pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null && pickedDate != _selectedDate) {
      _setDate(pickedDate);
    }
  }

  void _showHistoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Riwayat Gambar"),
          content: Column(
            children: [
              // Tambahkan daftar gambar di sini
              // Misalnya, ListView.builder dengan daftar gambar
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Tutup dialog
              },
              child: Text("Tutup"),
            ),
          ],
        );
      },
    );
  }

  @override
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
                        child: Icon(Icons.camera_alt, color: Colors.blueGrey),
                      ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  onPressed: () async {
                    FilePickerResult? result =
                        await FilePicker.platform.pickFiles(
                      type: FileType.image,
                      allowMultiple: false,
                    );

                    if (result != null) {
                      _setImage(result.files.single.path);
                    }
                  },
                  child: Text("Ambil Foto"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                    onPressed: () async {
                      XFile? image =
                          await _picker.pickImage(source: ImageSource.gallery);
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
              ElevatedButton(
                onPressed: _pickDate,
                child: Text("Pick Date"),
              ),
              if (_selectedDate != null)
                Text("Selected Date: ${_selectedDate!.toLocal()}"),
            ],
          ),
        ),
      ),
      floatingActionButton: Stack(
        children: [
          Positioned(
            bottom: 16.0,
            right: 10.0,
            child: ElevatedButton(
              onPressed: _showHistoryDialog,
              child: Text("History"),
            ),
          ),
        ],
      ),
    );
  }
}
