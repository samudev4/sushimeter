import 'package:sushimeter/constants/app_strings.dart';
import 'package:url_launcher/url_launcher.dart';

class UrlUtils {
  static Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception("No se pudo abrir la URL: $url");
    }
  }

  // --- ENVIAR EMAIL ---
  static Future<void> sendEmail(String email) async {
    final Uri emailUri = Uri(scheme: 'mailto', path: email);

    if (!await launchUrl(emailUri)) {
      throw Exception(AppStrings.textoNoSePudoAbirLaAppDeCorreo);
    }
  }

  // --- GITHUB LINKS ---
  static Future<void> openGitHubProfile(String username) {
    return openUrl("https://github.com/$username");
  }

  static Future<void> openGitHubRepo(String username, String repo) {
    return openUrl("https://github.com/$username/$repo");
  }

  static Future<void> openGitHubIssues(String username, String repo) {
    return openUrl("https://github.com/$username/$repo/issues");
  }

  static Future<void> openPrivacyPolicy() {
    return openUrl("https://sites.google.com/view/sushimeter-privacy");
  }
}
