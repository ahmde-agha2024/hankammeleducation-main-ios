import 'dart:convert';

// نموذج للـ Data
class LoginResponse {
  final bool success;
  final String message;
  final String jwt;
  final User user;

  LoginResponse({
    required this.success,
    required this.message,
    required this.jwt,
    required this.user,
  });

  // تحويل JSON إلى كائن Dart
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      success: json["data"]['success'],
      message: json["data"]['message'],
      jwt: json["data"]['jwt'],
      user: User.fromJson(json["data"]['user']),
    );
  }
}

// نموذج للمستخدم
class User {
  final int id;
  final String documentId;
  final String username;
  final String? email;
  final String provider;
  final String? resetPasswordToken;
  final String? confirmationToken;
  final bool confirmed;
  final bool blocked;
  final String firstName;
  final String lastName;
  final String? birthdate;
  final String phoneNumber;
  final String? otpToken;
  final String? otpTokenExpiration;
  final String gender;
  final String createdAt;
  final String updatedAt;
  final String publishedAt;
  final String? locale;
  final Role role;

  User({
    required this.id,
    required this.documentId,
    required this.username,
    this.email,
    required this.provider,
    this.resetPasswordToken,
    this.confirmationToken,
    required this.confirmed,
    required this.blocked,
    required this.firstName,
    required this.lastName,
    this.birthdate,
    required this.phoneNumber,
    this.otpToken,
    this.otpTokenExpiration,
    required this.gender,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    this.locale,
    required this.role,
  });

  // تحويل JSON إلى كائن Dart
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      documentId: json['documentId'],
      username: json['username'],
      email: json['email'],
      provider: json['provider'],
      resetPasswordToken: json['resetPasswordToken'],
      confirmationToken: json['confirmationToken'],
      confirmed: json['confirmed'],
      blocked: json['blocked'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      birthdate: json['birthdate'],
      phoneNumber: json['phone_number'],
      otpToken: json['otp_token'],
      otpTokenExpiration: json['otp_token_expiration'],
      gender: json['gender'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      publishedAt: json['publishedAt'],
      locale: json['locale'],
      role: Role.fromJson(json['role']),
    );
  }
}

// نموذج للدور (Role)
class Role {
  final int id;
  final String documentId;
  final String name;
  final String description;
  final String type;
  final String createdAt;
  final String updatedAt;
  final String publishedAt;
  final String? locale;

  Role({
    required this.id,
    required this.documentId,
    required this.name,
    required this.description,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.publishedAt,
    this.locale,
  });

  // تحويل JSON إلى كائن Dart
  factory Role.fromJson(Map<String, dynamic> json) {
    return Role(
      id: json['id'],
      documentId: json['documentId'],
      name: json['name'],
      description: json['description'],
      type: json['type'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
      publishedAt: json['publishedAt'],
      locale: json['locale'],
    );
  }
}
