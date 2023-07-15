import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import '../exports.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'home_page.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final currentUser = FirebaseAuth.instance.currentUser!;
  TextEditingController comment = TextEditingController();
  bool isloading = false;
  final firestore = FirebaseFirestore.instance;
  register() async {
    try {
      isloading = true;
      setState(() {});
      var response = await firestore.collection('Comments').add({
        'comments': comment.text,
      });
    } catch (e) {
      print(e);
    }
    isloading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: double.infinity,
                  height: 300,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: const Color.fromARGB(255, 116, 236, 120),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        backgroundImage: AssetImage("assets/shuceyb.jpg"),
                        radius: 50,
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        currentUser.email!,
                        style: const TextStyle(letterSpacing: 2),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              Container(
                margin: const EdgeInsets.all(8),
                width: double.infinity,
                height: 200,
                child: TextField(
                  controller: comment,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      hintText: 'write your feedback',
                      hintStyle: const TextStyle(fontSize: 20),
                      labelStyle: const TextStyle(fontSize: 20)),
                  maxLines: 10,
                  cursorColor: Colors.green,
                ),
              ),
              const SizedBox(
                height: 22,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(180, 65),
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(57),
                  ),
                  side: const BorderSide(color: Colors.green, width: 3),
                  elevation: 0,
                ),
                onPressed: () {
                  register();
                },
                child: isloading
                    ? const CircularProgressIndicator(
                        color: Colors.white,
                      )
                    : const Text(
                        'Submit',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.normal),
                      ),
              ),
              const SizedBox(
                height: 22,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: IconButton(
                      onPressed: () {
                        openWhatsapp();
                      },
                      icon: (const FaIcon(
                        FontAwesomeIcons.whatsapp,
                        size: 35,
                        color: Colors.green,
                      )),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: IconButton(
                      onPressed: () {
                        openGmail();
                      },
                      icon: const Icon(Icons.email,
                          size: 35, color: Colors.green),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  Container(
                    decoration: const BoxDecoration(
                        shape: BoxShape.circle, color: Colors.white),
                    child: IconButton(
                      onPressed: () {
                        openCall();
                      },
                      icon:
                          const Icon(Icons.call, size: 35, color: Colors.green),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
