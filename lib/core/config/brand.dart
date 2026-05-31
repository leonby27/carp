import 'package:flutter/material.dart';

/// Единственный файл, который правится при клонировании шаблона в новый MVP.
///
/// Содержит: имя приложения, бренд-цвета, поддержка/sharing URL'ы, ссылки на
/// юридические документы. Не зашивайте эти константы в код напрямую — всегда
/// импортируйте через `Brand.*`.
///
/// Значения, которые меняются ПО ОКРУЖЕНИЯМ (dev/prod), приходят через
/// `--dart-define` и читаются в [Env].
class Brand {
  Brand._();

  // ── Идентичность ──────────────────────────────────────────
  static const String appName = 'CarpCast';

  // ── Цвета бренда ──────────────────────────────────────────
  /// Основной brand color: используется как primary в Material 3 теме.
  static const Color primaryColor = Color(0xFF1D8B53);

  /// Тёмный CTA для онбординга и paywall (контрастная кнопка на белом).
  static const Color ctaColor = Color(0xFF0E1220);

  /// Brand-green для акцентов: pricing card border, plan checkbox, trial badge.
  static const Color accentColor = Color(0xFF13633B);

  // ── Контакты / Share ──────────────────────────────────────
  /// Дефолты для local-сборок. В production — приходят через `--dart-define`.
  static const String defaultSupportEmail = 'support@example.com';
  static const String defaultShareLink = 'https://example.com/baseapp';

  // ── Юридические документы ─────────────────────────────────
  static const String termsUrl = 'https://example.com/terms';
  static const String privacyUrl = 'https://example.com/privacy';
}
