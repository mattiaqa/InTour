import 'package:hive/hive.dart';

part 'profile_data.g.dart';

@HiveType(typeId: 0)
class Profile_Data {
  @HiveField(0)
  final String? userid;
  @HiveField(1)
  final String? birthdate;
  @HiveField(2)
  final String? email;
  @HiveField(3)
  final String? name;
  @HiveField(4)
  final String? surname;
  @HiveField(5)
  final List<String>? friends;

  Profile_Data({
    required this.userid,
    required this.birthdate,
    required this.email,
    required this.name,
    required this.surname,
    required this.friends,
  });

  factory Profile_Data.fromJson(Map<String, dynamic> json) {
    return Profile_Data(
        userid: json['_id'] ?? '',
        birthdate: json['birthdate'] ?? '',
        email: json['email'] ?? '',
        name: json['name'] ?? '',
        surname: json['surname'] ?? '',
        friends: json['friends'] ?? '');
  }
}
