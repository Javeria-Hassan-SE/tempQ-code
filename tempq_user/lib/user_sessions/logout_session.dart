
import 'package:path_provider/path_provider.dart';

class UserSession{
  /// this will delete app's cache
  static Future<void> clearAppCache() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  /// this will delete app's storage
  static Future<void> clearAppStorage() async {
    final appDir = await getApplicationSupportDirectory();

    if(appDir.existsSync()){
      appDir.deleteSync(recursive: true);
    }
  }
}