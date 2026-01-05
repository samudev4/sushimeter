import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sushimeter/theme/theme_provider.dart';

class AppColors {
  /// 🔤 Color de texto
  static Color colorTexto(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    return isDark ? Color(0xFFE3E3E3) : Color(0xFF1F1F1F);
  }

  static Color colorTextoBoton(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    return isDark ? Color(0xFFFFFFFF) : Color(0xFFFFFFFF);
  }

  static Color colorFondoBoton(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    return isDark ? Color(0xFF004A77) : Color(0xFF004A77);
  }

  /// 🧱 Fondo principal (Scaffold)
  static Color colorFondoScaffold(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    return isDark ? const Color(0xFF1F1F1F) : const Color(0xFFFFFFFF);
  }

  static Color colorFondoAppBar(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    return isDark ? const Color(0xFF1F1F1F) : const Color(0xFFFFFFFF);
  }

  static Color colorFondoNavigationBar(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    return isDark ? const Color(0xFF1E1F20) : const Color(0XFFF0F4F9);
  }

  static Color colorIndicatorColor(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    return isDark ? const Color(0xFF004A77) : const Color(0XFFC2E7FF);
  }

  static Color colorIconosOff(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    return isDark ? const Color(0xFFC4C7C5) : const Color(0XFF444746);
  }

  static Color colorTextoOff(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    return isDark ? const Color(0xFFC4C7C5) : const Color(0XFF444746);
  }

  static Color colorTextoOn(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    return isDark ? const Color(0xFFE3E3E3) : const Color(0XFF1F1F1F);
  }

  static Color colorIconosOn(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    return isDark ? const Color(0xFFc2e7ff) : const Color(0XFF001D35);
  }

  static Color colorIconosApp(BuildContext context) {
    final isDark = context.watch<ThemeProvider>().isDark;
    return isDark ? const Color(0xFFFFFFFF) : const Color(0XFF001D35);
  }

  /// ⚙️ Colores fijos (no dependen del tema)
  //static const Color success = Color(0xFF4CAF50);
  //static const Color warning = Color(0xFFFFC107);
  static const Color error = Color(0xFFF44336);
}
