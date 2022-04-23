// ignore_for_file: prefer_const_constructors
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:iproductive/constants.dart';
import 'package:iproductive/pages/add_note.dart';
import 'package:iproductive/pages/sign_in.dart';
import 'package:iproductive/services/auth_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthClass authClass = AuthClass();
  final Stream<QuerySnapshot> _stream = FirebaseFirestore.instance
      .collection('notes')
      .orderBy('date')
      .snapshots();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: myAppBar(authClass, context),
      body: Container(
        color: darkGreyClr,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            topBar(size, context),
            SizedBox(
              height: size.height * 0.05,
            ),
            Flexible(
              child: Container(
                  constraints: BoxConstraints(maxWidth: size.width * 0.8),
                  child: StreamBuilder<QuerySnapshot>(
                      stream: _stream,
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }

                        return ListView.builder(
                          itemBuilder: (context, index) {
                            Map<String, dynamic> document =
                                snapshot.data!.docs[index].data()
                                    as Map<String, dynamic>;
                            return GestureDetector(
                              onLongPress: () {
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Delete Note"),
                                      content: Text("Delete this note?"),
                                      actions: [
                                        TextButton(
                                          child: Text("Delete"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                        TextButton(
                                          child: Text("No"),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: noteCard(size, document['title']),
                            );
                          },
                          itemCount: snapshot.data!.docs.length,
                        );
                      })),
            )
          ],
        ),
      ),
    );
  }
}

// todo sort by time
AppBar myAppBar(AuthClass authClass, BuildContext context) {
  return AppBar(
    backgroundColor: whiteClr,
    elevation: 0,
    actions: [
      IconButton(
        onPressed: () async {
          await authClass.signOut(context: context);

          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (builder) => SignInPage(),
              ),
              (route) => false);
        },
        icon: const Icon(
          Icons.logout,
          color: darkGreyClr,
          size: 30,
        ),
      ),
      const SizedBox(
        width: 10,
      )
    ],
  );
}

Widget _noNotesWidget() {
  return Container(
    color: darkGreyClr,
    width: double.infinity,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const [
        SizedBox(
          height: 10,
        ),
        Text(
          'No Notes Added',
          style: TextStyle(
            color: darkRedClr,
            fontFamily: "Avenir",
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        )
      ],
    ),
  );
}

Widget topBar(Size size, BuildContext context) {
  return Stack(
    clipBehavior: Clip.none,
    children: <Widget>[
      Container(
        height: size.height * .15,
        decoration: const BoxDecoration(
          color: whiteClr,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(40),
            bottomRight: Radius.circular(40),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Intray",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 50,
                  color: greyClr,
                ),
              ),
            ],
          ),
        ),
      ),
      Positioned(
        // 30 is somehow a magical number here that makes the button
        // align right were i want
        // todo test on other phone sizes
        // ? works on a smaller phone, not sure if itll work on even smaller ones
        top: (size.height * 0.15) - 30,
        left: ((size.width) / 2) - 30,
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (builder) => AddNotePage(),
                ),
                (route) => false);
          },
          backgroundColor: darkRedClr,
          elevation: 5,
          child: const Icon(
            Icons.add,
            size: 55,
            color: Colors.white,
          ),
        ),
      )
    ],
  );
}

Widget noteCard(Size size, String? noteText) {
  return Container(
    margin: const EdgeInsets.only(top: 8, bottom: 16),
    padding: const EdgeInsets.only(right: 10, top: 10, bottom: 10),
    width: size.width * .8,
    // ! removing hardcoded height and moving text inside
    // ! expanded adjusts the height as per text length
    // height: size.height * 0.1,
    decoration: BoxDecoration(
      color: darkRedClr,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      children: [
        IconButton(
          onPressed: () {
            debugPrint("pressed");
          },
          icon: const Icon(
            Icons.radio_button_checked_outlined,
            color: greyClr,
          ),
        ),
        Expanded(
          child: Text(
            noteText!,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: greyClr,
            ),
          ),
        ),
      ],
    ),
  );
}
