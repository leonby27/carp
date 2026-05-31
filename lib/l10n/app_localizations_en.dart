// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeTitle => 'Carp bite forecast';

  @override
  String get welcomeSubtitle => 'Quick setup — under a minute';

  @override
  String get welcomeCta => 'Get started';

  @override
  String get languageSheetTitle => 'Language';

  @override
  String get languageSheetSubtitle => 'Choose your language';

  @override
  String get themeSheetSubtitle => 'Choose how the app looks';

  @override
  String get languageEn => 'English';

  @override
  String get languageRu => 'Русский';

  @override
  String get languageDe => 'Deutsch';

  @override
  String get languageEs => 'Español';

  @override
  String get languageFr => 'Français';

  @override
  String get langShortEn => 'EN';

  @override
  String get langShortRu => 'RU';

  @override
  String get langShortDe => 'DE';

  @override
  String get langShortEs => 'ES';

  @override
  String get langShortFr => 'FR';

  @override
  String get commonContinue => 'Continue';

  @override
  String get quizQ1Question => 'What do you fish for?';

  @override
  String get quizQ1Subtitle => 'We\'ll tune the forecast to your fish';

  @override
  String get quizQ1OptLearn => 'Carp';

  @override
  String get quizQ1OptHabit => 'Crucian carp';

  @override
  String get quizQ1OptSolve => 'Both';

  @override
  String get quizQ2Question => 'Drove out, no bite?';

  @override
  String get quizQ2Subtitle => 'Be honest — it helps us help you';

  @override
  String get quizQ2OptDaily => 'Yes, more than once';

  @override
  String get quizQ2OptWeekly => 'Sometimes';

  @override
  String get quizQ2OptRarely => 'Rarely — I usually catch';

  @override
  String get quizQ3Question => 'How do you plan trips?';

  @override
  String get quizQ3Subtitle => 'Decides what we show you first';

  @override
  String get quizQ3OptSimple => 'I plan ahead';

  @override
  String get quizQ3OptResult => 'I go spontaneously';

  @override
  String get quizQ3OptFlexible => 'It varies';

  @override
  String get quizQ4Question => 'How often do you fish?';

  @override
  String get quizQ4Subtitle => 'We\'ll alert you to the best days';

  @override
  String get quizQ4OptWeekly => 'Every week';

  @override
  String get quizQ4OptMonthly => 'A couple times a month';

  @override
  String get quizQ4OptRarely => 'Now and then';

  @override
  String get onbAnalyzingTitle => 'Analyzing conditions';

  @override
  String get onbAnalyzingSubtitle =>
      'Crunching weather, pressure and the moon…';

  @override
  String get onbResultTitle => 'Your bite forecast is ready';

  @override
  String get onbResultSubtitle =>
      'Today\'s bite is free. The 7-day forecast unlocks with a subscription.';

  @override
  String get onbResultTodayBadge => 'Today · free';

  @override
  String get onbResultLockedLabel => '7-day forecast';

  @override
  String get onbResultCta => 'See my forecast';

  @override
  String get paywallSkipToday => 'See today for free first';

  @override
  String get paywallTitle => 'Unlock the full bite forecast';

  @override
  String get planYearly => '12 months';

  @override
  String get planWeekly => 'Week';

  @override
  String trialBadgeFreeDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days free',
      one: '$days day free',
    );
    return '$_temp0';
  }

  @override
  String trialDayLabel(int n) {
    return 'Day $n';
  }

  @override
  String get trialDay1Desc => 'Access unlocked';

  @override
  String get trialDayMidDesc => 'We\'ll remind you a day before';

  @override
  String get trialDayEndDesc => 'Subscription starts';

  @override
  String get featureUnlimited => 'Forecast for all your spots';

  @override
  String get featureUpdates => 'Hourly bite windows, updated daily';

  @override
  String get featurePrivacy => 'Works anywhere, data stays private';

  @override
  String get featureSupport => 'Priority support';

  @override
  String get faqTitle => 'Frequently asked';

  @override
  String get faqCancelQ => 'Can I cancel?';

  @override
  String get faqCancelA =>
      'Yes, anytime through your App Store or Google Play settings. If you cancel before the trial ends, you won\'t be charged.';

  @override
  String get faqChargeQ => 'When will I be charged?';

  @override
  String get faqChargeA =>
      'If you chose a free trial — after it ends. We\'ll remind you a day before so you can decide.';

  @override
  String get faqIncludesQ => 'What\'s included in the subscription?';

  @override
  String get faqIncludesA =>
      'The full bite forecast for all your spots, hourly biting windows, regular updates and priority support.';

  @override
  String get paywallNoPaymentNow => 'No payment now';

  @override
  String get paywallCtaStartFree => 'Start free trial';

  @override
  String get paywallCtaSubscribe => 'Subscribe';

  @override
  String get paywallDisclaimer => 'Auto-renews. Cancel anytime';

  @override
  String get menuRestore => 'Restore purchases';

  @override
  String get menuTerms => 'Terms of use';

  @override
  String get menuPrivacy => 'Privacy policy';

  @override
  String get menuPromo => 'Have a code?';

  @override
  String get menuRestart => 'Start over';

  @override
  String get promoTitle => 'Enter promo code';

  @override
  String get promoSubtitle => 'If you have an activation code — enter it below';

  @override
  String get promoCtaActivate => 'Activate';

  @override
  String get promoErrorInvalid => 'Invalid code';

  @override
  String promoSuccess(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days days',
      one: '$days day',
    );
    return 'Subscription activated for $_temp0';
  }

  @override
  String get homeTitle => 'Home';

  @override
  String get homeSubNotActive => 'Subscription not active';

  @override
  String get homeOnboardingNotDone => 'Onboarding not completed';

  @override
  String get homeAnswersLabel => 'Your answers:';

  @override
  String get homeBtnReplayOnboarding => 'Restart onboarding';

  @override
  String get homeBtnToPaywall => 'To paywall';

  @override
  String get homeBtnResetSub => 'Reset subscription';

  @override
  String homePremiumBadge(String remaining) {
    return 'Premium active · $remaining left';
  }

  @override
  String remainingDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n days',
      one: '$n day',
    );
    return '$_temp0';
  }

  @override
  String remainingHours(int n) {
    return '${n}h';
  }

  @override
  String remainingMinutes(int n) {
    return '${n}m';
  }

  @override
  String get tabHome => 'Home';

  @override
  String get tabAnalytics => 'Analytics';

  @override
  String get tabSettings => 'Settings';

  @override
  String get homeTabEmpty => 'Home tab is empty for now';

  @override
  String get analyticsTabEmpty => 'Analytics tab is empty for now';

  @override
  String get settingsSubscriptionTitle => 'Subscription';

  @override
  String get settingsSubActive => 'Premium active';

  @override
  String get settingsSubInactive => 'Subscription not active';

  @override
  String settingsSubExpiresLeft(String remaining) {
    return '$remaining left';
  }

  @override
  String get settingsSubBtnGoPaywall => 'Activate subscription';

  @override
  String get settingsSubBtnManage => 'Manage subscription';

  @override
  String get settingsRestartOnboarding => 'Restart onboarding';

  @override
  String get restartConfirmTitle => 'Restart onboarding?';

  @override
  String get restartConfirmMessage =>
      'Your answers will be cleared and you\'ll go back to the welcome screen.';

  @override
  String get commonCancel => 'Cancel';

  @override
  String get commonConfirm => 'Restart';

  @override
  String get commonUndo => 'Undo';

  @override
  String get commonDelete => 'Delete';

  @override
  String get tabNotes => 'Notes';

  @override
  String get noteNew => 'Note';

  @override
  String get notesEmptyTitle => 'No notes yet';

  @override
  String get notesEmptySubtitle =>
      'Jot down your fishing observations: bite, bait, weather.';

  @override
  String get noteNewTitle => 'New note';

  @override
  String get noteEditTitle => 'Note';

  @override
  String get noteTextHint => 'What did you notice? Bite, bait, weather…';

  @override
  String get noteLocationLabel => 'Location';

  @override
  String get noteLocationNone => 'No location';

  @override
  String get notePhotosLabel => 'Photos';

  @override
  String get notePhotoCamera => 'Camera';

  @override
  String get notePhotoGallery => 'Gallery';

  @override
  String get noteConditionsTitle => 'Conditions when noted';

  @override
  String get noteSave => 'Save note';

  @override
  String get noteDeleteConfirm => 'Delete note?';

  @override
  String get noteDeleted => 'Note deleted';

  @override
  String get noteEmptyError => 'Add text or a photo';

  @override
  String get noteDiscardTitle => 'Discard changes?';

  @override
  String get noteDiscard => 'Discard';

  @override
  String get settingsNotificationsTitle => 'Notifications';

  @override
  String get settingsNotifMaster => 'All notifications';

  @override
  String get settingsNotifReminders => 'Reminders';

  @override
  String get settingsNotifNews => 'News & updates';

  @override
  String get settingsAboutTitle => 'About';

  @override
  String get settingsRateApp => 'Rate the app';

  @override
  String get settingsShareApp => 'Share with friends';

  @override
  String get settingsContactSupport => 'Contact support';

  @override
  String shareMessage(String appName, String appLink) {
    return 'Check out $appName — $appLink';
  }

  @override
  String supportEmailSubject(String appName) {
    return 'Help with $appName';
  }

  @override
  String supportEmailBody(
    String appName,
    String version,
    String build,
    String platform,
    String locale,
  ) {
    return '\n\n\n---\nApp: $appName v$version ($build)\nPlatform: $platform\nLocale: $locale';
  }

  @override
  String appVersionFooter(String appName, String version, String build) {
    return '$appName · v$version ($build)';
  }

  @override
  String get settingsAppearanceTitle => 'Appearance';

  @override
  String get settingsLanguage => 'Language';

  @override
  String get settingsUnitsTitle => 'Units';

  @override
  String get unitTemperature => 'Temperature';

  @override
  String get unitWind => 'Wind';

  @override
  String get unitPressure => 'Pressure';

  @override
  String get settingsMoreTitle => 'More';

  @override
  String get settingsSubInactiveSubtitle => 'Unlock all features';

  @override
  String get settingsThemeTitle => 'Theme';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Light';

  @override
  String get themeDark => 'Dark';

  @override
  String mockPurchase(String plan) {
    return 'Mock purchase: $plan';
  }

  @override
  String get mockRestore => 'Mock: purchases restored';

  @override
  String get tabForecast => 'Forecast';

  @override
  String get locCurrent => 'My location';

  @override
  String get locDefault => 'Default location';

  @override
  String get locationSheetTitle => 'Location';

  @override
  String get locFallbackBanner =>
      'Location is off — showing the default spot. Forecast may not match your area.';

  @override
  String get locFallbackAction => 'Choose';

  @override
  String get fcLoading => 'Loading forecast…';

  @override
  String get fcError => 'Couldn\'t load forecast';

  @override
  String get fcErrorSubtitle => 'Check your connection and try again';

  @override
  String get fcRetry => 'Retry';

  @override
  String get fcRefresh => 'Refresh weekly forecast';

  @override
  String get fcRefreshing => 'Updating forecast…';

  @override
  String get fcRefreshStep1 => 'Fetching the weather…';

  @override
  String get fcRefreshStep2 => 'Reading pressure and wind…';

  @override
  String get fcRefreshStep3 => 'Checking the moon phase…';

  @override
  String get fcRefreshStep4 => 'Finding the bite windows…';

  @override
  String get fcRefreshStep5 => 'Recalculating the index…';

  @override
  String fcUpdatedAt(String time) {
    return 'updated at $time';
  }

  @override
  String get fcUpdatedJustNow => 'updated just now';

  @override
  String fcUpdatedMinAgo(int minutes) {
    return 'updated $minutes min ago';
  }

  @override
  String fcUpdatedHoursAgo(int hours) {
    return 'updated $hours h ago';
  }

  @override
  String fcUpdatedDate(String date) {
    return 'updated $date';
  }

  @override
  String fcOfflineUpdated(String age) {
    return 'offline · $age';
  }

  @override
  String get fcFactorGood => 'good';

  @override
  String get fcFactorNeutral => 'neutral';

  @override
  String get fcFactorWeak => 'weak';

  @override
  String get tabSpots => 'Spots';

  @override
  String get spotsActiveTitle => 'Active spot';

  @override
  String get spotsSavedTitle => 'Saved spots';

  @override
  String get spotsUseCurrent => 'Use current location';

  @override
  String get spotsEmpty => 'No saved spots yet.\nAdd one on the map.';

  @override
  String get spotsAddOnMap => 'Add on map';

  @override
  String get spotPickerTitle => 'Pick a spot';

  @override
  String get spotNameHint => 'Spot name (optional)';

  @override
  String get spotSaveBtn => 'Save spot';

  @override
  String get spotSaveActive => 'Save';

  @override
  String get spotNameDialogTitle => 'Spot name';

  @override
  String get spotEdit => 'Edit';

  @override
  String spotDefaultName(int n) {
    return 'Spot $n';
  }

  @override
  String get spotDeleted => 'Spot deleted';

  @override
  String get spotDeleteConfirm => 'Delete spot?';

  @override
  String get spotSearchHint => 'Search a place';

  @override
  String get spotNothingFound => 'Nothing found';

  @override
  String get spotLocationUnavailable => 'Couldn\'t get your location';

  @override
  String get fcToday => 'Today';

  @override
  String get fcTomorrow => 'Tomorrow';

  @override
  String get fcIndexCaption => 'Bite index';

  @override
  String get fcBestWindow => 'Best window';

  @override
  String get fcBestWindowEmpty => 'Weak activity all day';

  @override
  String get fcHourlyTitle => 'Hourly';

  @override
  String get fcWeekTitle => '7-day outlook';

  @override
  String get fcUpcomingDays => 'Upcoming days';

  @override
  String get fcSeeWeek => 'See week';

  @override
  String get fcWhyTitle => 'Why this score';

  @override
  String get fcHowItWorksBtn => 'How the forecast works';

  @override
  String get fcHowItWorksTitle => 'How the forecast works';

  @override
  String get fcHowItWorksP1Title => 'A smart model, not a coin toss';

  @override
  String get fcHowItWorksP1Body =>
      'Behind every score is a model that pulls together dozens of weather factors each day — atmospheric pressure and its swings, wind speed and direction, air and water temperature, cloud cover, precipitation, the moon phase and the season. We weigh each one and turn it into a single, clear bite score.';

  @override
  String get fcHowItWorksP2Title => 'Tuned to your water';

  @override
  String get fcHowItWorksP2Body =>
      'A lake, river, pond and reservoir each live by their own rules. The algorithm factors in the type of water and its traits to pinpoint where and when fish are more likely to be active right at your spot.';

  @override
  String get fcHowItWorksP3Title => 'Built on fish behaviour';

  @override
  String get fcHowItWorksP3Body =>
      'Fish react to weather in predictable ways — chasing comfortable temperature, oxygen and food. We bake those patterns in and translate them into concrete tips: where to set up, what depth to work and which hours to wait for the bite.';

  @override
  String get fcHowItWorksP4Title => 'The best time and place';

  @override
  String get fcHowItWorksP4Body =>
      'We forecast not just today but days ahead and highlight the strongest bite windows — so you plan your session for the most promising day and hour instead of guessing.';

  @override
  String get fcHowItWorksDisclaimer =>
      'It\'s a probability, not a promise. On the water, always read the spot and experiment — location, bait, timing.';

  @override
  String get storyTitle => 'Anatomy of the bite';

  @override
  String get storySubtitle => 'Why it isn\'t reading tea leaves';

  @override
  String get storyHookTitle => 'Biting isn\'t a lottery';

  @override
  String get storyHookBody =>
      'Fish are cold-blooded: no \"mood\", just a response to water and sky. Pressure drops, water warms, the wind picks up — appetite shifts. We learned to read those signals and fold them into one score. Here\'s what goes into it.';

  @override
  String get storyPressureTitle => 'A barometer and a thermometer';

  @override
  String get storyPressureBody =>
      'A fish has a built-in barometer — its swim bladder. A sharp pressure jump stuns it; a slow drop before bad weather flips the feeding on. All of it plays out against water temperature, which lags the air — a small pond wakes in days, a big lake in weeks — so we model the water\'s inertia and tune it to your venue. Cold water: sluggish on the bottom. Warmed up: out feeding.';

  @override
  String get storyWindTitle => 'Wind and the hour';

  @override
  String get storyWindBody =>
      'Wind is the angler\'s friend: it pushes warm water and food to the downwind bank and adds oxygen — that\'s where fish gather. And everyone has their hour: carp love dusk and a warm night, crucian the morning, while a hot midday shuts the bite down. The moon nudges it a little. So the score shifts not just by day, but by hour.';

  @override
  String get storyTypeTitle => 'Every water has a character';

  @override
  String get storyTypeBody =>
      'A lake, river, pond, canal and reservoir each live their own way. On big water fish follow the wind; on a river they hold to bends, pits and the slack below rapids; in a small pond they hug the reeds and snags. We identify your water from the OpenStreetMap map — its type and size — and tune both the water-warming model and the where-to-look tips to your venue.';

  @override
  String get storyFishTitle => 'Carp ≠ crucian';

  @override
  String get storyFishBody =>
      'One engine, two characters — and you mustn\'t mix them up. Carp is a cautious gourmet: it loves warm water, a slow pressure drop before bad weather, and feeds even at night. Crucian is fussier about swings, wakes later and fills up fast, yet it\'s absurdly hardy — a stuffy warm puddle that troubles carp suits it just fine. So we score each by its own profile: temperature thresholds, pressure response, feeding hours.';

  @override
  String get storyTacticsTitle => 'Not just when, but how';

  @override
  String get storyTacticsBody =>
      'Knowing it bites today isn\'t enough — how matters. From the day\'s real weather we suggest: the \"bait thermometer\" (cold — small and bright: maggots, corn; warm — richer: boilies, tiger nuts), which rig to use, where to sit and which hours to wait for. On warming water we feed generously; in cold and extreme heat, sparingly. All tuned to this day\'s water and sky, not done by rote.';

  @override
  String get storyHonestTitle => 'A probability, not a promise';

  @override
  String get storyHonestBody =>
      'Let\'s be honest: it\'s an estimate of the odds, not a promise of a catch. Depth, the shape of the bottom, snags, and how many fish are actually under you — a satellite can\'t see that, and no model knows it. The forecast helps you pick a good day, place and time — taking the lottery out of fishing. The rest is on you: try spots, switch baits and depths, experiment. That\'s the whole fun of it.';

  @override
  String get fcWhyHelps => 'Helps';

  @override
  String get fcWhyHurts => 'Holds back';

  @override
  String get fcWhyNoCons => 'no limiting factors';

  @override
  String get fcWhyAnd => 'and';

  @override
  String fcWhyHelpsOne(Object factors) {
    return '$factors favors the bite.';
  }

  @override
  String fcWhyHelpsMany(Object factors) {
    return '$factors favor the bite.';
  }

  @override
  String fcWhyHurtsOne(Object factors) {
    return '$factors reduces fish activity.';
  }

  @override
  String fcWhyHurtsMany(Object factors) {
    return '$factors reduce fish activity.';
  }

  @override
  String get fcWhyBalanced =>
      'Factors are balanced — no sharp swings in activity expected.';

  @override
  String get fcPhrasePressurePos =>
      'steady pressure keeps fish feeding near the bottom';

  @override
  String get fcPhrasePressureNeg => 'pressure swings put fish off the feed';

  @override
  String get fcPhraseTemperaturePos =>
      'the water has warmed to a comfortable feeding range';

  @override
  String get fcPhraseTemperatureNeg =>
      'cold water slows fish down and they rarely feed';

  @override
  String get fcPhraseWindPos => 'a light ripple pushes food toward the bank';

  @override
  String get fcPhraseWindNeg => 'strong wind raises waves and fish move deep';

  @override
  String get fcPhraseCloudPos =>
      'cloud cover dims the light, so fish feed more boldly';

  @override
  String get fcPhraseCloudNeg => 'bright sun makes fish wary and they hide';

  @override
  String get fcPhrasePrecipPos => 'dry, settled weather keeps fish predictable';

  @override
  String get fcPhrasePrecipNeg =>
      'rain muddies the water and unsettles pressure';

  @override
  String get fcPhraseSeasonPos => 'seasonal peak — fish are feeding up hard';

  @override
  String get fcPhraseSeasonNeg =>
      'seasonal lull — the fish\'s metabolism is slowed';

  @override
  String get fcPhraseMoonPos => 'active moon phase — a solunar feeding peak';

  @override
  String get fcPhraseMoonNeg => 'weak moon phase — a solunar lull';

  @override
  String get fcConfidenceHigh => 'High confidence';

  @override
  String get fcConfidenceMedium => 'Medium confidence';

  @override
  String get fcConfidenceLow => 'Low confidence';

  @override
  String get fcDayConditions => 'Daytime weather';

  @override
  String get fcPeriodNight => 'Night';

  @override
  String get fcPeriodMorning => 'Morning';

  @override
  String get fcPeriodDay => 'Day';

  @override
  String get fcPeriodEvening => 'Evening';

  @override
  String get fcRateWeak => 'Weak';

  @override
  String get fcRateMid => 'Fair';

  @override
  String get fcRateGood => 'Good';

  @override
  String get fcRateGreat => 'Great';

  @override
  String get fcPeriodWhyTitle => 'Why this score';

  @override
  String get fcPeriodTimeEffect => 'Time of day';

  @override
  String get fcPeriodBaseTitle => 'Underlying conditions';

  @override
  String get fcPeriodWater => 'Water';

  @override
  String get fcTodAdjCaption => 'Time-of-day adjustment';

  @override
  String get fcTodDawn =>
      'Dawn — the feeding peak: in these hours the score is lifted above the daytime baseline.';

  @override
  String get fcTodDusk =>
      'Dusk — fish feed actively before nightfall, so the hourly score is raised.';

  @override
  String get fcTodWarmNight =>
      'The water is warm, so at night the fish keep feeding confidently — the night score stays close to the daytime one.';

  @override
  String get fcTodMidNight =>
      'The water is still cool, so night activity is moderate — no sharp drop.';

  @override
  String get fcTodColdNight =>
      'Cold water makes fish sluggish at night, so the night score sits noticeably below the daytime one.';

  @override
  String get fcTodMiddayHot =>
      'Hot midday — fish move into shade and deeper water, so the daytime bite dips.';

  @override
  String get fcTodColdDay =>
      'In cool weather the daytime warming of the water makes this the relatively best part of the day.';

  @override
  String get fcTodDayNeutral =>
      'Daytime hours between the dawn and dusk peaks — calm, average activity.';

  @override
  String get moonNew => 'New moon';

  @override
  String get moonWaxing => 'Waxing';

  @override
  String get moonFull => 'Full moon';

  @override
  String get moonWaning => 'Waning';

  @override
  String get fcHowToFish => 'How to fish today';

  @override
  String get fcHowToFishTomorrow => 'How to fish tomorrow';

  @override
  String fcHowToFishOn(String date) {
    return 'How to fish on $date';
  }

  @override
  String get fcWhenTitle => 'When';

  @override
  String get fcWindowsLabel => 'Bite windows';

  @override
  String get fcWindowDawn => 'morning bite (dawn)';

  @override
  String get fcWindowDusk => 'evening bite (dusk)';

  @override
  String get fcWindowNight => 'night bite';

  @override
  String get fcWindowMorning => 'morning';

  @override
  String get fcWindowEvening => 'evening';

  @override
  String get fcWindowDay => 'midday';

  @override
  String get fcWindowsWhyDawn =>
      'Carp feed most at first and last light — dawn and dusk.';

  @override
  String get fcWindowsWhyNight => 'In warm water carp feed actively at night.';

  @override
  String get fcWindowsWhyDay => 'Mild daytime weather keeps fish active.';

  @override
  String get fcVerdictVeryLow =>
      'Tough day — the bite is sluggish, maybe skip it.';

  @override
  String get fcVerdictLow => 'Weak bite. If you go — fish precise and patient.';

  @override
  String get fcVerdictMedium =>
      'An average day — no guarantees, but there\'s a chance.';

  @override
  String fcVerdictMediumWindow(String from, String to) {
    return 'There\'s a chance — try the $from–$to window.';
  }

  @override
  String get fcVerdictGood => 'Good day — keep a bait in the water.';

  @override
  String fcVerdictGoodWindow(String from, String to) {
    return 'Worth going. Best time — $from–$to.';
  }

  @override
  String get fcVerdictExcellent => 'Excellent day — the bite is on!';

  @override
  String fcVerdictExcellentWindow(String from, String to) {
    return 'Excellent day! Don\'t miss the $from–$to window.';
  }

  @override
  String get fcLevelVeryLow => 'Very low';

  @override
  String get fcLevelLow => 'Low';

  @override
  String get fcLevelMedium => 'Moderate';

  @override
  String get fcLevelGood => 'Good';

  @override
  String get fcLevelExcellent => 'Excellent';

  @override
  String get fcFactorPressure => 'Pressure';

  @override
  String get fcFactorTemperature => 'Water temp';

  @override
  String get fcFactorWind => 'Wind';

  @override
  String get fcFactorCloud => 'Cloud cover';

  @override
  String get fcFactorPrecipitation => 'Precipitation';

  @override
  String get fcFactorSeason => 'Season';

  @override
  String get fcFactorMoon => 'Moon';

  @override
  String get fcCondClear => 'Clear';

  @override
  String get fcCondPartly => 'Partly cloudy';

  @override
  String get fcCondCloudy => 'Cloudy';

  @override
  String get fcCondRain => 'Rain';

  @override
  String get fcCondStorm => 'Storm';

  @override
  String get fcChipPressure => 'Pressure';

  @override
  String get fcChipWind => 'Wind';

  @override
  String get fcChipWater => 'Water';

  @override
  String get fcChipTemp => 'Temperature';

  @override
  String get fcChipMoon => 'Moon';

  @override
  String get fishCarp => 'Carp';

  @override
  String get fishCrucian => 'Crucian carp';

  @override
  String get fishSheetTitle => 'Fish';

  @override
  String get fcUnitHpaSuffix => 'hPa';

  @override
  String get fcUnitMmHgSuffix => 'mmHg';

  @override
  String get fcUnitMsSuffix => 'm/s';

  @override
  String get fcUnitKmhSuffix => 'km/h';

  @override
  String get fcWindCalm => 'Calm';

  @override
  String get fcWindN => 'N';

  @override
  String get fcWindNE => 'NE';

  @override
  String get fcWindE => 'E';

  @override
  String get fcWindSE => 'SE';

  @override
  String get fcWindS => 'S';

  @override
  String get fcWindSW => 'SW';

  @override
  String get fcWindW => 'W';

  @override
  String get fcWindNW => 'NW';

  @override
  String get tabAdvice => 'Tactics';

  @override
  String get adviceHeadline => 'Suggested tactics';

  @override
  String get adviceDisclaimer =>
      'Guidance based on the weather forecast, not a specific water.';

  @override
  String get adviceKindBait => 'Bait';

  @override
  String get adviceKindFeeding => 'Feeding';

  @override
  String get adviceKindDepth => 'Depth';

  @override
  String get adviceKindLocation => 'Spot';

  @override
  String get adviceKindTiming => 'Timing';

  @override
  String adviceWhyWater(String value) {
    return 'water $value';
  }

  @override
  String get adviceWhyWaterRising => 'water warming day to day';

  @override
  String get adviceWhyWaterFalling => 'water cooling day to day';

  @override
  String adviceWhyAirHot(String value) {
    return 'hot — air $value';
  }

  @override
  String adviceWhyWind(String value) {
    return 'wind $value';
  }

  @override
  String get adviceWhyWindLight => 'light wind';

  @override
  String get adviceWhyPressureFalling => 'pressure is falling';

  @override
  String get adviceWhyRain => 'rain during the day';

  @override
  String get adviceWhyBottomHabit => 'mild water — carp hold near the bottom';

  @override
  String get adviceWhyBiteHigh => 'high bite index';

  @override
  String get adviceWhyBiteMid => 'moderate bite index';

  @override
  String get adviceWhyBiteLow => 'low bite index';

  @override
  String get adviceWhyBestHours => 'index peaks at this time';

  @override
  String get windFullN => 'northerly';

  @override
  String get windFullNE => 'north-easterly';

  @override
  String get windFullE => 'easterly';

  @override
  String get windFullSE => 'south-easterly';

  @override
  String get windFullS => 'southerly';

  @override
  String get windFullSW => 'south-westerly';

  @override
  String get windFullW => 'westerly';

  @override
  String get windFullNW => 'north-westerly';

  @override
  String get adviceBaitColdBrightTitle => 'Bright small baits';

  @override
  String get adviceBaitColdBrightBody =>
      'Cold water — corn, maggots, small pellets. Carp feeds little and cautiously.';

  @override
  String get adviceBaitMidBoiliesTitle => 'Boilies & pellets';

  @override
  String get adviceBaitMidBoiliesBody =>
      'Water is warming — 10–16 mm boilies and pellets. Carp is more active.';

  @override
  String get adviceBaitWarmFishmealTitle => 'Fishmeal boilies';

  @override
  String get adviceBaitWarmFishmealBody =>
      'Warm water, peak appetite — rich fishmeal boilies, tiger nuts, sweetcorn.';

  @override
  String get adviceBaitHotSurfaceTitle => 'Floating baits';

  @override
  String get adviceBaitHotSurfaceBody =>
      'Heat pushes carp up — pop-ups, floating pellets, a little bread.';

  @override
  String get adviceBaitWarmingTitle => 'Go bigger & smellier';

  @override
  String get adviceBaitWarmingBody =>
      'Warming trend — carp are switching on. Boilies, tiger nuts, scented baits.';

  @override
  String get adviceBaitCoolingTitle => 'Downsize & brighten';

  @override
  String get adviceBaitCoolingBody =>
      'Water is dropping — fish turn cautious. Small pellets, corn, maggots.';

  @override
  String get adviceFeedMinimalTitle => 'Feed sparingly';

  @override
  String get adviceFeedMinimalBody =>
      'Only a couple of handfuls, placed tight — don\'t overfeed inactive fish.';

  @override
  String get adviceFeedModerateTitle => 'Feed moderately';

  @override
  String get adviceFeedModerateBody =>
      'Medium volume; top up regularly in small amounts.';

  @override
  String get adviceFeedHeavyTitle => 'Feed heavily';

  @override
  String get adviceFeedHeavyBody =>
      'Carp is feeding hard — a bigger initial bed and frequent top-ups pay off.';

  @override
  String get adviceRigBottomTitle => 'Fish the bottom';

  @override
  String get adviceRigBottomBody =>
      'Bottom rig on the deck or by features — the classic carp setup.';

  @override
  String get adviceRigZigTitle => 'Try a zig rig';

  @override
  String get adviceRigZigBody =>
      'Fish are holding in mid-water — a zig 1–2 m off the bottom can score.';

  @override
  String get adviceRigSurfaceTitle => 'Fish on top';

  @override
  String get adviceRigSurfaceBody =>
      'Carp basking near the surface — surface tackle and a floating bait.';

  @override
  String get adviceSwimWindwardTitle => 'Fish into the wind';

  @override
  String adviceSwimWindwardBody(String dir) {
    return 'A $dir wind pushes warm surface water and food to the far bank; carp feed there.';
  }

  @override
  String get adviceSwimCalmFeaturesTitle => 'Target features';

  @override
  String get adviceSwimCalmFeaturesBody =>
      'Light wind — work drop-offs, snags, reeds and depth changes.';

  @override
  String get adviceSwimShelteredTitle => 'Go deep or shaded';

  @override
  String get adviceSwimShelteredBody =>
      'In the heat, look for cooler deep water and shaded areas.';

  @override
  String get adviceTimePressureDropTitle => 'Pre-front window';

  @override
  String get adviceTimePressureDropBody =>
      'Pressure is falling — a feeding spell is likely. Don\'t miss the next few hours.';

  @override
  String get adviceTimeBestWindowTitle => 'Today\'s best window';

  @override
  String adviceTimeBestWindowBody(String from, String to) {
    return 'Peak activity around $from–$to. Be on your spot a little early.';
  }

  @override
  String get adviceTimeDawnDuskTitle => 'Dawn & dusk';

  @override
  String get adviceTimeDawnDuskBody =>
      'Bank on early morning and late evening — the most reliable bite.';

  @override
  String get adviceTimeAllDayTitle => 'Active all day';

  @override
  String get adviceTimeAllDayBody =>
      'High index — carp feed through the day; keep a bait in the water.';

  @override
  String get adviceTimeSlowPatientTitle => 'Be patient';

  @override
  String get adviceTimeSlowPatientBody =>
      'Fish are sluggish — precise presentation, finer rigs, wait for a window.';

  @override
  String get crucianBaitColdAnimalTitle => 'Animal bait';

  @override
  String get crucianBaitColdAnimalBody =>
      'Cold water — small bloodworm and maggots. One or two grubs at a time; crucian feed slowly.';

  @override
  String get crucianBaitWarmingTitle => 'Worm & maggot';

  @override
  String get crucianBaitWarmingBody =>
      'Water is warming — crucian switch on. Dendrobaena worm, a bunch of maggots, bloodworm.';

  @override
  String get crucianBaitCoolingTitle => 'Downsize & soften';

  @override
  String get crucianBaitCoolingBody =>
      'Cooling — crucian turn fussy. Small bloodworm or a sandwich, softer bait.';

  @override
  String get crucianBaitSandwichTitle => 'Sandwich bait';

  @override
  String get crucianBaitSandwichBody =>
      'Transitional water — a sandwich: maggot with pearl barley or corn. Crucian are picky.';

  @override
  String get crucianBaitWarmPlantTitle => 'Plant bait';

  @override
  String get crucianBaitWarmPlantBody =>
      'Warm water — pearl barley, semolina paste, corn, dough. Crucian switch to plant baits.';

  @override
  String get crucianBaitHotDoughTitle => 'Soft dough';

  @override
  String get crucianBaitHotDoughBody =>
      'Heat — soft dough, semolina paste, bread flake. A light sweet bait up in the water.';

  @override
  String get crucianFeedTinyTitle => 'Feed tight';

  @override
  String get crucianFeedTinyBody =>
      'Crucian are shy and fill up fast — a few pinches of fine sweet groundbait, no more.';

  @override
  String get crucianFeedSweetTitle => 'Sweet groundbait';

  @override
  String get crucianFeedSweetBody =>
      'Fine mix with garlic or vanilla scent; top up little and often, don\'t overfeed.';

  @override
  String get crucianFeedActiveTitle => 'Feed actively';

  @override
  String get crucianFeedActiveBody =>
      'Crucian are feeding well — top up more often but in small amounts to hold the shoal.';

  @override
  String get crucianRigFloatBottomTitle => 'Float on the bottom';

  @override
  String get crucianRigFloatBottomBody =>
      'The classic crucian setup — float tackle, bait resting on or just touching the bottom.';

  @override
  String get crucianRigDropperTitle => 'Dropper shot & fall';

  @override
  String get crucianRigDropperBody =>
      'Crucian have lifted into mid-water — a slow-falling bait, spread the shot, fish on the drop.';

  @override
  String get crucianRigShallowTitle => 'Shallow near the top';

  @override
  String get crucianRigShallowBody =>
      'In the heat crucian bask in the shallows — light tackle, bait in the warm upper layer.';

  @override
  String get crucianSwimReedsTitle => 'Reed margins';

  @override
  String get crucianSwimReedsBody =>
      'Work gaps in the weed, reed margins and overgrown spots — that\'s where crucian feed.';

  @override
  String get crucianSwimWarmShallowsTitle => 'Warm shallows';

  @override
  String get crucianSwimWarmShallowsBody =>
      'Water is cold — find the warmest shallows and bays heated by the sun.';

  @override
  String get crucianSwimDeepEdgeTitle => 'Deeper edge & shade';

  @override
  String get crucianSwimDeepEdgeBody =>
      'In the heat crucian leave the shallows — fish holes, drop-offs and shaded areas.';

  @override
  String get crucianTimePressureDropTitle => 'Be patient';

  @override
  String get crucianTimePressureDropBody =>
      'Pressure is falling — crucian turn fussy and passive. Small soft baits, wait for short spells.';

  @override
  String get crucianTimeBestWindowTitle => 'Today\'s best window';

  @override
  String crucianTimeBestWindowBody(String from, String to) {
    return 'Peak activity around $from–$to. Be on your spot a little early.';
  }

  @override
  String get crucianTimeMorningTitle => 'Morning bite';

  @override
  String get crucianTimeMorningBody =>
      'Bank on early morning — the classic crucian spell, before the heat.';

  @override
  String get crucianTimeStableWarmTitle => 'Active in the day too';

  @override
  String get crucianTimeStableWarmBody =>
      'Stable warmth — crucian feed through the day; keep a bait in the water.';

  @override
  String get crucianTimePatientTitle => 'Tight & patient';

  @override
  String get crucianTimePatientBody =>
      'Crucian are passive — fine rig, small bait, work one spot and wait for a spell.';

  @override
  String get spotTitle => 'Your spot';

  @override
  String get spotNoWater =>
      'No water body near this point on the map. The weather forecast still works — set a spot to read the water.';

  @override
  String get spotSetOnMap => 'Set spot on map';

  @override
  String get spotCheckFailed =>
      'Couldn\'t check the map right now — the weather forecast still works.';

  @override
  String get spotTypeLake => 'Lake';

  @override
  String get spotTypePond => 'Pond';

  @override
  String get spotTypeReservoir => 'Reservoir';

  @override
  String get spotTypeRiver => 'River';

  @override
  String get spotTypeCanal => 'Canal';

  @override
  String get spotTypeWater => 'Water';

  @override
  String spotSizeHa(String value) {
    return '~$value ha';
  }

  @override
  String spotSizeKm2(String value) {
    return '~$value km²';
  }

  @override
  String spotTipWindward(String bank) {
    return 'A warm wind drives food and warmer water to the downwind bank — fish are likely more active there. Active bank: $bank.';
  }

  @override
  String spotTipSheltered(String bank) {
    return 'The wind is colder than the water — fish pull off the exposed bank into calmer water. Sheltered side: $bank.';
  }

  @override
  String get spotTipNoWind =>
      'Barely any wind — no bank stands out today; fish are spread across structure and depths.';

  @override
  String get spotTipColdWater =>
      'Cold water — fish sit deep and sluggish on the bottom; wind moves them little right now.';

  @override
  String get spotWhereRiver =>
      'Look for slack water: holes, outer bends, below riffles, around snags and bridge piers.';

  @override
  String get spotWhereCanal =>
      'A canal is uniform — hunt anomalies: bends, bridges, inflows and weedy banks.';

  @override
  String get spotWherePondSmall =>
      'A small water warms fast — fish hold by reeds, snags and the margins, dropping deeper in the heat.';

  @override
  String get spotWhereMid =>
      'A mid-size water — work the bays, drop-offs and weedy patches.';

  @override
  String get spotWhereLarge =>
      'A large water — fish roam; look to points, drop-offs and follow the wind.';

  @override
  String get spotWhereUnknown =>
      'Still water — look to reeds, snags, drop-offs and bays.';

  @override
  String get spotSourceType => 'for this water type';

  @override
  String get spotEditTitle => 'Spot position';

  @override
  String get spotEditHint =>
      'Drag the map to place the marker — move it to the better bank if needed.';

  @override
  String get spotSavePosition => 'Save position';

  @override
  String get spotViewOnMap => 'View on the map';

  @override
  String get spotWindLabel => 'Wind';

  @override
  String spotWindFrom(String dir) {
    return 'Wind $dir';
  }

  @override
  String get spotDirN => 'from the north';

  @override
  String get spotDirNE => 'from the northeast';

  @override
  String get spotDirE => 'from the east';

  @override
  String get spotDirSE => 'from the southeast';

  @override
  String get spotDirS => 'from the south';

  @override
  String get spotDirSW => 'from the southwest';

  @override
  String get spotDirW => 'from the west';

  @override
  String get spotDirNW => 'from the northwest';

  @override
  String get spotUserHere =>
      'Your spot is already on the active bank — you\'re in the right place.';

  @override
  String get spotUserOpposite =>
      'Your spot is on the other side — it may fish better across the water.';

  @override
  String get spotSourceMap => 'From OpenStreetMap data';

  @override
  String get spotSourceWind => 'from wind and water temperature';

  @override
  String get spotDisclaimer =>
      'A read on conditions from the map and weather — we can\'t see depth, bottom or fish stock.';

  @override
  String get settingsAlertsPrimeTitle => 'Best day of the week';

  @override
  String get settingsAlertsPrimeSubtitle =>
      'One heads-up about the week\'s best biting day across your spots';

  @override
  String get settingsAlertsExcellentTitle => 'All excellent days';

  @override
  String get settingsAlertsExcellentSubtitle =>
      'A heads-up the evening before every day with excellent biting';

  @override
  String get settingsAlertsForCarp => 'Carp notifications';

  @override
  String get settingsAlertsForCrucian => 'Crucian carp notifications';

  @override
  String alertTitlePrime(String fish) {
    return '$fish: best day of the week';
  }

  @override
  String alertTitleExcellent(String fish) {
    return '$fish: excellent biting tomorrow';
  }

  @override
  String get alertWindowDawn => 'tomorrow at dawn';

  @override
  String get alertWindowDusk => 'tomorrow at dusk';

  @override
  String get alertWindowDay => 'tomorrow daytime';

  @override
  String get alertWindowNight => 'tomorrow night';

  @override
  String get alertWindowAny => 'tomorrow';

  @override
  String get alertSpotFallback => 'Your spot';

  @override
  String alertBody(String spot, String when, int index) {
    return '$spot: $when, bite index $index';
  }
}
