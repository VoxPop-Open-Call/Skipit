import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:lisbon_travel/constants/styles.dart';
import 'package:lisbon_travel/generated/locale_keys.g.dart';
import 'package:lisbon_travel/logic/service/toast_manager.dart';
import 'package:lisbon_travel/models/enums/transport_type_enum.dart';
import 'package:lisbon_travel/utils/email_utils.dart';

class AccessibilityReportButton extends StatelessWidget {
  final TransportTypeEnum transportType;

  const AccessibilityReportButton({
    super.key,
    required this.transportType,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        String? targetEmail;
        switch (transportType) {
          case TransportTypeEnum.train:
            targetEmail = 'apoiocliente@cp.pt';
            break;
          case TransportTypeEnum.tram:
          case TransportTypeEnum.bus:
            targetEmail = 'atendimento@carris.pt';
            break;
          case TransportTypeEnum.metro:
            targetEmail = 'atendimento@metrolisboa.pt';
            break;
          default:
            break;
        }

        if (targetEmail != null) {
          EmailUtils.sendEmail(
            email: targetEmail,
            subject: 'subject', // todo
            message: 'message', // todo
            onError: (error) => GetIt.I<ToastManager>()
                .error(error ?? LocaleKeys.cError_sendEmail.tr()),
          );
        }
      },
      style: $styles.button.primaryTextButtonStyle,
      child: const Text('Report'),
    );
  }
}
