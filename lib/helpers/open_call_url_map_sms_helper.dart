import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

openDeveloperAppOnPlayStore() async {
  String url = 'https://play.google.com/store/apps/dev?id=5439194968291709425';

  if (await canLaunchUrl(Uri.parse(url))) {
    await launchUrl(Uri.parse(url),mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch $url';
  }
}

openNewEmail(String mail) async {
  final Uri params = Uri(scheme: 'mailto', path: mail, query: 'subject=Write your problems here...');
  if (await canLaunchUrl(params)) {
    await launchUrl(params);
  } else {
    throw 'Could not launch ${params.toString()}';
  }
}
