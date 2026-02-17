class UserModel {
  final String uid;
  final String name;
  final String email;
  final bool themeMode;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.themeMode,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      themeMode: json['themeMode'],
    );
  }
}
