class User {
  final int? id;
  final String name;
  final String email;
  final String password;
  final double height;
  final String createdAt;

  User({
    this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.height,
    required this.createdAt,
  });

  factory User.fromMap(Map<String, dynamic> json) => User(
        id: json['id'],
        name: json['name'],
        email: json['email'],
        password: json['password'],
        height: json['height'],
        createdAt: json['created_at'],
      );

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'height': height,
      'created_at': createdAt,
    };
  }
}
