import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:app/app.dart';
import 'package:app/core/l10n/locale_provider.dart';
import 'package:app/core/persistence/prefs_service.dart' as prefs_service;

void main() {
  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    await prefs_service.initPrefs();
  });

  testWidgets('BaseApp стартует с welcome (en)', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          localeProvider.overrideWith(_FixedLocale.new),
        ],
        child: const BaseApp(),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.text('Get started'), findsOneWidget);
  });
}

class _FixedLocale extends LocaleNotifier {
  @override
  Locale? build() => const Locale('en');
}
