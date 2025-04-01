class UserModel {
  final String username;
  final String email;
  final String password;
  final String gender;
  final int height;
  final int age;
  final int weight;

  UserModel({
    required this.username,
    required this.email,
    required this.password,
    required this.gender,
    required this.height,
    required this.age,
    required this.weight,
  });

  Map<String, dynamic> toJson() => {
    'username': username,
    'email': email,
    'password': password,
    'gender': gender,
    'height': height,
    'age': age,
    'weight': weight,
  };

  // copyWith Metodu
  UserModel copyWith({
    String? username,
    String? email,
    String? password,
    String? gender,
    int? height,
    int? age,
    int? weight,
  }) {
    return UserModel(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      age: age ?? this.age,
      weight: weight ?? this.weight,
    );
  }
}
