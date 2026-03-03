import 'package:ai_chat_bot/models/transaction.dart';

abstract class TransactionState {
  const TransactionState();
}

class TransactionInitial extends TransactionState {}

class TransactionLoading extends TransactionState {}

class TransactionLoaded extends TransactionState {
  final List<Transaction> transactions;

  const TransactionLoaded(this.transactions);
}

class TransactionCalculated extends TransactionState {
  final Map<String, double> summary;
  final List<Transaction> raw;

  const TransactionCalculated(this.summary, this.raw);
}

class TransactionError extends TransactionState {
  final String message;

  const TransactionError(this.message);
}
