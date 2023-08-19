class TransactionInfo {
  final String referenceId;
  final String invoiceId;
  final double amount;
  final String currency;
  final String description;
  final String payerPhoneNumber;

  TransactionInfo({
    required this.referenceId,
    required this.invoiceId,
    required this.amount,
    required this.currency,
    required this.description,
    required this.payerPhoneNumber,
  });
}
