import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

class SettingsProvider extends ChangeNotifier {
  static const _keepScreenOnKey = 'keep_screen_on';

  bool _keepScreenOn = false;
  bool get keepScreenOn => _keepScreenOn;

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _keepScreenOn = prefs.getBool(_keepScreenOnKey) ?? false;

    // aplica el comportamiento nada más cargar
    await _applyWakelock(_keepScreenOn);

    notifyListeners();
  }

  Future<void> setKeepScreenOn(bool value) async {
    _keepScreenOn = value;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keepScreenOnKey, value);

    await _applyWakelock(value);
  }

  Future<void> _applyWakelock(bool enabled) async {
    if (enabled) {
      await WakelockPlus.enable();
    } else {
      await WakelockPlus.disable();
    }
  }
}
