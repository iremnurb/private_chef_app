class UserModel {
  final int? id;
  final String username;
  final String email;
  final String password;
  final String gender;
  final int height;
  final int age;
  final int weight;

  UserModel({
    this.id, // id nullable hale getirildi
    required this.username,
    required this.email,
    required this.password,
    required this.gender,
    required this.height,
    required this.age,
    required this.weight,
  });

  // JSON'dan UserModel'e dönüştürme metodu
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      password: json['password'],
      gender: json['gender'],
      height: json['height'],
      age: json['age'],
      weight: json['weight'],
    );
  }

  // UserModel'den JSON'a dönüştürme metodu
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'email': email,
      'password': password,
      'gender': gender,
      'height': height,
      'age': age,
      'weight': weight,
    };
  }

  // Kullanıcı bilgilerini güncellemek için copyWith metodu
  UserModel copyWith({
    int? id,
    String? username,
    String? email,
    String? password,
    String? gender,
    int? height,
    int? age,
    int? weight,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      gender: gender ?? this.gender,
      height: height ?? this.height,
      age: age ?? this.age,
      weight: weight ?? this.weight,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, username: $username, email: $email, gender: $gender, height: $height, age: $age, weight: $weight)';
  }
}
