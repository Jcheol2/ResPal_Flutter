import 'package:json_annotation/json_annotation.dart';

part 'User.g.dart'; // 코드 생성을 위한 파일 경로

@JsonSerializable()
class User {
  final String email;
  final String password;
  final String picture;
  final String nickname;
  final String provider;

  User(this.email, this.password, this.picture, this.nickname, this.provider);

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}