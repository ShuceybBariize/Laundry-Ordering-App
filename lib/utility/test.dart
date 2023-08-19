import 'package:flutter/material.dart';

class ListTest extends StatelessWidget {
  const ListTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 140,
      width: 180,

      // color: Colors.amber,
      decoration: BoxDecoration(
          color: Colors.white,
          image: const DecorationImage(
            image: AssetImage("assets/shuceyb.jpg"),
          ),
          borderRadius: BorderRadius.circular(12)),
      child: Column(children: const [
        // Image(image: AssetImage("assets/shuceyb.jpg"), fit: BoxFit.cover),
        SizedBox(
          height: 12,
        ),
        // Text("data"),
      ]),
    );
  }
}
