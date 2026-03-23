import 'package:flutter/material.dart';

/// 主题模式提供者 - 使用 ChangeNotifier 管理主题状态
class ThemeProvider extends ChangeNotifier {
  /// 当前主题模式
  ThemeMode _themeMode = ThemeMode.light;
  ThemeMode get currentTheme => _themeMode;

  /// 是否为深色主题
  bool get isDarkMode => _themeMode == ThemeMode.dark;

  /// 切换主题
  void toggleTheme() {
    _themeMode = _themeMode == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    notifyListeners();
  }

  /// 设置为浅色主题
  void setLightTheme() {
    _themeMode = ThemeMode.light;
    notifyListeners();
  }

  /// 设置为深色主题
  void setDarkTheme() {
    _themeMode = ThemeMode.dark;
    notifyListeners();
  }

  /// 设置为系统主题
  void setSystemTheme() {
    _themeMode = ThemeMode.system;
    notifyListeners();
  }
}
