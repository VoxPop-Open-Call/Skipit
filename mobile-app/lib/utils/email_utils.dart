import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_mailer/flutter_mailer.dart';
import 'package:lisbon_travel/utils/url_launcher_utils.dart';

class EmailUtils {
  EmailUtils._();

  static void sendEmail({
    required String email,
    required String subject,
    required String message,
    Function()? onSuccess,
    Function(String? error)? onError,
  }) async {
    final MailOptions mailOptions = MailOptions(
      body: message,
      subject: subject,
      recipients: [email],
    );
    final mailtoUri = Uri.parse('mailto:$email?body=$message&subject=$subject');

    if (Platform.isIOS) {
      final bool canSend = await FlutterMailer.canSendMail();
      if (!canSend) {
        UrlLauncherUtils.openUri(
          mailtoUri,
          onSuccess: () => onSuccess?.call(),
          onFailure: () => onError?.call(null),
        );
        return;
      }
    }

    try {
      final response = await FlutterMailer.send(mailOptions);
      if (response != MailerResponse.sent &&
          response != MailerResponse.android) {
        onError?.call(null);
      }
    } on PlatformException catch (error) {
      onError?.call(error.message);
    } catch (_) {
      onError?.call(null);
    }
  }
}
