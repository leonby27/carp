class Env {
  static const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
  static const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
  static const revenueCatIosKey = String.fromEnvironment('REVENUECAT_IOS_KEY');
  static const revenueCatAndroidKey = String.fromEnvironment('REVENUECAT_ANDROID_KEY');
  static const posthogApiKey = String.fromEnvironment('POSTHOG_KEY');
  static const posthogHost = String.fromEnvironment(
    'POSTHOG_HOST',
    defaultValue: 'https://eu.i.posthog.com',
  );
  static const sentryDsn = String.fromEnvironment('SENTRY_DSN');
  static const appName = String.fromEnvironment('APP_NAME', defaultValue: 'CarpCast');

  /// Email поддержки — кнопка Settings → Contact support открывает mailto:
  static const supportEmail =
      String.fromEnvironment('SUPPORT_EMAIL', defaultValue: 'support@example.com');

  /// Ссылка на приложение — для Share-листа.
  static const appShareLink = String.fromEnvironment(
    'APP_SHARE_LINK',
    defaultValue: 'https://example.com/baseapp',
  );
}
