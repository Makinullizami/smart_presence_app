/// User Model
class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String? photo;
  final String? nim;
  final String? faculty;
  final String? major;
  final DateTime? createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.photo,
    this.nim,
    this.faculty,
    this.major,
    this.createdAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      role: json['role'] as String,
      photo: json['photo'] as String?,
      nim: json['nim'] as String?,
      faculty: json['faculty'] as String?,
      major: json['major'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'role': role,
      'photo': photo,
      'nim': nim,
      'faculty': faculty,
      'major': major,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  String get roleDisplay {
    switch (role.toLowerCase()) {
      case 'mahasiswa':
        return 'Mahasiswa';
      case 'dosen':
        return 'Dosen';
      case 'admin':
        return 'Administrator';
      default:
        return role;
    }
  }

  String get initials {
    if (name.isEmpty) return 'U';
    final parts = name.split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? email,
    String? role,
    String? photo,
    String? nim,
    String? faculty,
    String? major,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      role: role ?? this.role,
      photo: photo ?? this.photo,
      nim: nim ?? this.nim,
      faculty: faculty ?? this.faculty,
      major: major ?? this.major,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
