import 'package:ai_chat_bot/bloc/transaction_event.dart';
import 'package:ai_chat_bot/bloc/transaction_state.dart';
import 'package:ai_chat_bot/repository/transaction_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  final TransactionRepository repository;

  TransactionBloc(this.repository) : super(TransactionInitial()) {
    on<LoadTransactions>((event, emit) async {
      emit(TransactionLoading());
      try {
        final transactions = await repository.getTransactionsByAccountId(
          event.accountId,
        );
        emit(TransactionLoaded(transactions));
      } catch (e) {
        emit(TransactionError(e.toString()));
      }
    });

    on<LoadTransactionsByUserId>((event, emit) async {
      emit(TransactionLoading());
      try {
        final transactions = await repository.getTransactionsByUserId();
        emit(TransactionLoaded(transactions));
      } catch (e) {
        emit(TransactionError(e.toString()));
      }
    });
  }
}
