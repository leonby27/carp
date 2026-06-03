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
    this.anchorPriceShort,
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

  /// «Обычная» цена после пробного периода — показывается в таймлайне как
  /// анкер (выше цены оформления, чтобы trial-цена выглядела выгоднее).
  /// Если null — в таймлайне используется [priceShort].
  final String? anchorPriceShort;
}

final kMockPackages = <MockPackage>[
  MockPackage(
    id: 'yearly',
    title: (l) => l.planYearly,
    periodLabel: (l) => l.planYearly,
    priceLabel: '\$29.99 / year',
    priceShort: '\$29.99 / year',
    pricePerPeriodShort: '\$2.50 / mo',
    hasTrial: true,
    trialDays: 3,
    anchorPriceShort: '\$39.99 / year',
  ),
  MockPackage(
    id: 'weekly',
    title: (l) => l.planWeekly,
    periodLabel: (l) => l.planWeekly,
    priceLabel: '\$7.99 / week',
    priceShort: '\$7.99 / week',
    pricePerPeriodShort: '\$7.99 / wk',
    hasTrial: false,
  ),
];

const kDefaultPackageId = 'yearly';
