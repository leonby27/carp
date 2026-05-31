import '../../../l10n/app_localizations.dart';

typedef L10nGetter = String Function(AppLocalizations);

class MockPackage {
  const MockPackage({
    required this.id,
    required this.title,
    required this.periodLabel,
    required this.priceLabel,
    required this.priceShort,
    required this.pricePerPeriodShort,
    required this.hasTrial,
    this.trialDays,
  });

  final String id;

  /// Заголовок плана ("12 months" / "12 месяцев" / ...)
  final L10nGetter title;

  /// Длительность периода для disclaimer-помощи
  final L10nGetter periodLabel;

  /// Полная цена за период с указанием единицы — приходит из RC в проде,
  /// сейчас захардкожена в одной валюте.
  final String priceLabel;

  /// Короткая цена без периода
  final String priceShort;

  /// Цена в карточке плана коротко
  final String pricePerPeriodShort;

  final bool hasTrial;
  final int? trialDays;
}

final kMockPackages = <MockPackage>[
  MockPackage(
    id: 'yearly',
    title: (l) => l.planYearly,
    periodLabel: (l) => l.planYearly,
    priceLabel: '3 990 ₽ / год',
    priceShort: '3 990 ₽',
    pricePerPeriodShort: '76 ₽ / нед',
    hasTrial: true,
    trialDays: 3,
  ),
  MockPackage(
    id: 'weekly',
    title: (l) => l.planWeekly,
    periodLabel: (l) => l.planWeekly,
    priceLabel: '199 ₽ / неделя',
    priceShort: '199 ₽',
    pricePerPeriodShort: '199 ₽',
    hasTrial: false,
  ),
];

const kDefaultPackageId = 'yearly';
