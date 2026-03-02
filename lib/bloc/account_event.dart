abstract class AccountEvent {}

class LoadAccounts extends AccountEvent {}

class CreateAccount extends AccountEvent {
  final String name;
  final double balance;
  final dynamic user_id;

  CreateAccount({
    required this.name,
    required this.balance,
    required this.user_id,
  });
}
