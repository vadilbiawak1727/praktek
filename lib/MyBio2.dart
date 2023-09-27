import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:image_picker/image_picker.dart';
import 'package:m02/biodata.dart';
import 'package:provider/provider.dart';

class MyBio2 extends StatelessWidget {
  const MyBio2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bioData = Provider.of<BioData>(context);

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
                child: bioData.image != null
                    ? Image.file(
                        File(bioData.image!),
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
                    XFile? image =
                        await ImagePicker().pickImage(source: ImageSource.gallery);
                    bioData.setImage(image?.path);
                  },
                  child: Text("Take Image"),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: SpinBox(
                  max: 10.0,
                  min: 0.0,
                  value: bioData.score,
                  decimals: 1,
                  step: 0.1,
                  decoration: InputDecoration(labelText: "Decimals"),
                  onChanged: (value) => bioData.setScore(value),
                ),
              ),
              ElevatedButton(
                onPressed: () async {
                  DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );
                  if (pickedDate != null) {
                    bioData.setDate(pickedDate);
                  }
                },
                child: Text("Pick Date"),
              ),
              if (bioData.selectedDate != null)
                Text("Selected Date: ${bioData.selectedDate!.toLocal()}"),
            ],
          ),
        ),
      ),
    );
  }
}
