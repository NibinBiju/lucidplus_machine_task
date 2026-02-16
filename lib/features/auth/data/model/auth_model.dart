class AuthModel {
  final String email;
  final String? name;

  final String password;

  AuthModel({required this.email, required this.password, this.name});
}
