class User {
  const User({
    required this.id,
    required this.username,
    required this.email,
    this.firstName = '',
    this.lastName = '',
  });
  final int id;
  final String username;
  final String email;
  final String firstName;
  final String lastName;

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: (json['id'] as num?)?.toInt() ?? 0,
        username: json['username'] as String? ?? '',
        email: json['email'] as String? ?? '',
        firstName: json['firstName'] as String? ?? '',
        lastName: json['lastName'] as String? ?? '',
      );
}

class Product {
  const Product({
    required this.id,
    required this.title,
    required this.price,
    required this.category,
    this.thumbnail = '',
  });
  final int id;
  final String title;
  final double price;
  final String category;
  final String thumbnail;

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: (json['id'] as num?)?.toInt() ?? 0,
        title: json['title'] as String? ?? 'Untitled product',
        price: (json['price'] as num?)?.toDouble() ?? 0,
        category: json['category'] as String? ?? 'General',
        thumbnail: json['thumbnail'] as String? ?? '',
      );
}

class Employee {
  const Employee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.role,
  });
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String role;

  String get fullName => '$firstName $lastName'.trim();

  factory Employee.fromJson(Map<String, dynamic> json) => Employee(
        id: (json['id'] as num?)?.toInt() ?? 0,
        firstName: json['firstName'] as String? ?? '',
        lastName: json['lastName'] as String? ?? '',
        email: json['email'] as String? ?? '',
        phone: json['phone'] as String? ?? '',
        role: json['role'] as String? ?? 'Employee',
      );

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'phone': phone,
        'role': role,
      };
}
