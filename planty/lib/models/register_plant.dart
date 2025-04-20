import 'dart:io';

class RegisterPlant {
  final int plantId;
  final String nickname;
  final String adoptedDate;
  final int personalityId;
  final File? imageFile;

  RegisterPlant({
    required this.plantId,
    required this.nickname,
    required this.adoptedDate,
    required this.personalityId,
    this.imageFile,
  });
}
