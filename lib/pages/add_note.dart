import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iproductive/constants.dart';
import 'package:iproductive/pages/home_page.dart';

class AddNotePage extends StatefulWidget {
  const AddNotePage({Key? key}) : super(key: key);

  @override
  State<AddNotePage> createState() => _AddNotePageState();
}

class _AddNotePageState extends State<AddNotePage> {
  final TextEditingController _titleController = TextEditingController();
  // TextEditingController _descriptionController = TextEditingController();
  String description = "Not implemented yet";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: darkGreyClr,
      body: AlertDialog(
        backgroundColor: darkRedClr,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        content: Container(
          padding: const EdgeInsets.all(10),
          constraints: const BoxConstraints.expand(
            height: 200,
            width: 250,
          ),
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(13)),
            color: darkRedClr,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text("Add a note",
                  style: TextStyle(
                    fontFamily: 'Avenir',
                    fontWeight: FontWeight.bold,
                    color: darkGreyClr,
                    fontSize: 20,
                  )),
              Container(
                decoration: const BoxDecoration(
                  // color: darkGreyClr,
                  border: Border(
                    bottom: BorderSide(color: darkGreyClr),
                  ),
                ),
                child: TextField(
                  style: const TextStyle(
                    color: darkGreyClr,
                    fontSize: 20.0,
                    fontFamily: "Avenir",
                    fontWeight: FontWeight.w700,
                  ),
                  controller: _titleController,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Name of task",
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(darkGreyClr),
                    ),
                    child: const Text(
                      "Cancel",
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(darkGreyClr),
                    ),
                    child: const Text(
                      "Add",
                      style: TextStyle(
                        fontFamily: 'Avenir',
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                    onPressed: () {
                      _addNote();
                    },
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  void _addNote() {
    FirebaseFirestore.instance.collection('notes').add({
      'date': Timestamp.now(),
      'description': description,
      'isDone': false,
      'title': _titleController.text,
    });
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (builder) => const HomePage(),
        ),
        (route) => false);
  }
}
