// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserAdapter extends TypeAdapter<User> {
  @override
  final int typeId = 2;

  @override
  User read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return User(
      username: fields[0] as String,
      password: fields[1] as String,
      profileType: fields[2] as UserProfileType,
      profileImagePath: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, User obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.username)
      ..writeByte(1)
      ..write(obj.password)
      ..writeByte(2)
      ..write(obj.profileType)
      ..writeByte(3)
      ..write(obj.profileImagePath);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class UserProfileTypeAdapter extends TypeAdapter<UserProfileType> {
  @override
  final int typeId = 1;

  @override
  UserProfileType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return UserProfileType.neurodivergente;
      case 1:
        return UserProfileType.responsavel;
      case 2:
        return UserProfileType.profissional;
      default:
        return UserProfileType.neurodivergente;
    }
  }

  @override
  void write(BinaryWriter writer, UserProfileType obj) {
    switch (obj) {
      case UserProfileType.neurodivergente:
        writer.writeByte(0);
        break;
      case UserProfileType.responsavel:
        writer.writeByte(1);
        break;
      case UserProfileType.profissional:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserProfileTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
