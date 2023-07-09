import 'package:firebase_auth/firebase_auth.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'dart:math';

import '../exports.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    Future<List<String>> getFieldValuesByEmail(String email) async {
      QuerySnapshot querySnapshot = await firestore
          .collection('customers')
          .where('email', isEqualTo: email)
          .get();

      List<String> fieldValues = [];

      if (querySnapshot.docs.isNotEmpty) {
        for (DocumentSnapshot documentSnapshot in querySnapshot.docs) {
          dynamic fieldValue = documentSnapshot.get('orderstatus');
          fieldValues.add(fieldValue.toString());
        }
      }
      return fieldValues;
    }

    // String email = 'your_email@example.com';

    // String? email = FirebaseAuth.instance.currentUser!.email;
    // String? user = FirebaseAuth.instance.currentUser!.email;
    // String value;
    // Future<String> displayStatusOrder() async {
    //   await Future.delayed(const Duration(seconds: 2));
    //   List<String> fieldValues = await getFieldValuesByEmail(user!);
    //   if (fieldValues.isNotEmpty) {
    //     print('Field Values:');
    //     for (String fieldValue in fieldValues) {
    //       print('the fieldvalue:  $fieldValue');
    //       value = fieldValue;
    //       print('the value: ' + value);
    //       return fieldValue;
    //     }
    //   } else {
    //     print('No matching documents found.');
    //   }
    //   return value;
    // }

    var today = DateTime.now();

    var dateFormat = DateFormat('dd-MM-yyyy');

    String currentDate = dateFormat.format(today);
    return Scaffold(
      appBar: AppBar(
        title: const Text("History"),
        centerTitle: true,
      ),
      body: Center(
        child: FutureBuilder<String>(
          // future: displayStatusOrder(),
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return snapshot.data!.isEmpty
                  ? Container()
                  : Column(
                      children: [
                        Histrory_Laundry(
                          orderStatus: snapshot.data,
                          time: currentDate.toString(),
                        ),
                        const Text("the filed is: ")
                      ],
                    );

              // return Text('Result: ${snapshot.data}');
            }
          },
        ),
      ),
    );
  }
}

class Histrory_Laundry extends StatelessWidget {
  final String? orderStatus;
  final String? time;
  const Histrory_Laundry({
    super.key,
    required this.orderStatus,
    required this.time,
  });

  // Column(
  //                   crossAxisAlignment: CrossAxisAlignment.center,
  //                   children: [
  //                     Histrory_Laundry(
  //                       orderStatus: items[index]['orderstatus'],
  //                       time: '',
  //                     ),
  //                     SizedBox(
  //                       height: 20,
  //                     ),
  //                     IconButton(onPressed: _fetch, icon: Icon(Icons.person))
  //                   ],
  //                 ),
  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your order",
                        style: GoogleFonts.inter(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          // wordSpacing: 0.5,
                          fontSize: 22,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        time!,
                        style: GoogleFonts.inter(
                          color: Kinactivetextcolor,
                          fontSize: 18,
                        ),
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Container(
                        height: 40,
                        width: 100,
                        decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(30)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              orderStatus!,
                              style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ]),
            const SizedBox(
              height: 10,
            ),
            const Divider(
              thickness: 1,
              height: 31,
              color: Colors.grey,
            ),
          ],
        ),
      ),
    );
  }
}
