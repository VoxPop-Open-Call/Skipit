import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UrlLauncherUtils {
  UrlLauncherUtils._();

  static void openUrl(
    String url, {
    Function()? onSuccess,
    Function()? onFailure,
  }) async {
    try {
      await launchUrlString(url);
      onSuccess?.call();
    } catch (e) {
      onFailure?.call();
    }
  }

  static void openUri(
    Uri uri, {
    Function()? onSuccess,
    Function()? onFailure,
  }) async {
    try {
      await launchUrl(uri);
      onSuccess?.call();
    } catch (e) {
      onFailure?.call();
    }
  }
}
