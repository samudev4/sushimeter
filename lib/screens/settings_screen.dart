import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ionicons/ionicons.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:sushimeter/constants/app_colors.dart';
import 'package:sushimeter/constants/app_strings.dart';
import 'package:sushimeter/settings/settings_provider.dart';
import 'package:sushimeter/theme/theme_provider.dart';
import 'package:sushimeter/utils/url_utils.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

String _appVersion = "";

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  void initState() {
    super.initState();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();

    if (!mounted) return;

    setState(() {
      _appVersion = info.version; // ✅ versionName
      // Si quieres también buildNumber:
      _appVersion = "${info.version} (${info.buildNumber})";
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.read<ThemeProvider>();
    final isDark = context.watch<ThemeProvider>().isDark;
    final keepScreenOn = context.watch<SettingsProvider>().keepScreenOn;
    return Scaffold(
      backgroundColor: AppColors.colorFondoScaffold(context),
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: AppColors.colorFondoAppBar(context),
        title: Text(
          AppStrings.textoAjustes,
          style: GoogleFonts.poppins(
            fontSize: 28,
            fontWeight: FontWeight.normal,
            color: AppColors.colorTexto(context),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 16, right: 16, top: 25),
        child: ListView(
          children: [
            Text(
              "Pantalla",
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.colorTexto(context),
              ),
            ),
            SwitchListTile(
              secondary: Icon(
                Icons.screen_lock_portrait_outlined,
                size: 26,
                color: AppColors.colorIconosApp(context),
              ),
              title: Text(
                "Mantener pantalla activa",
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.colorTexto(context),
                ),
              ),
              subtitle: Text(
                "Come sushi sin tener que estar todo el rato desbloqueando el móvil",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: AppColors.colorTexto(context),
                ),
              ),
              value: context.watch<SettingsProvider>().keepScreenOn,
              onChanged: (value) =>
                  context.read<SettingsProvider>().setKeepScreenOn(value),
            ),
            if (keepScreenOn)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  "Mantener la pantalla activa puede aumentar el consumo de batería.",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.colorTexto(context),
                  ),
                ),
              ),

            SizedBox(height: 32),
            Text(
              AppStrings.textoApariencia,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.colorTexto(context),
              ),
            ),
            SwitchListTile(
              secondary: Icon(
                Icons.dark_mode_outlined,
                size: 26,
                color: AppColors.colorIconosApp(context),
              ),
              title: Text(
                AppStrings.textoModoOscuro,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: AppColors.colorTexto(context),
                ),
              ),
              subtitle: Text(
                AppStrings.textoActivaElModoOscuroEnLaAplicacion,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: AppColors.colorTexto(context),
                ),
              ),
              value: isDark,
              onChanged: (value) => themeProvider.toggleTheme(value),
            ),
            SizedBox(height: 32),
            Text(
              AppStrings.textoGeneral,
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.colorTexto(context),
              ),
            ),
            ListTile(
              leading: Icon(
                Ionicons.information_circle_outline,
                size: 26,
                color: AppColors.colorTexto(context),
              ),
              contentPadding: EdgeInsets.zero,
              title: Text(
                AppStrings.textoVersion,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.colorTexto(context),
                ),
              ),
              subtitle: Text(
                _appVersion.isEmpty ? "..." : _appVersion,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: AppColors.colorTexto(context),
                ),
              ),
            ),
            ListTile(
              onTap: () => UrlUtils.openPrivacyPolicy(),
              leading: Icon(
                Icons.privacy_tip_outlined,
                size: 26,
                color: AppColors.colorIconosApp(context),
              ),
              contentPadding: EdgeInsets.zero,
              title: Text(
                AppStrings.textoPoliticaDePrivacidad,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.colorTexto(context),
                ),
              ),
              subtitle: Text(
                AppStrings.textoEchaUnVistazoANuestraPolitica,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: AppColors.colorTexto(context),
                ),
              ),
            ),
            ListTile(
              onTap: () => UrlUtils.sendEmail(AppStrings.email),
              leading: Icon(
                Icons.help_center_outlined,
                size: 26,
                color: AppColors.colorIconosApp(context),
              ),
              contentPadding: EdgeInsets.zero,
              title: Text(
                AppStrings.textoCentroDeAyuda,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.colorTexto(context),
                ),
              ),
              subtitle: Text(
                AppStrings.textoTienesAlgunaPregunta,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: AppColors.colorTexto(context),
                ),
              ),
            ),
            ListTile(
              onTap: () => UrlUtils.openGitHubRepo(
                AppStrings.githubUser,
                AppStrings.textoNombreApp.toLowerCase(),
              ),
              leading: Icon(
                Ionicons.logo_github,
                size: 26,
                color: AppColors.colorIconosApp(context),
              ),
              contentPadding: EdgeInsets.zero,
              title: Text(
                AppStrings.sushimeterEsDeCodigoAbierto,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.colorTexto(context),
                ),
              ),
              subtitle: Text(
                AppStrings.textoPuedesVerTodoElCodigoFuente,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: AppColors.colorTexto(context),
                ),
              ),
            ),
            ListTile(
              onTap: () => UrlUtils.openGitHubProfile(AppStrings.githubUser),
              leading: Icon(
                Ionicons.code_slash_outline,
                size: 26,
                color: AppColors.colorIconosApp(context),
              ),
              contentPadding: EdgeInsets.zero,
              title: Text(
                AppStrings.textoAcercaDe,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.colorTexto(context),
                ),
              ),
              subtitle: Text(
                AppStrings.textoAplicacionDesarrolladaYMantenida,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: AppColors.colorTexto(context),
                ),
              ),
            ),
            ListTile(
              onTap: () => UrlUtils.openGitHubIssues(
                AppStrings.githubUser,
                AppStrings.textoNombreApp.toLowerCase(),
              ),
              leading: Icon(
                Ionicons.bug_outline,
                size: 26,
                color: AppColors.colorIconosApp(context),
              ),
              contentPadding: EdgeInsets.zero,
              title: Text(
                AppStrings.textoInformarDeUnProblema,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.colorTexto(context),
                ),
              ),
              subtitle: Text(
                AppStrings.textoHasExperimentadoAlgunBug,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: AppColors.colorTexto(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
