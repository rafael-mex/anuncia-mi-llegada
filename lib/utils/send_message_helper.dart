import 'package:anuncia_mi_llegada/config/preferences/preferences_service.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class SendMessageHelper {
  static Future<bool> sendMessage(String mensajeFinal) async {
    final preferredApp = PreferencesService.whatMessagingAppYouWillUse.value;
    bool messageWasSent = false;

    if (preferredApp == "WhatsApp") {
      final Uri whatsappUri = Uri.parse("whatsapp://send?text=${Uri.encodeComponent(mensajeFinal)}");
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri);
        messageWasSent = true;
      }
    } else if (preferredApp == "Otros") {
      final ShareResult result = await SharePlus.instance.share(ShareParams(text: mensajeFinal));
      if (result.status == ShareResultStatus.success) {
        messageWasSent = true;
      }
    } else {
      final Uri smsUri = Uri.parse('sms:?body=${Uri.encodeComponent(mensajeFinal)}');
      if (await canLaunchUrl(smsUri)) {
        await launchUrl(smsUri);
        messageWasSent = true;
      }
    }

    return messageWasSent;

  }
}