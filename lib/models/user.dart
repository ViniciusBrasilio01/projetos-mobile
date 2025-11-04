import 'package:hive/hive.dart';

part 'user.g.dart';

/// Enumeração dos tipos de perfil disponíveis no aplicativo
@HiveType(typeId: 1)
enum UserProfileType {
  @HiveField(0)
  neurodivergente,

  @HiveField(1)
  responsavel,

  @HiveField(2)
  profissional,
}

/// Modelo de dados para representar um usuário no Hive
@HiveType(typeId: 2)
class User extends HiveObject {
  @HiveField(0)
  String username;

  @HiveField(1)
  String password;

  @HiveField(2)
  UserProfileType profileType;

  User({
    required this.username,
    required this.password,
    required this.profileType,
  });
}