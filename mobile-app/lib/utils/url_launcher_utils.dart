import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UrlLauncherUtils {
  UrlLauncherUtils._();

  static void openUrl(
    String url, {
    Function()? onSuccess,
    Function()? onFailure,
  }) async {
    if (await canLaunchUrlString(url)) {
      await launchUrlString(url);
      onSuccess?.call();
    } else {
      onFailure?.call();
    }
  }

  static void openUri(
    Uri uri, {
    Function()? onSuccess,
    Function()? onFailure,
  }) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      onSuccess?.call();
    } else {
      onFailure?.call();
    }
  }
}
