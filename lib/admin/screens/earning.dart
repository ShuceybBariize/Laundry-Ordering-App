import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';

class transactionPayments extends StatelessWidget {
  const transactionPayments({super.key});

  // Future<void> readSuccessfulPayments() async {
  //   try {
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection('successful_payments')
  //         .get();

  //     // Iterate through the documents in the QuerySnapshot
  //     for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
  //       // Access the data in each document using documentSnapshot.data()
  //       Map<String, dynamic>? paymentData =
  //           documentSnapshot.data() as Map<String, dynamic>?;
  //       String referenceId = paymentData!['referenceId'];
  //       String invoiceId = paymentData['invoiceId'];
  //       double amount = paymentData['amount'];
  //       String currency = paymentData['currency'];
  //       String description = paymentData['description'];
  //       String payerPhoneNumber = paymentData['payerPhoneNumber'];

  //       // Use the retrieved data as needed (e.g., display it in the app, process it further, etc.)
  //       print('Reference ID: $referenceId');
  //       print('Invoice ID: $invoiceId');
  //       print('Amount: $amount');
  //       print('Currency: $currency');
  //       print('Description: $description');
  //       print('Payer Phone Number: $payerPhoneNumber');
  //     }
  //   } catch (e) {
  //     print('Error reading successful payments: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction Payments'),
        centerTitle: true,
      ),
      body: _buildPaymentList(),
    );
  }

  Widget _buildPaymentList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('successful_payments')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text('Error retrieving data'));
        }

        List<DocumentSnapshot> documents = snapshot.data!.docs;
        return ListView.builder(
          itemCount: documents.length,
          itemBuilder: (context, index) {
            Map<String, dynamic>? paymentData =
                documents[index].data() as Map<String, dynamic>?;
            String referenceId = paymentData?['referenceId'];
            String invoiceId = paymentData?['invoiceId'];
            double amount = paymentData?['amount']?.toDouble() ?? 0.0;
            String currency = paymentData?['currency'];
            String description = paymentData?['description'];
            String payerPhoneNumber = paymentData?['payerPhoneNumber'];

            return Padding(
              padding: const EdgeInsets.only(
                top: 20,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Reference ID:',
                            style: GoogleFonts.inter(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        Text(
                          ' $referenceId',
                          style: GoogleFonts.inter(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    const Divider(color: Colors.grey, height: 4, thickness: 4),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Transsection ID: ',
                            style: GoogleFonts.inter(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        Text(
                          ' $invoiceId',
                          style: GoogleFonts.inter(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Amount:',
                            style: GoogleFonts.inter(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        Text(
                          ' $amount $currency',
                          style: GoogleFonts.inter(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Payer Phone Number:',
                            style: GoogleFonts.inter(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        Text(
                          ' $payerPhoneNumber',
                          style: GoogleFonts.inter(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description:',
                            style: GoogleFonts.inter(
                                fontSize: 17, fontWeight: FontWeight.bold)),
                        Text(
                          ' $description',
                          style: GoogleFonts.inter(
                              fontSize: 16, fontWeight: FontWeight.w400),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
