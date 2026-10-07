class UserProfileModel {
  final String uid;
  final String email;
  final String name;
  final String? photoUrl;
  final bool isOnline;
  final DateTime? lastSeen;
  final DateTime createdAt;

  UserProfileModel({
    required this.uid,
    required this.email,
    required this.name,
    this.photoUrl,
    required this.isOnline,
    this.lastSeen,
    required this.createdAt,
  });

  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      uid: map['uid'] ?? '',
      email: map['email'] ?? '',
      name: map['name'] ?? '',
      photoUrl: map['photoUrl'],
      isOnline: map['isOnline'] ?? false,
      lastSeen: map['lastSeen'] != null
          ? (map['lastSeen'] as dynamic).toDate()
          : null,
      createdAt: (map['createdAt'] as dynamic).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'photoUrl': photoUrl,
      'isOnline': isOnline,
      'lastSeen': lastSeen,
      'createdAt': createdAt,
    };
  }
}
