import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../constans/colors.dart';

class ReportView extends StatefulWidget {
  const ReportView({super.key});

  @override
  State<ReportView> createState() => _ReportViewState();
}

class _ReportViewState extends State<ReportView> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Reports View'),
          centerTitle: true,
        ),
        body: _buildPaymentList(),
      ),
    );
  }

  int? rating5 = 0;
  int? rating4 = 0;
  int? rating3 = 0;
  int? rating2 = 0;
  int? rating1 = 0;
  Future<int> calculateSumOfRatingsEqualFive() async {
    int sum = 0;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('feedback')
        .where('rating', isEqualTo: 5)
        .get();

    List<QueryDocumentSnapshot> feedbackDocs = querySnapshot.docs;

    for (var doc in feedbackDocs) {
      FeedbackModel feedback = FeedbackModel(doc['rating']);
      sum += feedback.rating;
      rating5 = rating5! + 1;
    }

    return sum;
  }

  Future<int> calculateSumOfRatingsEqualFour() async {
    int sum = 0;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('feedback')
        .where('rating', isEqualTo: 4)
        .get();

    List<QueryDocumentSnapshot> feedbackDocs = querySnapshot.docs;

    for (var doc in feedbackDocs) {
      FeedbackModel feedback = FeedbackModel(doc['rating']);
      sum += feedback.rating;

      rating4 = rating4! + 1;
    }

    return sum;
  }

  Future<int> calculateSumOfRatingsEqualThree() async {
    int sum = 0;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('feedback')
        .where('rating', isEqualTo: 3)
        .get();

    List<QueryDocumentSnapshot> feedbackDocs = querySnapshot.docs;

    for (var doc in feedbackDocs) {
      FeedbackModel feedback = FeedbackModel(doc['rating']);
      sum += feedback.rating;

      rating3 = rating3! + 1;
    }

    return sum;
  }

  Future<int> calculateSumOfRatingsEqualTwo() async {
    int sum = 0;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('feedback')
        .where('rating', isEqualTo: 2)
        .get();

    List<QueryDocumentSnapshot> feedbackDocs = querySnapshot.docs;

    for (var doc in feedbackDocs) {
      FeedbackModel feedback = FeedbackModel(doc['rating']);
      sum += feedback.rating;

      rating2 = rating2! + 1;
    }

    return sum;
  }

  Future<int> calculateSumOfRatingsEqualOne() async {
    int sum = 0;
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('feedback')
        .where('rating', isEqualTo: 1)
        .get();

    List<QueryDocumentSnapshot> feedbackDocs = querySnapshot.docs;

    for (var doc in feedbackDocs) {
      FeedbackModel feedback = FeedbackModel(doc['rating']);
      sum += feedback.rating;

      rating1 = rating1! + 1;
    }

    return sum;
  }

  Widget _buildPaymentList() {
    calculateSumOfRatingsEqualFive();
    calculateSumOfRatingsEqualFour();
    calculateSumOfRatingsEqualThree();
    calculateSumOfRatingsEqualTwo();
    calculateSumOfRatingsEqualOne();
    print('the riting 5 is: $rating5');
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('feedback')
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error retrieving data'));
        }

        List<DocumentSnapshot> documents = snapshot.data!.docs;
        final Set<int> uniqueFields = <int>{};
        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            Map<String, dynamic>? paymentData =
                documents[index].data() as Map<String, dynamic>?;
            String comment = paymentData?['comment'];
            int rating = paymentData?['rating'];
            String name = paymentData?['Name'];
            String phone = paymentData?['Phone'];
            String email = paymentData?['Email'];
            Timestamp timestamp = paymentData?['timestamp'];
            DateTime transactionTime = timestamp.toDate();
            final field = documents.length;
            if (!uniqueFields.contains(field)) {
              uniqueFields.add(field);
              return Container(
                margin: const EdgeInsets.all(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          const Column(
                            children: [
                              Text(
                                '⭐⭐⭐⭐⭐:  ',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '⭐⭐⭐⭐:  ',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '⭐⭐⭐:  ',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '⭐⭐:  ',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                '⭐:   ',
                                style: TextStyle(
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            children: [
                              Text(
                                '${((rating5! / field) * 100).toStringAsFixed(1)}%',
                                style: const TextStyle(
                                    fontSize: 16, color: kFiveStarColor),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${((rating4! / field) * 100).toStringAsFixed(1)}%',
                                style: const TextStyle(
                                    fontSize: 16, color: kFourStarColor),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${((rating3! / field) * 100).toStringAsFixed(1)}%',
                                style: const TextStyle(
                                    fontSize: 16, color: kThreeStarColor),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${((rating2! / field) * 100).toStringAsFixed(1)}%',
                                style: const TextStyle(
                                    fontSize: 16, color: kTwoStarColor),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '${((rating1! / field) * 100).toStringAsFixed(1)}%',
                                style: const TextStyle(
                                    fontSize: 16, color: kOneStarColor),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      const Text(
                        "Rating Users",
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Card(
                            elevation: 0,
                            color: Colors.grey[200],
                            child: Row(
                              children: [
                                const SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Name:',
                                      style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Email:',
                                      style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Phone:',
                                      style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Feedback:',
                                      style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'Rating:',
                                      style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      'timestamp :',
                                      style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                                const SizedBox(width: 10),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ' $name',
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      ' $email',
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      ' $phone',
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      ' $comment',
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      ' $rating',
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    Text(
                                      ' ${transactionTime.toString()}',
                                      style: GoogleFonts.inter(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                // const Column(
                                //   children: [
                                //     Divider(
                                //       height: 55,
                                //       color: Colors.black,
                                //     ),
                                //   ],
                                // )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 20),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Card(
                    elevation: 0,
                    color: Colors.grey[200],
                    child: Row(
                      children: [
                        const SizedBox(width: 15),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Name:',
                              style: GoogleFonts.inter(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Email:',
                              style: GoogleFonts.inter(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Phone:',
                              style: GoogleFonts.inter(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Feedback:',
                              style: GoogleFonts.inter(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'Rating:',
                              style: GoogleFonts.inter(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            Text(
                              'timestamp :',
                              style: GoogleFonts.inter(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ' $name',
                              style: GoogleFonts.inter(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              ' $email',
                              style: GoogleFonts.inter(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              ' $phone',
                              style: GoogleFonts.inter(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              ' $comment',
                              style: GoogleFonts.inter(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              ' $rating',
                              style: GoogleFonts.inter(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              ' ${transactionTime.toString()}',
                              style: GoogleFonts.inter(
                                  fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        // const Column(
                        //   children: [
                        //     Divider(
                        //       height: 55,
                        //       color: Colors.black,
                        //     ),
                        //   ],
                        // )
                      ],
                    ),
                  ),
                ),
              );
            }
            // ignore: dead_code
            return null;
          },
        );
      },
    );
  }
}

class FeedbackModel {
  final int rating;

  FeedbackModel(this.rating);
}
