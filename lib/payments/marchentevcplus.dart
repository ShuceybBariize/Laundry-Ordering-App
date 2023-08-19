// ignore: depend_on_referenced_packages
import 'package:cloud_firestore/cloud_firestore.dart';

// ignore: depend_on_referenced_packages

// ignore: depend_on_referenced_packages
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

// Import the material package for the context andj other UI widgets.
import 'package:awesome_dialog/awesome_dialog.dart';

import '../exports.dart';
import 'classtransactionInfo.dart';
import 'iron_payment_screen.dart';

class MerchantEvcPlus {
  final String endPoint;
  final String merchantUid;
  final String apiUserId;
  final String apiKey;
  late String? address;

  MerchantEvcPlus(
      {this.endPoint = 'https://api.waafipay.net/asm',
      required this.merchantUid,
      required this.apiUserId,
      required this.apiKey,
      required this.address});

  Future<void> makePayment({
    required TransactionInfo transactionInfo,
    Function(TransactionInfo)? onSuccess,
    Function(String)? onFailure,
    Function()? onPaymentCancelled,
    BuildContext? context,
  }) async {
    HttpOverrides.global = MyHttpOverrides();

    try {
      http.Response response = await http.post(
        Uri.parse(endPoint),
        body: json.encode(
          {
            "schemaVersion": "1.0",
            "requestId": "101111003",
            "timestamp": "client_timestamp",
            "channelName": "WEB",
            "serviceName": "API_PURCHASE",
            "serviceParams": {
              "merchantUid": merchantUid,
              "apiUserId": apiUserId,
              "apiKey": apiKey,
              "address": address,
              "paymentMethod": "mwallet_account",
              "payerInfo": {"accountNo": transactionInfo.payerPhoneNumber},
              "transactionInfo": {
                "referenceId": transactionInfo.referenceId,
                "invoiceId": transactionInfo.invoiceId,
                "amount": transactionInfo.amount.toString(),
                "currency": transactionInfo.currency,
                "description": transactionInfo.description
              }
            }
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data["responseMsg"] == 'RCS_SUCCESS') {
          showAwesomeDialog(
            context: context!,
            title: 'Payment Success',
            description: 'Payment was successful!',
          );
          onSuccess?.call(transactionInfo);

          // Store the successful payment details in Firebase
          try {
            await FirebaseFirestore.instance
                .collection('successful_payments')
                .add({
              'referenceId': transactionInfo.referenceId,
              'address': address.toString(),
              'invoiceId': transactionInfo.invoiceId,
              'amount': transactionInfo.amount,
              'currency': transactionInfo.currency,
              'description': transactionInfo.description,
              'payerPhoneNumber': transactionInfo.payerPhoneNumber,
              'timestamp': FieldValue
                  .serverTimestamp(), // Add a server timestamp for the current time
            });
          } catch (e) {
            print('Error storing payment details in Firebase: $e');
          }
        } else {
          String message = '';
          var errMessage = data['responseMsg'].toString().split(':');
          if (errMessage.length < 2) {
            message = 'RCS_USER_IS_NOT_AUTHZ_TO_ACCESS_API';
          } else {
            message = errMessage[1].trim();
          }

          if (errMessage[0]
              .contains('RCS_TRAN_FAILED_AT_ISSUER_SYSTEM (User Aborted')) {
            // Payment was aborted by the user.
            showAwesomeDialog(
              context: context!,
              title: 'Payment Cancelled',
              description: 'Payment was cancelled by the user.',
            );
            onPaymentCancelled?.call();
          } else {
            print('Payment failed with error: $message');
            // Payment failed due to other reasons.
            // showAwesomeDialog(
            //   context: context!,
            //   title: 'Payment Failed',
            //   description: ,
            // );
            onFailure?.call('Payment failed with error: $message');
          }
        }
      } else {
        onFailure?.call(response.body);
      }
    } on SocketException {
      onFailure?.call('No Internet Connection');
    } catch (e) {
      print(e);
      onFailure?.call(e.toString());
    }
  }

  void showAwesomeDialog({
    required BuildContext context,
    required String title,
    required String description,
  }) {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.INFO,
      animType: AnimType.LEFTSLIDE,
      title: title,
      desc: description,
      btnOkOnPress: () {},
    ).show();
  }
}
