import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ai_chat_bot/bloc/account_event.dart';
import 'package:ai_chat_bot/bloc/account_state.dart';
import 'package:ai_chat_bot/repository/account_repository.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final AccountRepository repository;

  AccountBloc(this.repository) : super(AccountInitial()) {
    on<LoadAccounts>((event, emit) async {
      emit(AccountLoading());
      try {
        final accounts = await repository.getAccounts();
        emit(AccountLoaded(accounts));
      } catch (e) {
        emit(AccountError(e.toString()));
      }
    });

    on<CreateAccount>((event, emit) async {
      try {
        await repository.createAccount(
          event.name,
          event.balance,
          event.user_id,
        );
        add(LoadAccounts()); // Reload accounts after creating
      } catch (e) {
        emit(AccountError(e.toString()));
      }
    });
  }
}
