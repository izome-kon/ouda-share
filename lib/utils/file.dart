import 'dart:io';

import 'package:listar_flutter_pro/models/model.dart';
import 'package:path_provider/path_provider.dart';

class UtilFile {
  static Future<String> getFilePath() async {
    final dir = await getTemporaryDirectory();
    return dir.path;
  }

  static Future<File?> loadFile(
    FileModel file, {
    String? directory,
  }) async {
    directory ??= await getFilePath();
    final filePath = '$directory/${file.name}.${file.type}';
    final exist = await File(filePath).exists();
    if (exist) {
      return File(filePath);
    }
    return null;
  }

  ///Singleton factory
  static final UtilFile _instance = UtilFile._internal();

  factory UtilFile() {
    return _instance;
  }

  UtilFile._internal();
}
