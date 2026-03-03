abstract class TransactionEvent {
  const TransactionEvent();
}

class LoadTransactions extends TransactionEvent {
  final int accountId;

  const LoadTransactions(this.accountId);
}

class LoadTransactionsByUserId extends TransactionEvent {
  const LoadTransactionsByUserId();
}
