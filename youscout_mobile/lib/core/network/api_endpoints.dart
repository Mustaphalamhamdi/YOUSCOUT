import 'dart:io';

// Centralised backend URLs.
// Android emulator routes `10.0.2.2` → host machine's localhost.
// iOS simulator can use `localhost` directly.
// Override _host if running on a physical device (use your machine's LAN IP).
abstract class ApiEndpoints {
  static String get _host {
    if (Platform.isAndroid) return '10.0.2.2';
    return 'localhost';
  }

  static String get identityBase => 'http://$_host:8081';
  static String get contentBase => 'http://$_host:8082';
  static String get discoveryBase => 'http://$_host:8083';

  // identity-profile-service
  static String get register => '$identityBase/api/v1/auth/register';
  static String get login => '$identityBase/api/v1/auth/login';
  static String get myProfile => '$identityBase/api/v1/profile/me';
  static String get updateProfile => '$identityBase/api/v1/profile/me';
  static String userProfile(String userId) => '$identityBase/api/v1/users/$userId';

  // content-service
  static String get uploadVideo => '$contentBase/api/v1/videos';
  static String get skills => '$contentBase/api/v1/skills';
  static String streamUrl(String videoId) => '$contentBase/api/v1/videos/$videoId/stream';

  // discovery-service
  static String get feed => '$discoveryBase/api/v1/feed';
  static String get follow => '$discoveryBase/api/v1/internal/follow';
}
