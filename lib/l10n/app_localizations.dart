import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_ru.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('ru'),
  ];

  /// No description provided for @welcomeTitle.
  ///
  /// In en, this message translates to:
  /// **'Plan around the bite, not the weekend'**
  String get welcomeTitle;

  /// No description provided for @welcomeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll find the best window for carp and crucian from real conditions, not guesswork'**
  String get welcomeSubtitle;

  /// No description provided for @welcomeCta.
  ///
  /// In en, this message translates to:
  /// **'Get started'**
  String get welcomeCta;

  /// No description provided for @languageSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get languageSheetTitle;

  /// No description provided for @languageSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose your language'**
  String get languageSheetSubtitle;

  /// No description provided for @themeSheetSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose how the app looks'**
  String get themeSheetSubtitle;

  /// No description provided for @languageEn.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEn;

  /// No description provided for @languageRu.
  ///
  /// In en, this message translates to:
  /// **'Русский'**
  String get languageRu;

  /// No description provided for @languageDe.
  ///
  /// In en, this message translates to:
  /// **'Deutsch'**
  String get languageDe;

  /// No description provided for @languageEs.
  ///
  /// In en, this message translates to:
  /// **'Español'**
  String get languageEs;

  /// No description provided for @languageFr.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get languageFr;

  /// No description provided for @langShortEn.
  ///
  /// In en, this message translates to:
  /// **'EN'**
  String get langShortEn;

  /// No description provided for @langShortRu.
  ///
  /// In en, this message translates to:
  /// **'RU'**
  String get langShortRu;

  /// No description provided for @langShortDe.
  ///
  /// In en, this message translates to:
  /// **'DE'**
  String get langShortDe;

  /// No description provided for @langShortEs.
  ///
  /// In en, this message translates to:
  /// **'ES'**
  String get langShortEs;

  /// No description provided for @langShortFr.
  ///
  /// In en, this message translates to:
  /// **'FR'**
  String get langShortFr;

  /// No description provided for @commonContinue.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get commonContinue;

  /// No description provided for @quizQ1Question.
  ///
  /// In en, this message translates to:
  /// **'What do you fish for?'**
  String get quizQ1Question;

  /// No description provided for @quizQ1Subtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll tune the forecast to your fish'**
  String get quizQ1Subtitle;

  /// No description provided for @quizQ1OptLearn.
  ///
  /// In en, this message translates to:
  /// **'Carp'**
  String get quizQ1OptLearn;

  /// No description provided for @quizQ1OptHabit.
  ///
  /// In en, this message translates to:
  /// **'Crucian carp'**
  String get quizQ1OptHabit;

  /// No description provided for @quizQ1OptSolve.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get quizQ1OptSolve;

  /// No description provided for @quizQ2Question.
  ///
  /// In en, this message translates to:
  /// **'Drove out, no bite?'**
  String get quizQ2Question;

  /// No description provided for @quizQ2Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Be honest — it helps us help you'**
  String get quizQ2Subtitle;

  /// No description provided for @quizQ2OptDaily.
  ///
  /// In en, this message translates to:
  /// **'Yes, more than once'**
  String get quizQ2OptDaily;

  /// No description provided for @quizQ2OptWeekly.
  ///
  /// In en, this message translates to:
  /// **'Sometimes'**
  String get quizQ2OptWeekly;

  /// No description provided for @quizQ2OptRarely.
  ///
  /// In en, this message translates to:
  /// **'Rarely — I usually catch'**
  String get quizQ2OptRarely;

  /// No description provided for @quizQ3Question.
  ///
  /// In en, this message translates to:
  /// **'How do you plan trips?'**
  String get quizQ3Question;

  /// No description provided for @quizQ3Subtitle.
  ///
  /// In en, this message translates to:
  /// **'Decides what we show you first'**
  String get quizQ3Subtitle;

  /// No description provided for @quizQ3OptSimple.
  ///
  /// In en, this message translates to:
  /// **'I plan ahead'**
  String get quizQ3OptSimple;

  /// No description provided for @quizQ3OptResult.
  ///
  /// In en, this message translates to:
  /// **'I go spontaneously'**
  String get quizQ3OptResult;

  /// No description provided for @quizQ3OptFlexible.
  ///
  /// In en, this message translates to:
  /// **'It varies'**
  String get quizQ3OptFlexible;

  /// No description provided for @quizQ4Question.
  ///
  /// In en, this message translates to:
  /// **'How often do you fish?'**
  String get quizQ4Question;

  /// No description provided for @quizQ4Subtitle.
  ///
  /// In en, this message translates to:
  /// **'We\'ll alert you to the best days'**
  String get quizQ4Subtitle;

  /// No description provided for @quizQ4OptWeekly.
  ///
  /// In en, this message translates to:
  /// **'Every week'**
  String get quizQ4OptWeekly;

  /// No description provided for @quizQ4OptMonthly.
  ///
  /// In en, this message translates to:
  /// **'A couple times a month'**
  String get quizQ4OptMonthly;

  /// No description provided for @quizQ4OptRarely.
  ///
  /// In en, this message translates to:
  /// **'Now and then'**
  String get quizQ4OptRarely;

  /// No description provided for @onbAnalyzingTitle.
  ///
  /// In en, this message translates to:
  /// **'Analyzing conditions'**
  String get onbAnalyzingTitle;

  /// No description provided for @onbAnalyzingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Crunching weather, pressure and the moon…'**
  String get onbAnalyzingSubtitle;

  /// No description provided for @onbResultTitle.
  ///
  /// In en, this message translates to:
  /// **'Your bite forecast is ready'**
  String get onbResultTitle;

  /// No description provided for @onbResultSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s bite is free. The 7-day forecast unlocks with a subscription.'**
  String get onbResultSubtitle;

  /// No description provided for @onbResultTodayBadge.
  ///
  /// In en, this message translates to:
  /// **'Today · free'**
  String get onbResultTodayBadge;

  /// No description provided for @onbResultLockedLabel.
  ///
  /// In en, this message translates to:
  /// **'7-day forecast'**
  String get onbResultLockedLabel;

  /// No description provided for @onbResultCta.
  ///
  /// In en, this message translates to:
  /// **'See my forecast'**
  String get onbResultCta;

  /// No description provided for @paywallSkipToday.
  ///
  /// In en, this message translates to:
  /// **'See today for free first'**
  String get paywallSkipToday;

  /// No description provided for @winbackTitle.
  ///
  /// In en, this message translates to:
  /// **'1 day of Pro, on us'**
  String get winbackTitle;

  /// No description provided for @winbackBody.
  ///
  /// In en, this message translates to:
  /// **'Unlock everything for 24 hours: bite forecast, best windows and tactics for your spot. No payment — just try it.'**
  String get winbackBody;

  /// No description provided for @winbackCtaClaim.
  ///
  /// In en, this message translates to:
  /// **'Claim 1 day'**
  String get winbackCtaClaim;

  /// No description provided for @winbackCtaSkip.
  ///
  /// In en, this message translates to:
  /// **'Continue without Pro'**
  String get winbackCtaSkip;

  /// No description provided for @paywallTitle.
  ///
  /// In en, this message translates to:
  /// **'Open the complete fishing analysis for your spot for the week ahead'**
  String get paywallTitle;

  /// No description provided for @paywallSaveBadge.
  ///
  /// In en, this message translates to:
  /// **'Save 85%'**
  String get paywallSaveBadge;

  /// No description provided for @unlockTitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock All Pro Features'**
  String get unlockTitle;

  /// No description provided for @unlockBody.
  ///
  /// In en, this message translates to:
  /// **'Dozens of rules for carp and crucian carp fishing — pressure, water temperature, wind, moon, season, and time of day in one honest assessment from 0 to 100. And all of this is based on the weather of your specific water body.'**
  String get unlockBody;

  /// No description provided for @tblFree.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get tblFree;

  /// No description provided for @tblPro.
  ///
  /// In en, this message translates to:
  /// **'Pro'**
  String get tblPro;

  /// No description provided for @tblLimited.
  ///
  /// In en, this message translates to:
  /// **'Limited'**
  String get tblLimited;

  /// No description provided for @tblForecast.
  ///
  /// In en, this message translates to:
  /// **'7-day bite forecast · when to go'**
  String get tblForecast;

  /// No description provided for @tblTactics.
  ///
  /// In en, this message translates to:
  /// **'Daily tactics · what & how to catch'**
  String get tblTactics;

  /// No description provided for @tblSpot.
  ///
  /// In en, this message translates to:
  /// **'Your spot, decoded · where to set up'**
  String get tblSpot;

  /// No description provided for @tblAlerts.
  ///
  /// In en, this message translates to:
  /// **'Best-day alerts · day before'**
  String get tblAlerts;

  /// No description provided for @tblPlaybook.
  ///
  /// In en, this message translates to:
  /// **'Carp & crucian playbook'**
  String get tblPlaybook;

  /// No description provided for @tblJournal.
  ///
  /// In en, this message translates to:
  /// **'Journal · conditions & bite index'**
  String get tblJournal;

  /// No description provided for @planYearly.
  ///
  /// In en, this message translates to:
  /// **'12 months'**
  String get planYearly;

  /// No description provided for @planWeekly.
  ///
  /// In en, this message translates to:
  /// **'Week'**
  String get planWeekly;

  /// No description provided for @trialBadgeFreeDays.
  ///
  /// In en, this message translates to:
  /// **'{days, plural, one{{days} day free} other{{days} days free}}'**
  String trialBadgeFreeDays(int days);

  /// No description provided for @trialDayLabel.
  ///
  /// In en, this message translates to:
  /// **'Day {n}'**
  String trialDayLabel(int n);

  /// No description provided for @trialDay1Desc.
  ///
  /// In en, this message translates to:
  /// **'Trial starts'**
  String get trialDay1Desc;

  /// No description provided for @trialDayMidDesc.
  ///
  /// In en, this message translates to:
  /// **'We\'ll remind you'**
  String get trialDayMidDesc;

  /// No description provided for @trialDayEndDesc.
  ///
  /// In en, this message translates to:
  /// **'Plan begins'**
  String get trialDayEndDesc;

  /// No description provided for @paywallAlgoTitle.
  ///
  /// In en, this message translates to:
  /// **'Smart bite algorithm'**
  String get paywallAlgoTitle;

  /// No description provided for @paywallAlgoBody.
  ///
  /// In en, this message translates to:
  /// **'Dozens of rules tuned to carp biology — pressure, water temp, wind, moon, season and time of day in one honest 0–100 score. And all of it for the weather at your own water.'**
  String get paywallAlgoBody;

  /// No description provided for @featureForecast.
  ///
  /// In en, this message translates to:
  /// **'7-day bite forecast — know when to go'**
  String get featureForecast;

  /// No description provided for @featureTactics.
  ///
  /// In en, this message translates to:
  /// **'Daily tactics — what and how to fish, what to feed'**
  String get featureTactics;

  /// No description provided for @featureSpot.
  ///
  /// In en, this message translates to:
  /// **'\"Your spot\" — water analysis: type, size, where to stand by wind'**
  String get featureSpot;

  /// No description provided for @featureAlerts.
  ///
  /// In en, this message translates to:
  /// **'Best-day alerts — push the evening before prime time at your spot'**
  String get featureAlerts;

  /// No description provided for @faqTitle.
  ///
  /// In en, this message translates to:
  /// **'Frequently asked'**
  String get faqTitle;

  /// No description provided for @faqCancelQ.
  ///
  /// In en, this message translates to:
  /// **'Can I cancel?'**
  String get faqCancelQ;

  /// No description provided for @faqCancelA.
  ///
  /// In en, this message translates to:
  /// **'Yes, anytime through your App Store or Google Play settings. If you cancel before the trial ends, you won\'t be charged.'**
  String get faqCancelA;

  /// No description provided for @faqChargeQ.
  ///
  /// In en, this message translates to:
  /// **'When will I be charged?'**
  String get faqChargeQ;

  /// No description provided for @faqChargeA.
  ///
  /// In en, this message translates to:
  /// **'If you chose a free trial — after it ends. We\'ll remind you a day before so you can decide.'**
  String get faqChargeA;

  /// No description provided for @faqIncludesQ.
  ///
  /// In en, this message translates to:
  /// **'What\'s included in the subscription?'**
  String get faqIncludesQ;

  /// No description provided for @faqIncludesA.
  ///
  /// In en, this message translates to:
  /// **'The full bite forecast for all your spots, hourly biting windows, regular updates and priority support.'**
  String get faqIncludesA;

  /// No description provided for @paywallNoPaymentNow.
  ///
  /// In en, this message translates to:
  /// **'No payment today'**
  String get paywallNoPaymentNow;

  /// No description provided for @paywallCtaStartFree.
  ///
  /// In en, this message translates to:
  /// **'Start trial'**
  String get paywallCtaStartFree;

  /// No description provided for @paywallCtaSubscribe.
  ///
  /// In en, this message translates to:
  /// **'Subscribe'**
  String get paywallCtaSubscribe;

  /// No description provided for @paywallDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Auto-renews. Cancel anytime'**
  String get paywallDisclaimer;

  /// No description provided for @menuRestore.
  ///
  /// In en, this message translates to:
  /// **'Restore purchases'**
  String get menuRestore;

  /// No description provided for @menuTerms.
  ///
  /// In en, this message translates to:
  /// **'Terms of use'**
  String get menuTerms;

  /// No description provided for @menuPrivacy.
  ///
  /// In en, this message translates to:
  /// **'Privacy policy'**
  String get menuPrivacy;

  /// No description provided for @menuPromo.
  ///
  /// In en, this message translates to:
  /// **'Have a code?'**
  String get menuPromo;

  /// No description provided for @menuRestart.
  ///
  /// In en, this message translates to:
  /// **'Start over'**
  String get menuRestart;

  /// No description provided for @promoTitle.
  ///
  /// In en, this message translates to:
  /// **'Enter promo code'**
  String get promoTitle;

  /// No description provided for @promoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'If you have an activation code — enter it below'**
  String get promoSubtitle;

  /// No description provided for @promoCtaActivate.
  ///
  /// In en, this message translates to:
  /// **'Activate'**
  String get promoCtaActivate;

  /// No description provided for @promoErrorInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid code'**
  String get promoErrorInvalid;

  /// No description provided for @promoSuccess.
  ///
  /// In en, this message translates to:
  /// **'Subscription activated for {days, plural, one{{days} day} other{{days} days}}'**
  String promoSuccess(int days);

  /// No description provided for @homeTitle.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get homeTitle;

  /// No description provided for @homeSubNotActive.
  ///
  /// In en, this message translates to:
  /// **'Subscription not active'**
  String get homeSubNotActive;

  /// No description provided for @homeOnboardingNotDone.
  ///
  /// In en, this message translates to:
  /// **'Onboarding not completed'**
  String get homeOnboardingNotDone;

  /// No description provided for @homeAnswersLabel.
  ///
  /// In en, this message translates to:
  /// **'Your answers:'**
  String get homeAnswersLabel;

  /// No description provided for @homeBtnReplayOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Restart onboarding'**
  String get homeBtnReplayOnboarding;

  /// No description provided for @homeBtnToPaywall.
  ///
  /// In en, this message translates to:
  /// **'To paywall'**
  String get homeBtnToPaywall;

  /// No description provided for @homeBtnResetSub.
  ///
  /// In en, this message translates to:
  /// **'Reset subscription'**
  String get homeBtnResetSub;

  /// No description provided for @homePremiumBadge.
  ///
  /// In en, this message translates to:
  /// **'Premium active · {remaining} left'**
  String homePremiumBadge(String remaining);

  /// No description provided for @remainingDays.
  ///
  /// In en, this message translates to:
  /// **'{n, plural, one{{n} day} other{{n} days}}'**
  String remainingDays(int n);

  /// No description provided for @remainingHours.
  ///
  /// In en, this message translates to:
  /// **'{n}h'**
  String remainingHours(int n);

  /// No description provided for @remainingMinutes.
  ///
  /// In en, this message translates to:
  /// **'{n}m'**
  String remainingMinutes(int n);

  /// No description provided for @tabHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get tabHome;

  /// No description provided for @tabAnalytics.
  ///
  /// In en, this message translates to:
  /// **'Analytics'**
  String get tabAnalytics;

  /// No description provided for @tabSettings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get tabSettings;

  /// No description provided for @homeTabEmpty.
  ///
  /// In en, this message translates to:
  /// **'Home tab is empty for now'**
  String get homeTabEmpty;

  /// No description provided for @analyticsTabEmpty.
  ///
  /// In en, this message translates to:
  /// **'Analytics tab is empty for now'**
  String get analyticsTabEmpty;

  /// No description provided for @settingsSubscriptionTitle.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get settingsSubscriptionTitle;

  /// No description provided for @settingsSubActive.
  ///
  /// In en, this message translates to:
  /// **'Premium active'**
  String get settingsSubActive;

  /// No description provided for @settingsSubInactive.
  ///
  /// In en, this message translates to:
  /// **'Subscription not active'**
  String get settingsSubInactive;

  /// No description provided for @settingsSubExpiresLeft.
  ///
  /// In en, this message translates to:
  /// **'{remaining} left'**
  String settingsSubExpiresLeft(String remaining);

  /// No description provided for @settingsSubBtnGoPaywall.
  ///
  /// In en, this message translates to:
  /// **'Activate subscription'**
  String get settingsSubBtnGoPaywall;

  /// No description provided for @settingsSubBtnManage.
  ///
  /// In en, this message translates to:
  /// **'Manage subscription'**
  String get settingsSubBtnManage;

  /// No description provided for @settingsRestartOnboarding.
  ///
  /// In en, this message translates to:
  /// **'Restart onboarding'**
  String get settingsRestartOnboarding;

  /// No description provided for @restartConfirmTitle.
  ///
  /// In en, this message translates to:
  /// **'Restart onboarding?'**
  String get restartConfirmTitle;

  /// No description provided for @restartConfirmMessage.
  ///
  /// In en, this message translates to:
  /// **'Your answers will be cleared and you\'ll go back to the welcome screen.'**
  String get restartConfirmMessage;

  /// No description provided for @commonCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get commonCancel;

  /// No description provided for @commonConfirm.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get commonConfirm;

  /// No description provided for @commonUndo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get commonUndo;

  /// No description provided for @commonDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get commonDelete;

  /// No description provided for @tabNotes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get tabNotes;

  /// No description provided for @noteNew.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteNew;

  /// No description provided for @notesEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No notes yet'**
  String get notesEmptyTitle;

  /// No description provided for @notesEmptySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Jot down your fishing observations: bite, bait, weather.'**
  String get notesEmptySubtitle;

  /// No description provided for @noteNewTitle.
  ///
  /// In en, this message translates to:
  /// **'New note'**
  String get noteNewTitle;

  /// No description provided for @noteEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get noteEditTitle;

  /// No description provided for @noteTextHint.
  ///
  /// In en, this message translates to:
  /// **'What did you notice? Bite, bait, weather…'**
  String get noteTextHint;

  /// No description provided for @noteLocationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get noteLocationLabel;

  /// No description provided for @noteLocationNone.
  ///
  /// In en, this message translates to:
  /// **'No location'**
  String get noteLocationNone;

  /// No description provided for @notePhotosLabel.
  ///
  /// In en, this message translates to:
  /// **'Photos'**
  String get notePhotosLabel;

  /// No description provided for @notePhotoCamera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get notePhotoCamera;

  /// No description provided for @notePhotoGallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get notePhotoGallery;

  /// No description provided for @noteConditionsTitle.
  ///
  /// In en, this message translates to:
  /// **'Conditions when noted'**
  String get noteConditionsTitle;

  /// No description provided for @noteSave.
  ///
  /// In en, this message translates to:
  /// **'Save note'**
  String get noteSave;

  /// No description provided for @noteDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete note?'**
  String get noteDeleteConfirm;

  /// No description provided for @noteDeleted.
  ///
  /// In en, this message translates to:
  /// **'Note deleted'**
  String get noteDeleted;

  /// No description provided for @noteEmptyError.
  ///
  /// In en, this message translates to:
  /// **'Add text or a photo'**
  String get noteEmptyError;

  /// No description provided for @noteDiscardTitle.
  ///
  /// In en, this message translates to:
  /// **'Discard changes?'**
  String get noteDiscardTitle;

  /// No description provided for @noteDiscard.
  ///
  /// In en, this message translates to:
  /// **'Discard'**
  String get noteDiscard;

  /// No description provided for @settingsNotificationsTitle.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get settingsNotificationsTitle;

  /// No description provided for @settingsNotifMaster.
  ///
  /// In en, this message translates to:
  /// **'All notifications'**
  String get settingsNotifMaster;

  /// No description provided for @settingsNotifReminders.
  ///
  /// In en, this message translates to:
  /// **'Reminders'**
  String get settingsNotifReminders;

  /// No description provided for @settingsNotifNews.
  ///
  /// In en, this message translates to:
  /// **'News & updates'**
  String get settingsNotifNews;

  /// No description provided for @settingsAboutTitle.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAboutTitle;

  /// No description provided for @settingsRateApp.
  ///
  /// In en, this message translates to:
  /// **'Rate the app'**
  String get settingsRateApp;

  /// No description provided for @settingsShareApp.
  ///
  /// In en, this message translates to:
  /// **'Share with friends'**
  String get settingsShareApp;

  /// No description provided for @settingsContactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact support'**
  String get settingsContactSupport;

  /// No description provided for @shareMessage.
  ///
  /// In en, this message translates to:
  /// **'Check out {appName} — {appLink}'**
  String shareMessage(String appName, String appLink);

  /// No description provided for @supportEmailSubject.
  ///
  /// In en, this message translates to:
  /// **'Help with {appName}'**
  String supportEmailSubject(String appName);

  /// No description provided for @supportEmailBody.
  ///
  /// In en, this message translates to:
  /// **'\n\n\n---\nApp: {appName} v{version} ({build})\nPlatform: {platform}\nLocale: {locale}'**
  String supportEmailBody(
    String appName,
    String version,
    String build,
    String platform,
    String locale,
  );

  /// No description provided for @appVersionFooter.
  ///
  /// In en, this message translates to:
  /// **'{appName} · v{version} ({build})'**
  String appVersionFooter(String appName, String version, String build);

  /// No description provided for @settingsAppearanceTitle.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsAppearanceTitle;

  /// No description provided for @settingsLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguage;

  /// No description provided for @settingsUnitsTitle.
  ///
  /// In en, this message translates to:
  /// **'Units'**
  String get settingsUnitsTitle;

  /// No description provided for @unitTemperature.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get unitTemperature;

  /// No description provided for @unitWind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get unitWind;

  /// No description provided for @unitPressure.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get unitPressure;

  /// No description provided for @settingsMoreTitle.
  ///
  /// In en, this message translates to:
  /// **'More'**
  String get settingsMoreTitle;

  /// No description provided for @settingsSubInactiveSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Unlock all features'**
  String get settingsSubInactiveSubtitle;

  /// No description provided for @settingsThemeTitle.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get settingsThemeTitle;

  /// No description provided for @themeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get themeSystem;

  /// No description provided for @themeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get themeLight;

  /// No description provided for @themeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get themeDark;

  /// No description provided for @mockPurchase.
  ///
  /// In en, this message translates to:
  /// **'Mock purchase: {plan}'**
  String mockPurchase(String plan);

  /// No description provided for @mockRestore.
  ///
  /// In en, this message translates to:
  /// **'Mock: purchases restored'**
  String get mockRestore;

  /// No description provided for @tabForecast.
  ///
  /// In en, this message translates to:
  /// **'Forecast'**
  String get tabForecast;

  /// No description provided for @locCurrent.
  ///
  /// In en, this message translates to:
  /// **'My location'**
  String get locCurrent;

  /// No description provided for @locDefault.
  ///
  /// In en, this message translates to:
  /// **'Default location'**
  String get locDefault;

  /// No description provided for @locationSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get locationSheetTitle;

  /// No description provided for @locFallbackBanner.
  ///
  /// In en, this message translates to:
  /// **'Location is off — showing the default spot. Forecast may not match your area.'**
  String get locFallbackBanner;

  /// No description provided for @locFallbackAction.
  ///
  /// In en, this message translates to:
  /// **'Choose'**
  String get locFallbackAction;

  /// No description provided for @fcLoading.
  ///
  /// In en, this message translates to:
  /// **'Loading forecast…'**
  String get fcLoading;

  /// No description provided for @fcError.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t load forecast'**
  String get fcError;

  /// No description provided for @fcErrorSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Check your connection and try again'**
  String get fcErrorSubtitle;

  /// No description provided for @fcRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get fcRetry;

  /// No description provided for @fcRefresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh weekly forecast'**
  String get fcRefresh;

  /// No description provided for @fcRefreshing.
  ///
  /// In en, this message translates to:
  /// **'Updating forecast…'**
  String get fcRefreshing;

  /// No description provided for @fcRefreshStep1.
  ///
  /// In en, this message translates to:
  /// **'Fetching the weather…'**
  String get fcRefreshStep1;

  /// No description provided for @fcRefreshStep2.
  ///
  /// In en, this message translates to:
  /// **'Reading pressure and wind…'**
  String get fcRefreshStep2;

  /// No description provided for @fcRefreshStep3.
  ///
  /// In en, this message translates to:
  /// **'Checking the moon phase…'**
  String get fcRefreshStep3;

  /// No description provided for @fcRefreshStep4.
  ///
  /// In en, this message translates to:
  /// **'Finding the bite windows…'**
  String get fcRefreshStep4;

  /// No description provided for @fcRefreshStep5.
  ///
  /// In en, this message translates to:
  /// **'Recalculating the index…'**
  String get fcRefreshStep5;

  /// No description provided for @fcUpdatedAt.
  ///
  /// In en, this message translates to:
  /// **'updated at {time}'**
  String fcUpdatedAt(String time);

  /// No description provided for @fcUpdatedJustNow.
  ///
  /// In en, this message translates to:
  /// **'updated just now'**
  String get fcUpdatedJustNow;

  /// No description provided for @fcUpdatedMinAgo.
  ///
  /// In en, this message translates to:
  /// **'updated {minutes} min ago'**
  String fcUpdatedMinAgo(int minutes);

  /// No description provided for @fcUpdatedHoursAgo.
  ///
  /// In en, this message translates to:
  /// **'updated {hours} h ago'**
  String fcUpdatedHoursAgo(int hours);

  /// No description provided for @fcUpdatedDate.
  ///
  /// In en, this message translates to:
  /// **'updated {date}'**
  String fcUpdatedDate(String date);

  /// No description provided for @fcOfflineUpdated.
  ///
  /// In en, this message translates to:
  /// **'offline · {age}'**
  String fcOfflineUpdated(String age);

  /// No description provided for @fcFactorGood.
  ///
  /// In en, this message translates to:
  /// **'good'**
  String get fcFactorGood;

  /// No description provided for @fcFactorNeutral.
  ///
  /// In en, this message translates to:
  /// **'neutral'**
  String get fcFactorNeutral;

  /// No description provided for @fcFactorWeak.
  ///
  /// In en, this message translates to:
  /// **'weak'**
  String get fcFactorWeak;

  /// No description provided for @tabSpots.
  ///
  /// In en, this message translates to:
  /// **'Spots'**
  String get tabSpots;

  /// No description provided for @spotsActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Active spot'**
  String get spotsActiveTitle;

  /// No description provided for @spotsSavedTitle.
  ///
  /// In en, this message translates to:
  /// **'Saved spots'**
  String get spotsSavedTitle;

  /// No description provided for @spotsUseCurrent.
  ///
  /// In en, this message translates to:
  /// **'Use current location'**
  String get spotsUseCurrent;

  /// No description provided for @spotsEmpty.
  ///
  /// In en, this message translates to:
  /// **'No saved spots yet.\nAdd one on the map.'**
  String get spotsEmpty;

  /// No description provided for @spotsAddOnMap.
  ///
  /// In en, this message translates to:
  /// **'Add on map'**
  String get spotsAddOnMap;

  /// No description provided for @spotPickerTitle.
  ///
  /// In en, this message translates to:
  /// **'Pick a spot'**
  String get spotPickerTitle;

  /// No description provided for @spotNameHint.
  ///
  /// In en, this message translates to:
  /// **'Spot name (optional)'**
  String get spotNameHint;

  /// No description provided for @spotSaveBtn.
  ///
  /// In en, this message translates to:
  /// **'Save spot'**
  String get spotSaveBtn;

  /// No description provided for @spotSaveActive.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get spotSaveActive;

  /// No description provided for @spotNameDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Spot name'**
  String get spotNameDialogTitle;

  /// No description provided for @spotEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get spotEdit;

  /// No description provided for @spotDefaultName.
  ///
  /// In en, this message translates to:
  /// **'Spot {n}'**
  String spotDefaultName(int n);

  /// No description provided for @spotDeleted.
  ///
  /// In en, this message translates to:
  /// **'Spot deleted'**
  String get spotDeleted;

  /// No description provided for @spotDeleteConfirm.
  ///
  /// In en, this message translates to:
  /// **'Delete spot?'**
  String get spotDeleteConfirm;

  /// No description provided for @spotSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search a place'**
  String get spotSearchHint;

  /// No description provided for @spotNothingFound.
  ///
  /// In en, this message translates to:
  /// **'Nothing found'**
  String get spotNothingFound;

  /// No description provided for @spotLocationUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t get your location'**
  String get spotLocationUnavailable;

  /// No description provided for @fcToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get fcToday;

  /// No description provided for @fcTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get fcTomorrow;

  /// No description provided for @fcIndexCaption.
  ///
  /// In en, this message translates to:
  /// **'Bite index'**
  String get fcIndexCaption;

  /// No description provided for @fcBestWindow.
  ///
  /// In en, this message translates to:
  /// **'Best window'**
  String get fcBestWindow;

  /// No description provided for @fcBestWindowEmpty.
  ///
  /// In en, this message translates to:
  /// **'Weak activity all day'**
  String get fcBestWindowEmpty;

  /// No description provided for @fcHourlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Hourly'**
  String get fcHourlyTitle;

  /// No description provided for @fcWeekTitle.
  ///
  /// In en, this message translates to:
  /// **'7-day outlook'**
  String get fcWeekTitle;

  /// No description provided for @fcUpcomingDays.
  ///
  /// In en, this message translates to:
  /// **'Upcoming days'**
  String get fcUpcomingDays;

  /// No description provided for @fcSeeWeek.
  ///
  /// In en, this message translates to:
  /// **'See week'**
  String get fcSeeWeek;

  /// No description provided for @fcWhyTitle.
  ///
  /// In en, this message translates to:
  /// **'Why this score'**
  String get fcWhyTitle;

  /// No description provided for @fcHowItWorksBtn.
  ///
  /// In en, this message translates to:
  /// **'How the forecast works'**
  String get fcHowItWorksBtn;

  /// No description provided for @fcHowItWorksTitle.
  ///
  /// In en, this message translates to:
  /// **'How the forecast works'**
  String get fcHowItWorksTitle;

  /// No description provided for @fcHowItWorksP1Title.
  ///
  /// In en, this message translates to:
  /// **'A smart model, not a coin toss'**
  String get fcHowItWorksP1Title;

  /// No description provided for @fcHowItWorksP1Body.
  ///
  /// In en, this message translates to:
  /// **'Behind every score is a model that pulls together dozens of weather factors each day — atmospheric pressure and its swings, wind speed and direction, air and water temperature, cloud cover, precipitation, the moon phase and the season. We weigh each one and turn it into a single, clear bite score.'**
  String get fcHowItWorksP1Body;

  /// No description provided for @fcHowItWorksP2Title.
  ///
  /// In en, this message translates to:
  /// **'Tuned to your water'**
  String get fcHowItWorksP2Title;

  /// No description provided for @fcHowItWorksP2Body.
  ///
  /// In en, this message translates to:
  /// **'A lake, river, pond and reservoir each live by their own rules. The algorithm factors in the type of water and its traits to pinpoint where and when fish are more likely to be active right at your spot.'**
  String get fcHowItWorksP2Body;

  /// No description provided for @fcHowItWorksP3Title.
  ///
  /// In en, this message translates to:
  /// **'Built on fish behaviour'**
  String get fcHowItWorksP3Title;

  /// No description provided for @fcHowItWorksP3Body.
  ///
  /// In en, this message translates to:
  /// **'Fish react to weather in predictable ways — chasing comfortable temperature, oxygen and food. We bake those patterns in and translate them into concrete tips: where to set up, what depth to work and which hours to wait for the bite.'**
  String get fcHowItWorksP3Body;

  /// No description provided for @fcHowItWorksP4Title.
  ///
  /// In en, this message translates to:
  /// **'The best time and place'**
  String get fcHowItWorksP4Title;

  /// No description provided for @fcHowItWorksP4Body.
  ///
  /// In en, this message translates to:
  /// **'We forecast not just today but days ahead and highlight the strongest bite windows — so you plan your session for the most promising day and hour instead of guessing.'**
  String get fcHowItWorksP4Body;

  /// No description provided for @fcHowItWorksDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'It\'s a probability, not a promise. On the water, always read the spot and experiment — location, bait, timing.'**
  String get fcHowItWorksDisclaimer;

  /// No description provided for @storyTitle.
  ///
  /// In en, this message translates to:
  /// **'Anatomy of the bite'**
  String get storyTitle;

  /// No description provided for @storySubtitle.
  ///
  /// In en, this message translates to:
  /// **'Why it isn\'t reading tea leaves'**
  String get storySubtitle;

  /// No description provided for @storyHookTitle.
  ///
  /// In en, this message translates to:
  /// **'Biting isn\'t a lottery'**
  String get storyHookTitle;

  /// No description provided for @storyHookBody.
  ///
  /// In en, this message translates to:
  /// **'Fish are cold-blooded: no \"mood\", just a response to water and sky. Pressure drops, water warms, the wind picks up — appetite shifts. We learned to read those signals and fold them into one score. Here\'s what goes into it.'**
  String get storyHookBody;

  /// No description provided for @storyPressureTitle.
  ///
  /// In en, this message translates to:
  /// **'A barometer and a thermometer'**
  String get storyPressureTitle;

  /// No description provided for @storyPressureBody.
  ///
  /// In en, this message translates to:
  /// **'A fish has a built-in barometer — its swim bladder. A sharp pressure jump stuns it; a slow drop before bad weather flips the feeding on. All of it plays out against water temperature, which lags the air — a small pond wakes in days, a big lake in weeks — so we model the water\'s inertia and tune it to your venue. Cold water: sluggish on the bottom. Warmed up: out feeding.'**
  String get storyPressureBody;

  /// No description provided for @storyWindTitle.
  ///
  /// In en, this message translates to:
  /// **'Wind and the hour'**
  String get storyWindTitle;

  /// No description provided for @storyWindBody.
  ///
  /// In en, this message translates to:
  /// **'Wind is the angler\'s friend: it pushes warm water and food to the downwind bank and adds oxygen — that\'s where fish gather. And everyone has their hour: carp love dusk and a warm night, crucian the morning, while a hot midday shuts the bite down. The moon nudges it a little. So the score shifts not just by day, but by hour.'**
  String get storyWindBody;

  /// No description provided for @storyTypeTitle.
  ///
  /// In en, this message translates to:
  /// **'Every water has a character'**
  String get storyTypeTitle;

  /// No description provided for @storyTypeBody.
  ///
  /// In en, this message translates to:
  /// **'A lake, river, pond, canal and reservoir each live their own way. On big water fish follow the wind; on a river they hold to bends, pits and the slack below rapids; in a small pond they hug the reeds and snags. We identify your water from the OpenStreetMap map — its type and size — and tune both the water-warming model and the where-to-look tips to your venue.'**
  String get storyTypeBody;

  /// No description provided for @storyFishTitle.
  ///
  /// In en, this message translates to:
  /// **'Carp ≠ crucian'**
  String get storyFishTitle;

  /// No description provided for @storyFishBody.
  ///
  /// In en, this message translates to:
  /// **'One engine, two characters — and you mustn\'t mix them up. Carp is a cautious gourmet: it loves warm water, a slow pressure drop before bad weather, and feeds even at night. Crucian is fussier about swings, wakes later and fills up fast, yet it\'s absurdly hardy — a stuffy warm puddle that troubles carp suits it just fine. So we score each by its own profile: temperature thresholds, pressure response, feeding hours.'**
  String get storyFishBody;

  /// No description provided for @storyTacticsTitle.
  ///
  /// In en, this message translates to:
  /// **'Not just when, but how'**
  String get storyTacticsTitle;

  /// No description provided for @storyTacticsBody.
  ///
  /// In en, this message translates to:
  /// **'Knowing it bites today isn\'t enough — how matters. From the day\'s real weather we suggest: the \"bait thermometer\" (cold — small and bright: maggots, corn; warm — richer: boilies, tiger nuts), which rig to use, where to sit and which hours to wait for. On warming water we feed generously; in cold and extreme heat, sparingly. All tuned to this day\'s water and sky, not done by rote.'**
  String get storyTacticsBody;

  /// No description provided for @storyHonestTitle.
  ///
  /// In en, this message translates to:
  /// **'A probability, not a promise'**
  String get storyHonestTitle;

  /// No description provided for @storyHonestBody.
  ///
  /// In en, this message translates to:
  /// **'Let\'s be honest: it\'s an estimate of the odds, not a promise of a catch. Depth, the shape of the bottom, snags, and how many fish are actually under you — a satellite can\'t see that, and no model knows it. The forecast helps you pick a good day, place and time — taking the lottery out of fishing. The rest is on you: try spots, switch baits and depths, experiment. That\'s the whole fun of it.'**
  String get storyHonestBody;

  /// No description provided for @fcWhyHelps.
  ///
  /// In en, this message translates to:
  /// **'Helps'**
  String get fcWhyHelps;

  /// No description provided for @fcWhyHurts.
  ///
  /// In en, this message translates to:
  /// **'Holds back'**
  String get fcWhyHurts;

  /// No description provided for @fcWhyNoCons.
  ///
  /// In en, this message translates to:
  /// **'no limiting factors'**
  String get fcWhyNoCons;

  /// No description provided for @fcWhyAnd.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get fcWhyAnd;

  /// No description provided for @fcWhyHelpsOne.
  ///
  /// In en, this message translates to:
  /// **'{factors} favors the bite.'**
  String fcWhyHelpsOne(Object factors);

  /// No description provided for @fcWhyHelpsMany.
  ///
  /// In en, this message translates to:
  /// **'{factors} favor the bite.'**
  String fcWhyHelpsMany(Object factors);

  /// No description provided for @fcWhyHurtsOne.
  ///
  /// In en, this message translates to:
  /// **'{factors} reduces fish activity.'**
  String fcWhyHurtsOne(Object factors);

  /// No description provided for @fcWhyHurtsMany.
  ///
  /// In en, this message translates to:
  /// **'{factors} reduce fish activity.'**
  String fcWhyHurtsMany(Object factors);

  /// No description provided for @fcWhyBalanced.
  ///
  /// In en, this message translates to:
  /// **'Factors are balanced — no sharp swings in activity expected.'**
  String get fcWhyBalanced;

  /// No description provided for @fcPhrasePressurePos.
  ///
  /// In en, this message translates to:
  /// **'steady pressure keeps fish feeding near the bottom'**
  String get fcPhrasePressurePos;

  /// No description provided for @fcPhrasePressureNeg.
  ///
  /// In en, this message translates to:
  /// **'pressure swings put fish off the feed'**
  String get fcPhrasePressureNeg;

  /// No description provided for @fcPhraseTemperaturePos.
  ///
  /// In en, this message translates to:
  /// **'the water has warmed to a comfortable feeding range'**
  String get fcPhraseTemperaturePos;

  /// No description provided for @fcPhraseTemperatureNeg.
  ///
  /// In en, this message translates to:
  /// **'cold water slows fish down and they rarely feed'**
  String get fcPhraseTemperatureNeg;

  /// No description provided for @fcPhraseWindPos.
  ///
  /// In en, this message translates to:
  /// **'a light ripple pushes food toward the bank'**
  String get fcPhraseWindPos;

  /// No description provided for @fcPhraseWindNeg.
  ///
  /// In en, this message translates to:
  /// **'strong wind raises waves and fish move deep'**
  String get fcPhraseWindNeg;

  /// No description provided for @fcPhraseCloudPos.
  ///
  /// In en, this message translates to:
  /// **'cloud cover dims the light, so fish feed more boldly'**
  String get fcPhraseCloudPos;

  /// No description provided for @fcPhraseCloudNeg.
  ///
  /// In en, this message translates to:
  /// **'bright sun makes fish wary and they hide'**
  String get fcPhraseCloudNeg;

  /// No description provided for @fcPhrasePrecipPos.
  ///
  /// In en, this message translates to:
  /// **'dry, settled weather keeps fish predictable'**
  String get fcPhrasePrecipPos;

  /// No description provided for @fcPhrasePrecipNeg.
  ///
  /// In en, this message translates to:
  /// **'rain muddies the water and unsettles pressure'**
  String get fcPhrasePrecipNeg;

  /// No description provided for @fcPhraseSeasonPos.
  ///
  /// In en, this message translates to:
  /// **'seasonal peak — fish are feeding up hard'**
  String get fcPhraseSeasonPos;

  /// No description provided for @fcPhraseSeasonNeg.
  ///
  /// In en, this message translates to:
  /// **'seasonal lull — the fish\'s metabolism is slowed'**
  String get fcPhraseSeasonNeg;

  /// No description provided for @fcPhraseMoonPos.
  ///
  /// In en, this message translates to:
  /// **'active moon phase — a solunar feeding peak'**
  String get fcPhraseMoonPos;

  /// No description provided for @fcPhraseMoonNeg.
  ///
  /// In en, this message translates to:
  /// **'weak moon phase — a solunar lull'**
  String get fcPhraseMoonNeg;

  /// No description provided for @fcConfidenceHigh.
  ///
  /// In en, this message translates to:
  /// **'High confidence'**
  String get fcConfidenceHigh;

  /// No description provided for @fcConfidenceMedium.
  ///
  /// In en, this message translates to:
  /// **'Medium confidence'**
  String get fcConfidenceMedium;

  /// No description provided for @fcConfidenceLow.
  ///
  /// In en, this message translates to:
  /// **'Low confidence'**
  String get fcConfidenceLow;

  /// No description provided for @fcDayConditions.
  ///
  /// In en, this message translates to:
  /// **'Daytime weather'**
  String get fcDayConditions;

  /// No description provided for @fcPeriodNight.
  ///
  /// In en, this message translates to:
  /// **'Night'**
  String get fcPeriodNight;

  /// No description provided for @fcPeriodMorning.
  ///
  /// In en, this message translates to:
  /// **'Morning'**
  String get fcPeriodMorning;

  /// No description provided for @fcPeriodDay.
  ///
  /// In en, this message translates to:
  /// **'Day'**
  String get fcPeriodDay;

  /// No description provided for @fcPeriodEvening.
  ///
  /// In en, this message translates to:
  /// **'Evening'**
  String get fcPeriodEvening;

  /// No description provided for @fcRateWeak.
  ///
  /// In en, this message translates to:
  /// **'Weak'**
  String get fcRateWeak;

  /// No description provided for @fcRateMid.
  ///
  /// In en, this message translates to:
  /// **'Fair'**
  String get fcRateMid;

  /// No description provided for @fcRateGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get fcRateGood;

  /// No description provided for @fcRateGreat.
  ///
  /// In en, this message translates to:
  /// **'Great'**
  String get fcRateGreat;

  /// No description provided for @fcPeriodWhyTitle.
  ///
  /// In en, this message translates to:
  /// **'Why this score'**
  String get fcPeriodWhyTitle;

  /// No description provided for @fcPeriodTimeEffect.
  ///
  /// In en, this message translates to:
  /// **'Time of day'**
  String get fcPeriodTimeEffect;

  /// No description provided for @fcPeriodBaseTitle.
  ///
  /// In en, this message translates to:
  /// **'Underlying conditions'**
  String get fcPeriodBaseTitle;

  /// No description provided for @fcPeriodWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get fcPeriodWater;

  /// No description provided for @fcTodAdjCaption.
  ///
  /// In en, this message translates to:
  /// **'Time-of-day adjustment'**
  String get fcTodAdjCaption;

  /// No description provided for @fcTodDawn.
  ///
  /// In en, this message translates to:
  /// **'Dawn around {sunrise} is the daily feeding peak, so this period is lifted above the daytime baseline.'**
  String fcTodDawn(String sunrise);

  /// No description provided for @fcTodDusk.
  ///
  /// In en, this message translates to:
  /// **'Dusk around {sunset} — fish feed hard before dark, so the score is raised.'**
  String fcTodDusk(String sunset);

  /// No description provided for @fcTodWarmNight.
  ///
  /// In en, this message translates to:
  /// **'Water {water} is at or above the {warm} warm-night mark, so fish keep feeding after dark — the night score stays close to the daytime level.'**
  String fcTodWarmNight(String water, String warm);

  /// No description provided for @fcTodMidNight.
  ///
  /// In en, this message translates to:
  /// **'Water {water} sits between the cold mark ({cold}) and the warm-night mark ({warm}) — night feeding is only partial, and the warmer the water, the livelier the night.'**
  String fcTodMidNight(String water, String cold, String warm);

  /// No description provided for @fcTodColdNight.
  ///
  /// In en, this message translates to:
  /// **'Water {water} is below the {cold} cold mark — in cold water fish barely move at night, so the score drops well below the daytime level.'**
  String fcTodColdNight(String water, String cold);

  /// No description provided for @fcTodMiddayHot.
  ///
  /// In en, this message translates to:
  /// **'Midday is hot ({temp}, above {heat}) — fish retreat into shade and deeper water, so the bite dips.'**
  String fcTodMiddayHot(String temp, String heat);

  /// No description provided for @fcTodColdDay.
  ///
  /// In en, this message translates to:
  /// **'Water is cold ({water}, at or below {cold}); the daytime warming makes midday the relatively best window.'**
  String fcTodColdDay(String water, String cold);

  /// No description provided for @fcTodDayNeutral.
  ///
  /// In en, this message translates to:
  /// **'Daytime hours between the dawn and dusk peaks — calm, average activity.'**
  String get fcTodDayNeutral;

  /// No description provided for @spawnTitle.
  ///
  /// In en, this message translates to:
  /// **'Spawning window'**
  String get spawnTitle;

  /// No description provided for @spawnPreSpawn.
  ///
  /// In en, this message translates to:
  /// **'Water {water} and warming toward the spawn range — looks like the run-up to spawning.'**
  String spawnPreSpawn(String water);

  /// No description provided for @spawnSpawning.
  ///
  /// In en, this message translates to:
  /// **'Water {water} sits in the species\' spawn range — looks like spawning.'**
  String spawnSpawning(String water);

  /// No description provided for @spawnPostSpawn.
  ///
  /// In en, this message translates to:
  /// **'Water {water} has passed the spawn range — spawning looks to be over.'**
  String spawnPostSpawn(String water);

  /// No description provided for @spawnImpactPreSpawn.
  ///
  /// In en, this message translates to:
  /// **'A pre-spawn feeding burst is common — bite usually runs high (≈70–90 of 100). Fish while the window is open.'**
  String get spawnImpactPreSpawn;

  /// No description provided for @spawnImpactSpawning.
  ///
  /// In en, this message translates to:
  /// **'The index above doesn\'t account for spawning. If it\'s truly underway, the real bite is far lower — typically ≈10–20 of 100, for several days.'**
  String get spawnImpactSpawning;

  /// No description provided for @spawnImpactPostSpawn.
  ///
  /// In en, this message translates to:
  /// **'A post-spawn feeding burst usually follows — bite runs high again (≈70–90 of 100).'**
  String get spawnImpactPostSpawn;

  /// No description provided for @spawnCaveatEstimated.
  ///
  /// In en, this message translates to:
  /// **'This forecasts the window, not an exact date — spawning runs differently and in waves on every water, and we estimate water from air temperature.'**
  String get spawnCaveatEstimated;

  /// No description provided for @spawnCaveatRough.
  ///
  /// In en, this message translates to:
  /// **'A rough forecast: a large, slow water, spawning differs everywhere, and water is estimated from air — the timing can drift noticeably.'**
  String get spawnCaveatRough;

  /// No description provided for @moonNew.
  ///
  /// In en, this message translates to:
  /// **'New moon'**
  String get moonNew;

  /// No description provided for @moonWaxing.
  ///
  /// In en, this message translates to:
  /// **'Waxing'**
  String get moonWaxing;

  /// No description provided for @moonFull.
  ///
  /// In en, this message translates to:
  /// **'Full moon'**
  String get moonFull;

  /// No description provided for @moonWaning.
  ///
  /// In en, this message translates to:
  /// **'Waning'**
  String get moonWaning;

  /// No description provided for @fcHowToFish.
  ///
  /// In en, this message translates to:
  /// **'How to fish today'**
  String get fcHowToFish;

  /// No description provided for @fcHowToFishTomorrow.
  ///
  /// In en, this message translates to:
  /// **'How to fish tomorrow'**
  String get fcHowToFishTomorrow;

  /// No description provided for @fcHowToFishOn.
  ///
  /// In en, this message translates to:
  /// **'How to fish on {date}'**
  String fcHowToFishOn(String date);

  /// No description provided for @fcWhenTitle.
  ///
  /// In en, this message translates to:
  /// **'When'**
  String get fcWhenTitle;

  /// No description provided for @fcWindowsLabel.
  ///
  /// In en, this message translates to:
  /// **'Bite windows'**
  String get fcWindowsLabel;

  /// No description provided for @fcWindowDawn.
  ///
  /// In en, this message translates to:
  /// **'morning bite (dawn)'**
  String get fcWindowDawn;

  /// No description provided for @fcWindowDusk.
  ///
  /// In en, this message translates to:
  /// **'evening bite (dusk)'**
  String get fcWindowDusk;

  /// No description provided for @fcWindowNight.
  ///
  /// In en, this message translates to:
  /// **'night bite'**
  String get fcWindowNight;

  /// No description provided for @fcWindowMorning.
  ///
  /// In en, this message translates to:
  /// **'morning'**
  String get fcWindowMorning;

  /// No description provided for @fcWindowEvening.
  ///
  /// In en, this message translates to:
  /// **'evening'**
  String get fcWindowEvening;

  /// No description provided for @fcWindowDay.
  ///
  /// In en, this message translates to:
  /// **'midday'**
  String get fcWindowDay;

  /// No description provided for @fcWindowsWhyDawn.
  ///
  /// In en, this message translates to:
  /// **'Carp feed most at first and last light — dawn and dusk.'**
  String get fcWindowsWhyDawn;

  /// No description provided for @fcWindowsWhyNight.
  ///
  /// In en, this message translates to:
  /// **'In warm water carp feed actively at night.'**
  String get fcWindowsWhyNight;

  /// No description provided for @fcWindowsWhyDay.
  ///
  /// In en, this message translates to:
  /// **'Mild daytime weather keeps fish active.'**
  String get fcWindowsWhyDay;

  /// No description provided for @fcVerdictVeryLow.
  ///
  /// In en, this message translates to:
  /// **'Tough day — the bite is sluggish, maybe skip it.'**
  String get fcVerdictVeryLow;

  /// No description provided for @fcVerdictLow.
  ///
  /// In en, this message translates to:
  /// **'Weak bite. If you go — fish precise and patient.'**
  String get fcVerdictLow;

  /// No description provided for @fcVerdictMedium.
  ///
  /// In en, this message translates to:
  /// **'An average day — no guarantees, but there\'s a chance.'**
  String get fcVerdictMedium;

  /// No description provided for @fcVerdictMediumWindow.
  ///
  /// In en, this message translates to:
  /// **'There\'s a chance — try the {from}–{to} window.'**
  String fcVerdictMediumWindow(String from, String to);

  /// No description provided for @fcVerdictGood.
  ///
  /// In en, this message translates to:
  /// **'Good day — keep a bait in the water.'**
  String get fcVerdictGood;

  /// No description provided for @fcVerdictGoodWindow.
  ///
  /// In en, this message translates to:
  /// **'Worth going. Best time — {from}–{to}.'**
  String fcVerdictGoodWindow(String from, String to);

  /// No description provided for @fcVerdictExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent day — the bite is on!'**
  String get fcVerdictExcellent;

  /// No description provided for @fcVerdictExcellentWindow.
  ///
  /// In en, this message translates to:
  /// **'Excellent day! Don\'t miss the {from}–{to} window.'**
  String fcVerdictExcellentWindow(String from, String to);

  /// No description provided for @fcLevelVeryLow.
  ///
  /// In en, this message translates to:
  /// **'Very low'**
  String get fcLevelVeryLow;

  /// No description provided for @fcLevelLow.
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get fcLevelLow;

  /// No description provided for @fcLevelMedium.
  ///
  /// In en, this message translates to:
  /// **'Moderate'**
  String get fcLevelMedium;

  /// No description provided for @fcLevelGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get fcLevelGood;

  /// No description provided for @fcLevelExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get fcLevelExcellent;

  /// No description provided for @fcFactorPressure.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get fcFactorPressure;

  /// No description provided for @fcFactorTemperature.
  ///
  /// In en, this message translates to:
  /// **'Water temp'**
  String get fcFactorTemperature;

  /// No description provided for @fcFactorWind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get fcFactorWind;

  /// No description provided for @fcFactorCloud.
  ///
  /// In en, this message translates to:
  /// **'Cloud cover'**
  String get fcFactorCloud;

  /// No description provided for @fcFactorPrecipitation.
  ///
  /// In en, this message translates to:
  /// **'Precipitation'**
  String get fcFactorPrecipitation;

  /// No description provided for @fcFactorSeason.
  ///
  /// In en, this message translates to:
  /// **'Season'**
  String get fcFactorSeason;

  /// No description provided for @fcFactorMoon.
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get fcFactorMoon;

  /// No description provided for @fcCondClear.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get fcCondClear;

  /// No description provided for @fcCondPartly.
  ///
  /// In en, this message translates to:
  /// **'Partly cloudy'**
  String get fcCondPartly;

  /// No description provided for @fcCondCloudy.
  ///
  /// In en, this message translates to:
  /// **'Cloudy'**
  String get fcCondCloudy;

  /// No description provided for @fcCondRain.
  ///
  /// In en, this message translates to:
  /// **'Rain'**
  String get fcCondRain;

  /// No description provided for @fcCondStorm.
  ///
  /// In en, this message translates to:
  /// **'Storm'**
  String get fcCondStorm;

  /// No description provided for @fcChipPressure.
  ///
  /// In en, this message translates to:
  /// **'Pressure'**
  String get fcChipPressure;

  /// No description provided for @fcChipWind.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get fcChipWind;

  /// No description provided for @fcChipWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get fcChipWater;

  /// No description provided for @fcChipTemp.
  ///
  /// In en, this message translates to:
  /// **'Temperature'**
  String get fcChipTemp;

  /// No description provided for @fcChipMoon.
  ///
  /// In en, this message translates to:
  /// **'Moon'**
  String get fcChipMoon;

  /// No description provided for @fishCarp.
  ///
  /// In en, this message translates to:
  /// **'Carp'**
  String get fishCarp;

  /// No description provided for @fishCrucian.
  ///
  /// In en, this message translates to:
  /// **'Crucian carp'**
  String get fishCrucian;

  /// No description provided for @fishSheetTitle.
  ///
  /// In en, this message translates to:
  /// **'Fish'**
  String get fishSheetTitle;

  /// No description provided for @fcUnitHpaSuffix.
  ///
  /// In en, this message translates to:
  /// **'hPa'**
  String get fcUnitHpaSuffix;

  /// No description provided for @fcUnitMmHgSuffix.
  ///
  /// In en, this message translates to:
  /// **'mmHg'**
  String get fcUnitMmHgSuffix;

  /// No description provided for @fcUnitMsSuffix.
  ///
  /// In en, this message translates to:
  /// **'m/s'**
  String get fcUnitMsSuffix;

  /// No description provided for @fcUnitKmhSuffix.
  ///
  /// In en, this message translates to:
  /// **'km/h'**
  String get fcUnitKmhSuffix;

  /// No description provided for @fcWindCalm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get fcWindCalm;

  /// No description provided for @fcWindN.
  ///
  /// In en, this message translates to:
  /// **'N'**
  String get fcWindN;

  /// No description provided for @fcWindNE.
  ///
  /// In en, this message translates to:
  /// **'NE'**
  String get fcWindNE;

  /// No description provided for @fcWindE.
  ///
  /// In en, this message translates to:
  /// **'E'**
  String get fcWindE;

  /// No description provided for @fcWindSE.
  ///
  /// In en, this message translates to:
  /// **'SE'**
  String get fcWindSE;

  /// No description provided for @fcWindS.
  ///
  /// In en, this message translates to:
  /// **'S'**
  String get fcWindS;

  /// No description provided for @fcWindSW.
  ///
  /// In en, this message translates to:
  /// **'SW'**
  String get fcWindSW;

  /// No description provided for @fcWindW.
  ///
  /// In en, this message translates to:
  /// **'W'**
  String get fcWindW;

  /// No description provided for @fcWindNW.
  ///
  /// In en, this message translates to:
  /// **'NW'**
  String get fcWindNW;

  /// No description provided for @tabAdvice.
  ///
  /// In en, this message translates to:
  /// **'Tactics'**
  String get tabAdvice;

  /// No description provided for @adviceHeadline.
  ///
  /// In en, this message translates to:
  /// **'Suggested tactics'**
  String get adviceHeadline;

  /// No description provided for @adviceDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'Guidance based on the weather forecast, not a specific water.'**
  String get adviceDisclaimer;

  /// No description provided for @adviceKindBait.
  ///
  /// In en, this message translates to:
  /// **'Bait'**
  String get adviceKindBait;

  /// No description provided for @adviceKindAroma.
  ///
  /// In en, this message translates to:
  /// **'Aroma'**
  String get adviceKindAroma;

  /// No description provided for @adviceKindFeeding.
  ///
  /// In en, this message translates to:
  /// **'Feeding'**
  String get adviceKindFeeding;

  /// No description provided for @adviceKindDepth.
  ///
  /// In en, this message translates to:
  /// **'Depth'**
  String get adviceKindDepth;

  /// No description provided for @adviceKindLocation.
  ///
  /// In en, this message translates to:
  /// **'Spot'**
  String get adviceKindLocation;

  /// No description provided for @adviceKindTiming.
  ///
  /// In en, this message translates to:
  /// **'Timing'**
  String get adviceKindTiming;

  /// No description provided for @adviceWhyWater.
  ///
  /// In en, this message translates to:
  /// **'water {value}'**
  String adviceWhyWater(String value);

  /// No description provided for @adviceWhyWaterRising.
  ///
  /// In en, this message translates to:
  /// **'water warming day to day'**
  String get adviceWhyWaterRising;

  /// No description provided for @adviceWhyWaterFalling.
  ///
  /// In en, this message translates to:
  /// **'water cooling day to day'**
  String get adviceWhyWaterFalling;

  /// No description provided for @adviceWhyAirHot.
  ///
  /// In en, this message translates to:
  /// **'hot — air {value}'**
  String adviceWhyAirHot(String value);

  /// No description provided for @adviceWhyWind.
  ///
  /// In en, this message translates to:
  /// **'wind {value}'**
  String adviceWhyWind(String value);

  /// No description provided for @adviceWhyWindLight.
  ///
  /// In en, this message translates to:
  /// **'light wind'**
  String get adviceWhyWindLight;

  /// No description provided for @adviceWhyPressureFalling.
  ///
  /// In en, this message translates to:
  /// **'pressure is falling'**
  String get adviceWhyPressureFalling;

  /// No description provided for @adviceWhyRain.
  ///
  /// In en, this message translates to:
  /// **'rain during the day'**
  String get adviceWhyRain;

  /// No description provided for @adviceWhyBottomHabit.
  ///
  /// In en, this message translates to:
  /// **'mild water — carp hold near the bottom'**
  String get adviceWhyBottomHabit;

  /// No description provided for @adviceWhyBiteHigh.
  ///
  /// In en, this message translates to:
  /// **'high bite index'**
  String get adviceWhyBiteHigh;

  /// No description provided for @adviceWhyBiteMid.
  ///
  /// In en, this message translates to:
  /// **'moderate bite index'**
  String get adviceWhyBiteMid;

  /// No description provided for @adviceWhyBiteLow.
  ///
  /// In en, this message translates to:
  /// **'low bite index'**
  String get adviceWhyBiteLow;

  /// No description provided for @adviceWhyBestHours.
  ///
  /// In en, this message translates to:
  /// **'index peaks at this time'**
  String get adviceWhyBestHours;

  /// No description provided for @windFullN.
  ///
  /// In en, this message translates to:
  /// **'northerly'**
  String get windFullN;

  /// No description provided for @windFullNE.
  ///
  /// In en, this message translates to:
  /// **'north-easterly'**
  String get windFullNE;

  /// No description provided for @windFullE.
  ///
  /// In en, this message translates to:
  /// **'easterly'**
  String get windFullE;

  /// No description provided for @windFullSE.
  ///
  /// In en, this message translates to:
  /// **'south-easterly'**
  String get windFullSE;

  /// No description provided for @windFullS.
  ///
  /// In en, this message translates to:
  /// **'southerly'**
  String get windFullS;

  /// No description provided for @windFullSW.
  ///
  /// In en, this message translates to:
  /// **'south-westerly'**
  String get windFullSW;

  /// No description provided for @windFullW.
  ///
  /// In en, this message translates to:
  /// **'westerly'**
  String get windFullW;

  /// No description provided for @windFullNW.
  ///
  /// In en, this message translates to:
  /// **'north-westerly'**
  String get windFullNW;

  /// No description provided for @adviceBaitColdBrightTitle.
  ///
  /// In en, this message translates to:
  /// **'Bright small baits'**
  String get adviceBaitColdBrightTitle;

  /// No description provided for @adviceBaitColdBrightBody.
  ///
  /// In en, this message translates to:
  /// **'Cold water — corn, maggots, small pellets. Carp feeds little and cautiously.'**
  String get adviceBaitColdBrightBody;

  /// No description provided for @adviceBaitMidBoiliesTitle.
  ///
  /// In en, this message translates to:
  /// **'Boilies & pellets'**
  String get adviceBaitMidBoiliesTitle;

  /// No description provided for @adviceBaitMidBoiliesBody.
  ///
  /// In en, this message translates to:
  /// **'Water is warming — 10–16 mm boilies and pellets. Carp is more active.'**
  String get adviceBaitMidBoiliesBody;

  /// No description provided for @adviceBaitWarmFishmealTitle.
  ///
  /// In en, this message translates to:
  /// **'Fishmeal boilies'**
  String get adviceBaitWarmFishmealTitle;

  /// No description provided for @adviceBaitWarmFishmealBody.
  ///
  /// In en, this message translates to:
  /// **'Warm water, peak appetite — rich fishmeal boilies, tiger nuts, sweetcorn.'**
  String get adviceBaitWarmFishmealBody;

  /// No description provided for @adviceBaitHotSurfaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Floating baits'**
  String get adviceBaitHotSurfaceTitle;

  /// No description provided for @adviceBaitHotSurfaceBody.
  ///
  /// In en, this message translates to:
  /// **'Heat pushes carp up — pop-ups, floating pellets, a little bread.'**
  String get adviceBaitHotSurfaceBody;

  /// No description provided for @adviceBaitWarmingTitle.
  ///
  /// In en, this message translates to:
  /// **'Go bigger & smellier'**
  String get adviceBaitWarmingTitle;

  /// No description provided for @adviceBaitWarmingBody.
  ///
  /// In en, this message translates to:
  /// **'Warming trend — carp are switching on. Boilies, tiger nuts, scented baits.'**
  String get adviceBaitWarmingBody;

  /// No description provided for @adviceBaitCoolingTitle.
  ///
  /// In en, this message translates to:
  /// **'Downsize & brighten'**
  String get adviceBaitCoolingTitle;

  /// No description provided for @adviceBaitCoolingBody.
  ///
  /// In en, this message translates to:
  /// **'Water is dropping — fish turn cautious. Small pellets, corn, maggots.'**
  String get adviceBaitCoolingBody;

  /// No description provided for @adviceAromaSweetFruityTitle.
  ///
  /// In en, this message translates to:
  /// **'Sweet & fruity aroma'**
  String get adviceAromaSweetFruityTitle;

  /// No description provided for @adviceAromaSweetFruityBody.
  ///
  /// In en, this message translates to:
  /// **'A sweet, fruity profile (strawberry, scopex, honey). Keep one aroma across groundbait and hookbait — water-soluble, it attracts without overfeeding.'**
  String get adviceAromaSweetFruityBody;

  /// No description provided for @adviceAromaFishmealTitle.
  ///
  /// In en, this message translates to:
  /// **'Fishmeal aroma'**
  String get adviceAromaFishmealTitle;

  /// No description provided for @adviceAromaFishmealBody.
  ///
  /// In en, this message translates to:
  /// **'Warm water, peak feeding — a fishmeal profile (fishmeal, krill, liver). Works in the groundbait base and on the hook: oils and amino acids feed.'**
  String get adviceAromaFishmealBody;

  /// No description provided for @adviceAromaSpicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Spicy aroma'**
  String get adviceAromaSpicyTitle;

  /// No description provided for @adviceAromaSpicyBody.
  ///
  /// In en, this message translates to:
  /// **'Cold, coloured water — a spicy profile (chilli, pepper, Robin Red). Keep it in groundbait and hookbait — a strong signal when fish are lethargic.'**
  String get adviceAromaSpicyBody;

  /// No description provided for @adviceFeedMinimalTitle.
  ///
  /// In en, this message translates to:
  /// **'Feed sparingly'**
  String get adviceFeedMinimalTitle;

  /// No description provided for @adviceFeedMinimalBody.
  ///
  /// In en, this message translates to:
  /// **'Only a couple of handfuls, placed tight — don\'t overfeed inactive fish.'**
  String get adviceFeedMinimalBody;

  /// No description provided for @adviceFeedModerateTitle.
  ///
  /// In en, this message translates to:
  /// **'Feed moderately'**
  String get adviceFeedModerateTitle;

  /// No description provided for @adviceFeedModerateBody.
  ///
  /// In en, this message translates to:
  /// **'Medium volume; top up regularly in small amounts.'**
  String get adviceFeedModerateBody;

  /// No description provided for @adviceFeedHeavyTitle.
  ///
  /// In en, this message translates to:
  /// **'Feed heavily'**
  String get adviceFeedHeavyTitle;

  /// No description provided for @adviceFeedHeavyBody.
  ///
  /// In en, this message translates to:
  /// **'Carp is feeding hard — a bigger initial bed and frequent top-ups pay off.'**
  String get adviceFeedHeavyBody;

  /// No description provided for @adviceRigBottomTitle.
  ///
  /// In en, this message translates to:
  /// **'Fish the bottom'**
  String get adviceRigBottomTitle;

  /// No description provided for @adviceRigBottomBody.
  ///
  /// In en, this message translates to:
  /// **'Bottom rig on the deck or by features — the classic carp setup.'**
  String get adviceRigBottomBody;

  /// No description provided for @adviceRigZigTitle.
  ///
  /// In en, this message translates to:
  /// **'Try a zig rig'**
  String get adviceRigZigTitle;

  /// No description provided for @adviceRigZigBody.
  ///
  /// In en, this message translates to:
  /// **'Fish are holding in mid-water — a zig 1–2 m off the bottom can score.'**
  String get adviceRigZigBody;

  /// No description provided for @adviceRigSurfaceTitle.
  ///
  /// In en, this message translates to:
  /// **'Fish on top'**
  String get adviceRigSurfaceTitle;

  /// No description provided for @adviceRigSurfaceBody.
  ///
  /// In en, this message translates to:
  /// **'Carp basking near the surface — surface tackle and a floating bait.'**
  String get adviceRigSurfaceBody;

  /// No description provided for @adviceSwimWindwardTitle.
  ///
  /// In en, this message translates to:
  /// **'Fish into the wind'**
  String get adviceSwimWindwardTitle;

  /// No description provided for @adviceSwimWindwardBody.
  ///
  /// In en, this message translates to:
  /// **'A {dir} wind pushes warm surface water and food to the far bank; carp feed there.'**
  String adviceSwimWindwardBody(String dir);

  /// No description provided for @adviceSwimCalmFeaturesTitle.
  ///
  /// In en, this message translates to:
  /// **'Target features'**
  String get adviceSwimCalmFeaturesTitle;

  /// No description provided for @adviceSwimCalmFeaturesBody.
  ///
  /// In en, this message translates to:
  /// **'Light wind — work drop-offs, snags, reeds and depth changes.'**
  String get adviceSwimCalmFeaturesBody;

  /// No description provided for @adviceSwimShelteredTitle.
  ///
  /// In en, this message translates to:
  /// **'Go deep or shaded'**
  String get adviceSwimShelteredTitle;

  /// No description provided for @adviceSwimShelteredBody.
  ///
  /// In en, this message translates to:
  /// **'In the heat, look for cooler deep water and shaded areas.'**
  String get adviceSwimShelteredBody;

  /// No description provided for @adviceSpotReeds.
  ///
  /// In en, this message translates to:
  /// **'Reeds nearby — cast tight to the reed margin, carp patrol the edge.'**
  String get adviceSpotReeds;

  /// No description provided for @adviceSpotInflow.
  ///
  /// In en, this message translates to:
  /// **'Stream inflow nearby — fresh oxygenated water and washed-in food, strong in the heat.'**
  String get adviceSpotInflow;

  /// No description provided for @adviceSpotDam.
  ///
  /// In en, this message translates to:
  /// **'Dam nearby — depth and the old riverbed; carp hold there, more so in the heat.'**
  String get adviceSpotDam;

  /// No description provided for @adviceSpotIsland.
  ///
  /// In en, this message translates to:
  /// **'Island nearby — a carp magnet; work its margins and drop-offs.'**
  String get adviceSpotIsland;

  /// No description provided for @adviceTimePressureDropTitle.
  ///
  /// In en, this message translates to:
  /// **'Pre-front window'**
  String get adviceTimePressureDropTitle;

  /// No description provided for @adviceTimePressureDropBody.
  ///
  /// In en, this message translates to:
  /// **'Pressure is falling — a feeding spell is likely. Don\'t miss the next few hours.'**
  String get adviceTimePressureDropBody;

  /// No description provided for @adviceTimeBestWindowTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s best window'**
  String get adviceTimeBestWindowTitle;

  /// No description provided for @adviceTimeBestWindowBody.
  ///
  /// In en, this message translates to:
  /// **'Peak activity around {from}–{to}. Be on your spot a little early.'**
  String adviceTimeBestWindowBody(String from, String to);

  /// No description provided for @adviceTimeDawnDuskTitle.
  ///
  /// In en, this message translates to:
  /// **'Dawn & dusk'**
  String get adviceTimeDawnDuskTitle;

  /// No description provided for @adviceTimeDawnDuskBody.
  ///
  /// In en, this message translates to:
  /// **'Bank on early morning and late evening — the most reliable bite.'**
  String get adviceTimeDawnDuskBody;

  /// No description provided for @adviceTimeAllDayTitle.
  ///
  /// In en, this message translates to:
  /// **'Active all day'**
  String get adviceTimeAllDayTitle;

  /// No description provided for @adviceTimeAllDayBody.
  ///
  /// In en, this message translates to:
  /// **'High index — carp feed through the day; keep a bait in the water.'**
  String get adviceTimeAllDayBody;

  /// No description provided for @adviceTimeSlowPatientTitle.
  ///
  /// In en, this message translates to:
  /// **'Be patient'**
  String get adviceTimeSlowPatientTitle;

  /// No description provided for @adviceTimeSlowPatientBody.
  ///
  /// In en, this message translates to:
  /// **'Fish are sluggish — precise presentation, finer rigs, wait for a window.'**
  String get adviceTimeSlowPatientBody;

  /// No description provided for @crucianBaitColdAnimalTitle.
  ///
  /// In en, this message translates to:
  /// **'Animal bait'**
  String get crucianBaitColdAnimalTitle;

  /// No description provided for @crucianBaitColdAnimalBody.
  ///
  /// In en, this message translates to:
  /// **'Cold water — small bloodworm and maggots. One or two grubs at a time; crucian feed slowly.'**
  String get crucianBaitColdAnimalBody;

  /// No description provided for @crucianBaitWarmingTitle.
  ///
  /// In en, this message translates to:
  /// **'Worm & maggot'**
  String get crucianBaitWarmingTitle;

  /// No description provided for @crucianBaitWarmingBody.
  ///
  /// In en, this message translates to:
  /// **'Water is warming — crucian switch on. Dendrobaena worm, a bunch of maggots, bloodworm.'**
  String get crucianBaitWarmingBody;

  /// No description provided for @crucianBaitCoolingTitle.
  ///
  /// In en, this message translates to:
  /// **'Downsize & soften'**
  String get crucianBaitCoolingTitle;

  /// No description provided for @crucianBaitCoolingBody.
  ///
  /// In en, this message translates to:
  /// **'Cooling — crucian turn fussy. Small bloodworm or a sandwich, softer bait.'**
  String get crucianBaitCoolingBody;

  /// No description provided for @crucianBaitSandwichTitle.
  ///
  /// In en, this message translates to:
  /// **'Sandwich bait'**
  String get crucianBaitSandwichTitle;

  /// No description provided for @crucianBaitSandwichBody.
  ///
  /// In en, this message translates to:
  /// **'Transitional water — a sandwich: maggot with pearl barley or corn. Crucian are picky.'**
  String get crucianBaitSandwichBody;

  /// No description provided for @crucianBaitWarmPlantTitle.
  ///
  /// In en, this message translates to:
  /// **'Plant bait'**
  String get crucianBaitWarmPlantTitle;

  /// No description provided for @crucianBaitWarmPlantBody.
  ///
  /// In en, this message translates to:
  /// **'Warm water — pearl barley, semolina paste, corn, dough. Crucian switch to plant baits.'**
  String get crucianBaitWarmPlantBody;

  /// No description provided for @crucianBaitHotDoughTitle.
  ///
  /// In en, this message translates to:
  /// **'Soft dough'**
  String get crucianBaitHotDoughTitle;

  /// No description provided for @crucianBaitHotDoughBody.
  ///
  /// In en, this message translates to:
  /// **'Heat — soft dough, semolina paste, bread flake. A light sweet bait up in the water.'**
  String get crucianBaitHotDoughBody;

  /// No description provided for @crucianFeedTinyTitle.
  ///
  /// In en, this message translates to:
  /// **'Feed tight'**
  String get crucianFeedTinyTitle;

  /// No description provided for @crucianFeedTinyBody.
  ///
  /// In en, this message translates to:
  /// **'Crucian are shy and fill up fast — a few pinches of fine sweet groundbait, no more.'**
  String get crucianFeedTinyBody;

  /// No description provided for @crucianFeedSweetTitle.
  ///
  /// In en, this message translates to:
  /// **'Sweet groundbait'**
  String get crucianFeedSweetTitle;

  /// No description provided for @crucianFeedSweetBody.
  ///
  /// In en, this message translates to:
  /// **'Fine mix with garlic or vanilla scent; top up little and often, don\'t overfeed.'**
  String get crucianFeedSweetBody;

  /// No description provided for @crucianFeedActiveTitle.
  ///
  /// In en, this message translates to:
  /// **'Feed actively'**
  String get crucianFeedActiveTitle;

  /// No description provided for @crucianFeedActiveBody.
  ///
  /// In en, this message translates to:
  /// **'Crucian are feeding well — top up more often but in small amounts to hold the shoal.'**
  String get crucianFeedActiveBody;

  /// No description provided for @crucianRigFloatBottomTitle.
  ///
  /// In en, this message translates to:
  /// **'Float on the bottom'**
  String get crucianRigFloatBottomTitle;

  /// No description provided for @crucianRigFloatBottomBody.
  ///
  /// In en, this message translates to:
  /// **'The classic crucian setup — float tackle, bait resting on or just touching the bottom.'**
  String get crucianRigFloatBottomBody;

  /// No description provided for @crucianRigDropperTitle.
  ///
  /// In en, this message translates to:
  /// **'Dropper shot & fall'**
  String get crucianRigDropperTitle;

  /// No description provided for @crucianRigDropperBody.
  ///
  /// In en, this message translates to:
  /// **'Crucian have lifted into mid-water — a slow-falling bait, spread the shot, fish on the drop.'**
  String get crucianRigDropperBody;

  /// No description provided for @crucianRigShallowTitle.
  ///
  /// In en, this message translates to:
  /// **'Shallow near the top'**
  String get crucianRigShallowTitle;

  /// No description provided for @crucianRigShallowBody.
  ///
  /// In en, this message translates to:
  /// **'In the heat crucian bask in the shallows — light tackle, bait in the warm upper layer.'**
  String get crucianRigShallowBody;

  /// No description provided for @crucianSwimReedsTitle.
  ///
  /// In en, this message translates to:
  /// **'Reed margins'**
  String get crucianSwimReedsTitle;

  /// No description provided for @crucianSwimReedsBody.
  ///
  /// In en, this message translates to:
  /// **'Work gaps in the weed, reed margins and overgrown spots — that\'s where crucian feed.'**
  String get crucianSwimReedsBody;

  /// No description provided for @crucianSwimWarmShallowsTitle.
  ///
  /// In en, this message translates to:
  /// **'Warm shallows'**
  String get crucianSwimWarmShallowsTitle;

  /// No description provided for @crucianSwimWarmShallowsBody.
  ///
  /// In en, this message translates to:
  /// **'Water is cold — find the warmest shallows and bays heated by the sun.'**
  String get crucianSwimWarmShallowsBody;

  /// No description provided for @crucianSwimDeepEdgeTitle.
  ///
  /// In en, this message translates to:
  /// **'Deeper edge & shade'**
  String get crucianSwimDeepEdgeTitle;

  /// No description provided for @crucianSwimDeepEdgeBody.
  ///
  /// In en, this message translates to:
  /// **'In the heat crucian leave the shallows — fish holes, drop-offs and shaded areas.'**
  String get crucianSwimDeepEdgeBody;

  /// No description provided for @crucianTimePressureDropTitle.
  ///
  /// In en, this message translates to:
  /// **'Be patient'**
  String get crucianTimePressureDropTitle;

  /// No description provided for @crucianTimePressureDropBody.
  ///
  /// In en, this message translates to:
  /// **'Pressure is falling — crucian turn fussy and passive. Small soft baits, wait for short spells.'**
  String get crucianTimePressureDropBody;

  /// No description provided for @crucianTimeBestWindowTitle.
  ///
  /// In en, this message translates to:
  /// **'Today\'s best window'**
  String get crucianTimeBestWindowTitle;

  /// No description provided for @crucianTimeBestWindowBody.
  ///
  /// In en, this message translates to:
  /// **'Peak activity around {from}–{to}. Be on your spot a little early.'**
  String crucianTimeBestWindowBody(String from, String to);

  /// No description provided for @crucianTimeMorningTitle.
  ///
  /// In en, this message translates to:
  /// **'Morning bite'**
  String get crucianTimeMorningTitle;

  /// No description provided for @crucianTimeMorningBody.
  ///
  /// In en, this message translates to:
  /// **'Bank on early morning — the classic crucian spell, before the heat.'**
  String get crucianTimeMorningBody;

  /// No description provided for @crucianTimeStableWarmTitle.
  ///
  /// In en, this message translates to:
  /// **'Active in the day too'**
  String get crucianTimeStableWarmTitle;

  /// No description provided for @crucianTimeStableWarmBody.
  ///
  /// In en, this message translates to:
  /// **'Stable warmth — crucian feed through the day; keep a bait in the water.'**
  String get crucianTimeStableWarmBody;

  /// No description provided for @crucianTimePatientTitle.
  ///
  /// In en, this message translates to:
  /// **'Tight & patient'**
  String get crucianTimePatientTitle;

  /// No description provided for @crucianTimePatientBody.
  ///
  /// In en, this message translates to:
  /// **'Crucian are passive — fine rig, small bait, work one spot and wait for a spell.'**
  String get crucianTimePatientBody;

  /// No description provided for @spotTitle.
  ///
  /// In en, this message translates to:
  /// **'Your spot'**
  String get spotTitle;

  /// No description provided for @spotNoWater.
  ///
  /// In en, this message translates to:
  /// **'No water body near this point on the map. The weather forecast still works — set a spot to read the water.'**
  String get spotNoWater;

  /// No description provided for @spotSetOnMap.
  ///
  /// In en, this message translates to:
  /// **'Set spot on map'**
  String get spotSetOnMap;

  /// No description provided for @spotCheckFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn\'t check the map right now — the weather forecast still works.'**
  String get spotCheckFailed;

  /// No description provided for @spotTypeLake.
  ///
  /// In en, this message translates to:
  /// **'Lake'**
  String get spotTypeLake;

  /// No description provided for @spotTypePond.
  ///
  /// In en, this message translates to:
  /// **'Pond'**
  String get spotTypePond;

  /// No description provided for @spotTypeReservoir.
  ///
  /// In en, this message translates to:
  /// **'Reservoir'**
  String get spotTypeReservoir;

  /// No description provided for @spotTypeRiver.
  ///
  /// In en, this message translates to:
  /// **'River'**
  String get spotTypeRiver;

  /// No description provided for @spotTypeCanal.
  ///
  /// In en, this message translates to:
  /// **'Canal'**
  String get spotTypeCanal;

  /// No description provided for @spotTypeWater.
  ///
  /// In en, this message translates to:
  /// **'Water'**
  String get spotTypeWater;

  /// No description provided for @spotSizeHa.
  ///
  /// In en, this message translates to:
  /// **'~{value} ha'**
  String spotSizeHa(String value);

  /// No description provided for @spotSizeKm2.
  ///
  /// In en, this message translates to:
  /// **'~{value} km²'**
  String spotSizeKm2(String value);

  /// No description provided for @spotTipWindward.
  ///
  /// In en, this message translates to:
  /// **'A warm wind drives food and warmer water to the downwind bank — fish are likely more active there. Active bank: {bank}.'**
  String spotTipWindward(String bank);

  /// No description provided for @spotTipSheltered.
  ///
  /// In en, this message translates to:
  /// **'The wind is colder than the water — fish pull off the exposed bank into calmer water. Sheltered side: {bank}.'**
  String spotTipSheltered(String bank);

  /// No description provided for @spotTipNoWind.
  ///
  /// In en, this message translates to:
  /// **'Barely any wind — no bank stands out today; fish are spread across structure and depths.'**
  String get spotTipNoWind;

  /// No description provided for @spotTipColdWater.
  ///
  /// In en, this message translates to:
  /// **'Cold water — fish sit deep and sluggish on the bottom; wind moves them little right now.'**
  String get spotTipColdWater;

  /// No description provided for @spotWhereRiver.
  ///
  /// In en, this message translates to:
  /// **'Look for slack water: holes, outer bends, below riffles, around snags and bridge piers.'**
  String get spotWhereRiver;

  /// No description provided for @spotWhereCanal.
  ///
  /// In en, this message translates to:
  /// **'A canal is uniform — hunt anomalies: bends, bridges, inflows and weedy banks.'**
  String get spotWhereCanal;

  /// No description provided for @spotWherePondSmall.
  ///
  /// In en, this message translates to:
  /// **'A small water warms fast — fish hold by reeds, snags and the margins, dropping deeper in the heat.'**
  String get spotWherePondSmall;

  /// No description provided for @spotWhereMid.
  ///
  /// In en, this message translates to:
  /// **'A mid-size water — work the bays, drop-offs and weedy patches.'**
  String get spotWhereMid;

  /// No description provided for @spotWhereLarge.
  ///
  /// In en, this message translates to:
  /// **'A large water — fish roam; look to points, drop-offs and follow the wind.'**
  String get spotWhereLarge;

  /// No description provided for @spotWhereUnknown.
  ///
  /// In en, this message translates to:
  /// **'Still water — look to reeds, snags, drop-offs and bays.'**
  String get spotWhereUnknown;

  /// No description provided for @spotStructInflow.
  ///
  /// In en, this message translates to:
  /// **'A stream or channel feeds in nearby — current brings food and oxygen; a prime spot, especially in the heat.'**
  String get spotStructInflow;

  /// No description provided for @spotStructReeds.
  ///
  /// In en, this message translates to:
  /// **'Reeds or marsh line the bank here — cover and a food shelf for carp.'**
  String get spotStructReeds;

  /// No description provided for @spotStructDam.
  ///
  /// In en, this message translates to:
  /// **'A dam or dyke is close by — a sharp depth change and a classic holding spot.'**
  String get spotStructDam;

  /// No description provided for @spotStructIslands.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{There\'s an island on this water — fish often hold around islands: structure, depth changes and cover.} other{There are {count} islands on this water — fish often hold around them: structure, depth changes and cover.}}'**
  String spotStructIslands(int count);

  /// No description provided for @spotSourceType.
  ///
  /// In en, this message translates to:
  /// **'for this water type'**
  String get spotSourceType;

  /// No description provided for @spotEditTitle.
  ///
  /// In en, this message translates to:
  /// **'Spot position'**
  String get spotEditTitle;

  /// No description provided for @spotEditHint.
  ///
  /// In en, this message translates to:
  /// **'Drag the map to place the marker — move it to the better bank if needed.'**
  String get spotEditHint;

  /// No description provided for @spotSavePosition.
  ///
  /// In en, this message translates to:
  /// **'Save position'**
  String get spotSavePosition;

  /// No description provided for @spotViewOnMap.
  ///
  /// In en, this message translates to:
  /// **'View on the map'**
  String get spotViewOnMap;

  /// No description provided for @spotWindLabel.
  ///
  /// In en, this message translates to:
  /// **'Wind'**
  String get spotWindLabel;

  /// No description provided for @spotWindFrom.
  ///
  /// In en, this message translates to:
  /// **'Wind {dir}'**
  String spotWindFrom(String dir);

  /// No description provided for @spotDirN.
  ///
  /// In en, this message translates to:
  /// **'from the north'**
  String get spotDirN;

  /// No description provided for @spotDirNE.
  ///
  /// In en, this message translates to:
  /// **'from the northeast'**
  String get spotDirNE;

  /// No description provided for @spotDirE.
  ///
  /// In en, this message translates to:
  /// **'from the east'**
  String get spotDirE;

  /// No description provided for @spotDirSE.
  ///
  /// In en, this message translates to:
  /// **'from the southeast'**
  String get spotDirSE;

  /// No description provided for @spotDirS.
  ///
  /// In en, this message translates to:
  /// **'from the south'**
  String get spotDirS;

  /// No description provided for @spotDirSW.
  ///
  /// In en, this message translates to:
  /// **'from the southwest'**
  String get spotDirSW;

  /// No description provided for @spotDirW.
  ///
  /// In en, this message translates to:
  /// **'from the west'**
  String get spotDirW;

  /// No description provided for @spotDirNW.
  ///
  /// In en, this message translates to:
  /// **'from the northwest'**
  String get spotDirNW;

  /// No description provided for @spotUserHere.
  ///
  /// In en, this message translates to:
  /// **'Your spot is already on the active bank — you\'re in the right place.'**
  String get spotUserHere;

  /// No description provided for @spotUserOpposite.
  ///
  /// In en, this message translates to:
  /// **'Your spot is on the other side — it may fish better across the water.'**
  String get spotUserOpposite;

  /// No description provided for @spotSourceMap.
  ///
  /// In en, this message translates to:
  /// **'From OpenStreetMap data'**
  String get spotSourceMap;

  /// No description provided for @spotSourceWind.
  ///
  /// In en, this message translates to:
  /// **'from wind and water temperature'**
  String get spotSourceWind;

  /// No description provided for @spotDisclaimer.
  ///
  /// In en, this message translates to:
  /// **'A read on conditions from the map and weather — we can\'t see depth, bottom or fish stock.'**
  String get spotDisclaimer;

  /// No description provided for @settingsAlertsPrimeTitle.
  ///
  /// In en, this message translates to:
  /// **'Best day of the week'**
  String get settingsAlertsPrimeTitle;

  /// No description provided for @settingsAlertsPrimeSubtitle.
  ///
  /// In en, this message translates to:
  /// **'One heads-up about the week\'s best biting day across your spots'**
  String get settingsAlertsPrimeSubtitle;

  /// No description provided for @settingsAlertsExcellentTitle.
  ///
  /// In en, this message translates to:
  /// **'All excellent days'**
  String get settingsAlertsExcellentTitle;

  /// No description provided for @settingsAlertsExcellentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'A heads-up the evening before every day with excellent biting'**
  String get settingsAlertsExcellentSubtitle;

  /// No description provided for @settingsAlertsForCarp.
  ///
  /// In en, this message translates to:
  /// **'Carp notifications'**
  String get settingsAlertsForCarp;

  /// No description provided for @settingsAlertsForCrucian.
  ///
  /// In en, this message translates to:
  /// **'Crucian carp notifications'**
  String get settingsAlertsForCrucian;

  /// No description provided for @alertTitlePrime.
  ///
  /// In en, this message translates to:
  /// **'{fish}: best day of the week'**
  String alertTitlePrime(String fish);

  /// No description provided for @alertTitleExcellent.
  ///
  /// In en, this message translates to:
  /// **'{fish}: excellent biting tomorrow'**
  String alertTitleExcellent(String fish);

  /// No description provided for @alertWindowDawn.
  ///
  /// In en, this message translates to:
  /// **'tomorrow at dawn'**
  String get alertWindowDawn;

  /// No description provided for @alertWindowDusk.
  ///
  /// In en, this message translates to:
  /// **'tomorrow at dusk'**
  String get alertWindowDusk;

  /// No description provided for @alertWindowDay.
  ///
  /// In en, this message translates to:
  /// **'tomorrow daytime'**
  String get alertWindowDay;

  /// No description provided for @alertWindowNight.
  ///
  /// In en, this message translates to:
  /// **'tomorrow night'**
  String get alertWindowNight;

  /// No description provided for @alertWindowAny.
  ///
  /// In en, this message translates to:
  /// **'tomorrow'**
  String get alertWindowAny;

  /// No description provided for @alertSpotFallback.
  ///
  /// In en, this message translates to:
  /// **'Your spot'**
  String get alertSpotFallback;

  /// No description provided for @tabTips.
  ///
  /// In en, this message translates to:
  /// **'Tips'**
  String get tabTips;

  /// No description provided for @tipsNext.
  ///
  /// In en, this message translates to:
  /// **'Another tip'**
  String get tipsNext;

  /// No description provided for @tipLocationFirstTitle.
  ///
  /// In en, this message translates to:
  /// **'Location matters more than bait'**
  String get tipLocationFirstTitle;

  /// No description provided for @tipLocationFirstBody.
  ///
  /// In en, this message translates to:
  /// **'The most common beginner mistake is to turn up and cast into nowhere. Experienced carp anglers agree: knowing WHERE the fish are beats knowing WHAT to use — in the wrong swim no bait will save you. An hour spent finding feeding fish (shows, lines of bubbles, fish cruising near the surface) pays off more than ten hours fishing blind behind the alarms. Watch the water for 15–20 minutes first, then set up.'**
  String get tipLocationFirstBody;

  /// No description provided for @tipLocationFirstProof.
  ///
  /// In en, this message translates to:
  /// **'Carp media call watercraft — reading the water — the single biggest edge: in the wrong spot you will not catch, full stop.'**
  String get tipLocationFirstProof;

  /// No description provided for @tipMarginsTitle.
  ///
  /// In en, this message translates to:
  /// **'Fish the margins — the most underrated edge'**
  String get tipMarginsTitle;

  /// No description provided for @tipMarginsBody.
  ///
  /// In en, this message translates to:
  /// **'Most anglers cast as far as they can and ignore the water at their feet. Yet carp patrol the marginal shelf every single day and night, on every water. In one well-known case, anglers fishing the edge caught twice as many as those casting to the middle. Bonus: you can see the fish, present a bait to a specific one and learn from its behaviour. Approach the bank quietly.'**
  String get tipMarginsBody;

  /// No description provided for @tipMarginsProof.
  ///
  /// In en, this message translates to:
  /// **'Guides rate close-in edge fishing among the most underrated carp tactics.'**
  String get tipMarginsProof;

  /// No description provided for @tipSharpHooksTitle.
  ///
  /// In en, this message translates to:
  /// **'A blunt hook is a lost fish'**
  String get tipSharpHooksTitle;

  /// No description provided for @tipSharpHooksBody.
  ///
  /// In en, this message translates to:
  /// **'This is what beginners overlook most. The gap between a sharp hook and a needle-sharp one is huge: more pick-ups turn into bites, more bites into solid hook-holds. Hooks blunt not only on stones and mussels but even just lying on the bottom. Check the point before EVERY cast (the nail test) and change it at the first sign of dulling.'**
  String get tipSharpHooksBody;

  /// No description provided for @tipSharpHooksProof.
  ///
  /// In en, this message translates to:
  /// **'Carp experts agree sharpness sharply cuts hook pulls and lifts your hooking rate.'**
  String get tipSharpHooksProof;

  /// No description provided for @tipDontOverfeedTitle.
  ///
  /// In en, this message translates to:
  /// **'Do not overfeed the swim'**
  String get tipDontOverfeedTitle;

  /// No description provided for @tipDontOverfeedBody.
  ///
  /// In en, this message translates to:
  /// **'The second classic mistake. Too much bait spreads the fish over a wide area and pulls them away from your rig, and a full carp ignores your hookbait. Better little but accurate — small amounts to one tight spot. Overfeeding is a common cause of a blank even when fish are right there.'**
  String get tipDontOverfeedBody;

  /// No description provided for @tipDontOverfeedProof.
  ///
  /// In en, this message translates to:
  /// **'Overfeeding tops most lists of common carp-fishing mistakes.'**
  String get tipDontOverfeedProof;

  /// No description provided for @tipBaitRegularlyTitle.
  ///
  /// In en, this message translates to:
  /// **'Regular baiting beats big hits'**
  String get tipBaitRegularlyTitle;

  /// No description provided for @tipBaitRegularlyBody.
  ///
  /// In en, this message translates to:
  /// **'If you can, pre-bait your spot often. A kilo every day works better than five kilos every five days. Consistency teaches carp to return for a free meal without fear — so when you finally fish, the takes are confident. Stick to one bait through a campaign: the fish learn to search for it and often become preoccupied.'**
  String get tipBaitRegularlyBody;

  /// No description provided for @tipBaitRegularlyProof.
  ///
  /// In en, this message translates to:
  /// **'Bait companies and baiting guides agree — the key is regularity, less but more often.'**
  String get tipBaitRegularlyProof;

  /// No description provided for @tipHairRigTitle.
  ///
  /// In en, this message translates to:
  /// **'The hair rig — why it catches'**
  String get tipHairRigTitle;

  /// No description provided for @tipHairRigBody.
  ///
  /// In en, this message translates to:
  /// **'Carp do not gulp a bait down — they test it, sucking it in and blowing it out. With the bait on the hook itself they feel the metal and eject it along with the hook. On a hair the bait sits apart from a bare hook: as it is sucked in, the hook slides freely into the mouth and catches the bottom lip. Since the 1980s this principle has transformed hooking rates and become the backbone of modern carp fishing.'**
  String get tipHairRigBody;

  /// No description provided for @tipHairRigProof.
  ///
  /// In en, this message translates to:
  /// **'Decades-proven classic; the suck-and-test principle underpins every modern carp rig.'**
  String get tipHairRigProof;

  /// No description provided for @tipSweetcornTitle.
  ///
  /// In en, this message translates to:
  /// **'Sweetcorn — cheap and deadly'**
  String get tipSweetcornTitle;

  /// No description provided for @tipSweetcornBody.
  ///
  /// In en, this message translates to:
  /// **'Sweetcorn catches carp worldwide: bright, sweet, soft and rich in amino acids, so carp accept it as natural food. And it costs pennies — the same weight of boilies is many times more expensive. It often produces an instant result where carp feed mainly on natural food.'**
  String get tipSweetcornBody;

  /// No description provided for @tipSweetcornProof.
  ///
  /// In en, this message translates to:
  /// **'Corn is rated one of the most affordable and effective baits; the price gap with boilies runs to tens of times.'**
  String get tipSweetcornProof;

  /// No description provided for @tipMixedSizesTitle.
  ///
  /// In en, this message translates to:
  /// **'Mix your bait sizes'**
  String get tipMixedSizesTitle;

  /// No description provided for @tipMixedSizesBody.
  ///
  /// In en, this message translates to:
  /// **'Mix boilie sizes (say 12–15 mm and 18–22 mm) so carp cannot tune in to one calibre and feed cautiously — the chance they take your hookbait goes up. Small (12–15 mm) for winter and pressured waters, large (18–22 mm) against nuisance fish and for specimens.'**
  String get tipMixedSizesBody;

  /// No description provided for @tipMixedSizesProof.
  ///
  /// In en, this message translates to:
  /// **'Mixed sizes is a standard trick to break a fish size selectivity.'**
  String get tipMixedSizesProof;

  /// No description provided for @tipFallingPressureTitle.
  ///
  /// In en, this message translates to:
  /// **'Falling pressure — a feeding window'**
  String get tipFallingPressureTitle;

  /// No description provided for @tipFallingPressureBody.
  ///
  /// In en, this message translates to:
  /// **'As a front approaches and pressure drops, fish often feed harder. Carp react more mildly than predators (bottom-dwelling, less sensitive), but anglers note they feed longer and more willingly on low pressure. The best window is 6–12 hours before the front. Important: there is no magic pressure number — it is the downward TREND that works, not a reading.'**
  String get tipFallingPressureBody;

  /// No description provided for @tipFallingPressureProof.
  ///
  /// In en, this message translates to:
  /// **'Magazine observations recorded feeding up ~40% on falling pressure; yet the most-cited study (1983, bass) found only a weak correlation — so it is honest to talk of a trend, not a guarantee.'**
  String get tipFallingPressureProof;

  /// No description provided for @tipCrucianShyBitesTitle.
  ///
  /// In en, this message translates to:
  /// **'Crucians are shy tasters — dot the float down'**
  String get tipCrucianShyBitesTitle;

  /// No description provided for @tipCrucianShyBitesBody.
  ///
  /// In en, this message translates to:
  /// **'A crucian bite can be barely visible — a quarter-dip of a fine tip. If too much tip shows above the surface you will miss the delicate knocks. Shot the float right down, leaving the minimum showing. Crucians spit a bait the moment they feel resistance, so everything must be light and sensitive.'**
  String get tipCrucianShyBitesBody;

  /// No description provided for @tipCrucianShyBitesProof.
  ///
  /// In en, this message translates to:
  /// **'Crucian guides agree — dot the float down; a fine tip is what registers shy bites.'**
  String get tipCrucianShyBitesProof;

  /// No description provided for @tipCrucianFineTackleTitle.
  ///
  /// In en, this message translates to:
  /// **'Crucians: fine and small'**
  String get tipCrucianFineTackleTitle;

  /// No description provided for @tipCrucianFineTackleBody.
  ///
  /// In en, this message translates to:
  /// **'Thick line and big hooks are a no-go. Use a fine but strong hook in a small size: 18–20 for maggot/caster, 16 for corn/pellet. Do not overfeed (tench and bream will move in): start with golf-ball nuggets of groundbait and a few hookbait samples, and add more only if you are catching well.'**
  String get tipCrucianFineTackleBody;

  /// No description provided for @tipCrucianFineTackleProof.
  ///
  /// In en, this message translates to:
  /// **'Standard crucian advice — fine tackle, a small hook, measured feeding.'**
  String get tipCrucianFineTackleProof;

  /// No description provided for @tipCrucianSlowFallTitle.
  ///
  /// In en, this message translates to:
  /// **'Crucians take the falling bait'**
  String get tipCrucianSlowFallTitle;

  /// No description provided for @tipCrucianSlowFallBody.
  ///
  /// In en, this message translates to:
  /// **'They often bite as the bait sinks slowly. Space small shot evenly for a slow fall, and set the last tiny tell-tale shot just 5–7 cm from the hook — it registers a shy bite fast.'**
  String get tipCrucianSlowFallBody;

  /// No description provided for @tipCrucianSlowFallProof.
  ///
  /// In en, this message translates to:
  /// **'A slow fall plus a tell-tale shot near the hook is a typical crucian tactic.'**
  String get tipCrucianSlowFallProof;

  /// No description provided for @tipWaterTempTitle.
  ///
  /// In en, this message translates to:
  /// **'Water beats the calendar'**
  String get tipWaterTempTitle;

  /// No description provided for @tipWaterTempBody.
  ///
  /// In en, this message translates to:
  /// **'Carp are cold-blooded — appetite tracks WATER temperature, not the date. Peak activity is around 18–24 °C; below ~10 °C the metabolism slows and feeding almost stops. In practice: in cold water go small on the bait and fish the midday warmth in the shallows; in heat fish the night and dawn. Do not expect a feeding frenzy in icy water at noon.'**
  String get tipWaterTempBody;

  /// No description provided for @tipWaterTempProof.
  ///
  /// In en, this message translates to:
  /// **'Cyprinid biology: metabolism depends directly on water temperature — which is why the bite drops sharply in winter.'**
  String get tipWaterTempProof;

  /// No description provided for @tipPvaBagTitle.
  ///
  /// In en, this message translates to:
  /// **'PVA bag — a mouthful right by the hook'**
  String get tipPvaBagTitle;

  /// No description provided for @tipPvaBagBody.
  ///
  /// In en, this message translates to:
  /// **'A water-soluble PVA bag of pellet or crumb threaded onto the hook drops a neat pile of feed exactly where your hookbait lands. It melts in minutes, leaving an attractive patch and a tangle-free presentation on the cast. It shines on silt and in weed, where a lone bait gets lost — the carp finds a “table” and feeds right on top of your rig.'**
  String get tipPvaBagBody;

  /// No description provided for @tipPvaBagProof.
  ///
  /// In en, this message translates to:
  /// **'PVA tackle is a modern carp-fishing standard for placing feed precisely at the hook.'**
  String get tipPvaBagProof;

  /// No description provided for @tipFeatureFindingTitle.
  ///
  /// In en, this message translates to:
  /// **'Find the features — carp patrol the contours'**
  String get tipFeatureFindingTitle;

  /// No description provided for @tipFeatureFindingBody.
  ///
  /// In en, this message translates to:
  /// **'Fish are not spread evenly — they hold near features: drop-offs, depth changes, hard bottom amid silt, weed edges, snags. Before fishing, “feel” the bottom with a lead: drag it and sense how the ground changes, count the depth by the drop. A cast onto a feature you found beats a random cast “for distance”.'**
  String get tipFeatureFindingBody;

  /// No description provided for @tipFeatureFindingProof.
  ///
  /// In en, this message translates to:
  /// **'Feeling out features with a marker or lead is a basic carp skill — carp patrol structure, not open emptiness.'**
  String get tipFeatureFindingProof;

  /// No description provided for @tipStayQuietTitle.
  ///
  /// In en, this message translates to:
  /// **'Stay quiet on the bank — carp spook easily'**
  String get tipStayQuietTitle;

  /// No description provided for @tipStayQuietBody.
  ///
  /// In en, this message translates to:
  /// **'Carp sense vibration through the lateral line and “hear” with the body. Heavy footfalls, slammed doors, banging on the boat, a heavy cast at your feet — and fish leave the shallows and the margins. Approach the water quietly, keep light off the surface, set up gently. It matters most when fishing the edge and the shallows.'**
  String get tipStayQuietBody;

  /// No description provided for @tipStayQuietProof.
  ///
  /// In en, this message translates to:
  /// **'A carp lateral line picks up the faintest movement — loud noise genuinely puts fish on guard.'**
  String get tipStayQuietProof;

  /// No description provided for @tipParticlesTitle.
  ///
  /// In en, this message translates to:
  /// **'Particles (hemp) hold the shoal'**
  String get tipParticlesTitle;

  /// No description provided for @tipParticlesBody.
  ///
  /// In en, this message translates to:
  /// **'Small feed like hemp creates a patch that makes carp root around and feed in one spot without filling up fast — so fish linger over your rig. A safety note: dry particles (especially tigernuts and beans) must be soaked AND boiled until done before use — undercooked, they can harm the fish.'**
  String get tipParticlesBody;

  /// No description provided for @tipParticlesProof.
  ///
  /// In en, this message translates to:
  /// **'Hemp is a classic for holding a shoal; preparing particles properly is a well-known fish-safety rule.'**
  String get tipParticlesProof;

  /// No description provided for @tipFishCareTitle.
  ///
  /// In en, this message translates to:
  /// **'Care for the fish — it will bite again'**
  String get tipFishCareTitle;

  /// No description provided for @tipFishCareBody.
  ///
  /// In en, this message translates to:
  /// **'A big carp takes decades to grow and can be caught again — if it is released healthy. Wet hands and a wet mat or grass, minimum time out of water, never lay the fish on dry sand or stones, unhook gently (another reason to keep the hook sharp). Photos low over the mat, quick. A healthy released carp is a future bite — for you and others.'**
  String get tipFishCareBody;

  /// No description provided for @tipFishCareProof.
  ///
  /// In en, this message translates to:
  /// **'Catch-and-release practice among carp anglers: gentle handling preserves the stock and your future catches.'**
  String get tipFishCareProof;

  /// No description provided for @tipCrucianWarmShallowsTitle.
  ///
  /// In en, this message translates to:
  /// **'Crucians love the warm shallows'**
  String get tipCrucianWarmShallowsTitle;

  /// No description provided for @tipCrucianWarmShallowsBody.
  ///
  /// In en, this message translates to:
  /// **'Crucians love warmth and weed. In spring and early summer they come to feed first in the warmed shallows — small bays, by the reeds and lilies, where the water is a couple of degrees warmer. Look for quiet, weedy, well-warmed spots; there is almost no crucian in the depths at that time. The warmer the water, the more active the crucian.'**
  String get tipCrucianWarmShallowsBody;

  /// No description provided for @tipCrucianWarmShallowsProof.
  ///
  /// In en, this message translates to:
  /// **'The crucian is a warmth-loving weed fish; the early warming of the shallows explains why it feeds there first.'**
  String get tipCrucianWarmShallowsProof;

  /// No description provided for @fcAlgoFactsTitle.
  ///
  /// In en, this message translates to:
  /// **'Algorithm insights'**
  String get fcAlgoFactsTitle;

  /// No description provided for @fcAlgoFactLabel.
  ///
  /// In en, this message translates to:
  /// **'Fact of the day'**
  String get fcAlgoFactLabel;

  /// No description provided for @algoFactWaterModelTitle.
  ///
  /// In en, this message translates to:
  /// **'We track water, not air'**
  String get algoFactWaterModelTitle;

  /// No description provided for @algoFactWaterModelBody.
  ///
  /// In en, this message translates to:
  /// **'Carp live in water, and it warms up with a lag. Instead of using air temperature directly, we model the water temperature with a heat-exchange equation — like a cup of tea cooling down.'**
  String get algoFactWaterModelBody;

  /// No description provided for @algoFactThermalInertiaTitle.
  ///
  /// In en, this message translates to:
  /// **'Every water body has its own thermal inertia'**
  String get algoFactThermalInertiaTitle;

  /// No description provided for @algoFactThermalInertiaBody.
  ///
  /// In en, this message translates to:
  /// **'A river responds to the weather in a couple of days, a pond more slowly, and a large reservoir takes weeks to swing. So we tune the warming speed to the type and size of the water body.'**
  String get algoFactThermalInertiaBody;

  /// No description provided for @algoFactPressureTrendTitle.
  ///
  /// In en, this message translates to:
  /// **'It\'s the pressure trend, not the level'**
  String get algoFactPressureTrendTitle;

  /// No description provided for @algoFactPressureTrendBody.
  ///
  /// In en, this message translates to:
  /// **'The best bite comes not at some \'good\' pressure but during a gentle drop before a front. A sharp crash and a sharp spike are both penalised. We read the trend over both 6 and 24 hours.'**
  String get algoFactPressureTrendBody;

  /// No description provided for @algoFactFrontMemoryTitle.
  ///
  /// In en, this message translates to:
  /// **'We remember a passing front for a day'**
  String get algoFactFrontMemoryTitle;

  /// No description provided for @algoFactFrontMemoryBody.
  ///
  /// In en, this message translates to:
  /// **'Even once the pressure has recovered, fish are still in shock after a cold front. We keep a separate penalty for a full day — carp need one or two days to recover.'**
  String get algoFactFrontMemoryBody;

  /// No description provided for @algoFactWeakestLinkTitle.
  ///
  /// In en, this message translates to:
  /// **'The weakest-link principle'**
  String get algoFactWeakestLinkTitle;

  /// No description provided for @algoFactWeakestLinkBody.
  ///
  /// In en, this message translates to:
  /// **'Many calculators just add up points, so good pressure \'rescues\' freezing water. With us, temperature, season and pressure act as fuses: no perfect wind can save dead water.'**
  String get algoFactWeakestLinkBody;

  /// No description provided for @algoFactHeatCalmTitle.
  ///
  /// In en, this message translates to:
  /// **'A penalty for heat plus dead calm'**
  String get algoFactHeatCalmTitle;

  /// No description provided for @algoFactHeatCalmBody.
  ///
  /// In en, this message translates to:
  /// **'The drop kicks in only when heat and dead calm coincide — that\'s when the water runs short of oxygen. On their own, a hot day or no wind aren\'t as harmful.'**
  String get algoFactHeatCalmBody;

  /// No description provided for @algoFactRealSunTitle.
  ///
  /// In en, this message translates to:
  /// **'Feeding peaks tied to the real sun'**
  String get algoFactRealSunTitle;

  /// No description provided for @algoFactRealSunBody.
  ///
  /// In en, this message translates to:
  /// **'No fixed \'bite at 6 a.m.\'. We take the actual sunrise and sunset for your spot, boost the morning and evening windows, and dampen the hot midday.'**
  String get algoFactRealSunBody;

  /// No description provided for @algoFactSpawnPhysicsTitle.
  ///
  /// In en, this message translates to:
  /// **'Spawning from physics, not the calendar'**
  String get algoFactSpawnPhysicsTitle;

  /// No description provided for @algoFactSpawnPhysicsBody.
  ///
  /// In en, this message translates to:
  /// **'We work out the spawning phase from water temperature and the day length at your latitude. And we\'re honest about the confidence: on a slow water body the signal is blurry.'**
  String get algoFactSpawnPhysicsBody;

  /// No description provided for @algoFactSpeciesModelsTitle.
  ///
  /// In en, this message translates to:
  /// **'Carp and crucian are two different models'**
  String get algoFactSpeciesModelsTitle;

  /// No description provided for @algoFactSpeciesModelsBody.
  ///
  /// In en, this message translates to:
  /// **'It isn\'t one formula with a checkbox. Crucian have a higher temperature optimum, are more sensitive to pressure, like a gentle ripple and barely bite at night — dozens of parameters are tuned per species.'**
  String get algoFactSpeciesModelsBody;

  /// No description provided for @algoFactBiteWindowsTitle.
  ///
  /// In en, this message translates to:
  /// **'Bite windows, not just hours'**
  String get algoFactBiteWindowsTitle;

  /// No description provided for @algoFactBiteWindowsBody.
  ///
  /// In en, this message translates to:
  /// **'We gather the good hours into continuous windows, bridge single-hour dips, and correctly stitch together windows that cross midnight.'**
  String get algoFactBiteWindowsBody;

  /// No description provided for @alertBody.
  ///
  /// In en, this message translates to:
  /// **'{spot}: {when}, bite index {index}'**
  String alertBody(String spot, String when, int index);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['de', 'en', 'es', 'fr', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
