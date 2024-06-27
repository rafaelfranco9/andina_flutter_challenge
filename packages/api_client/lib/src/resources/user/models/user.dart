import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// {@template closet}
/// Model representing a User.
/// {@endtemplate}
@freezed
abstract class User with _$User {
  /// {@macro closet}
  const factory User({
    required String id,
    required String name,
    required String email,
    required String nickname,
    @Default(false) bool isVerified,
  }) = _User;

  /// Returns a new [User] from the given [json].
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  /// Returns an empty [User].
  static const empty = User(
    id: '',
    name: '',
    email: '',
    nickname: '',
  );
}
