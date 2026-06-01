// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get welcomeTitle => 'Willkommen';

  @override
  String get welcomeSubtitle => 'Schnelles Setup — unter einer Minute';

  @override
  String get welcomeCta => 'Loslegen';

  @override
  String get languageSheetTitle => 'Sprache';

  @override
  String get languageSheetSubtitle => 'Wähle deine Sprache';

  @override
  String get themeSheetSubtitle => 'Wähle das Aussehen der App';

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
  String get commonContinue => 'Weiter';

  @override
  String get quizQ1Question => 'Was fängst du?';

  @override
  String get quizQ1Subtitle => 'Wir passen die Vorhersage an deinen Fisch an';

  @override
  String get quizQ1OptLearn => 'Karpfen';

  @override
  String get quizQ1OptHabit => 'Karausche';

  @override
  String get quizQ1OptSolve => 'Beide';

  @override
  String get quizQ2Question => 'Umsonst rausgefahren?';

  @override
  String get quizQ2Subtitle => 'Sei ehrlich — so helfen wir dir besser';

  @override
  String get quizQ2OptDaily => 'Ja, schon oft';

  @override
  String get quizQ2OptWeekly => 'Manchmal';

  @override
  String get quizQ2OptRarely => 'Selten — meist fange ich';

  @override
  String get quizQ3Question => 'Wie planst du Touren?';

  @override
  String get quizQ3Subtitle => 'Bestimmt, was wir dir zuerst zeigen';

  @override
  String get quizQ3OptSimple => 'Ich plane im Voraus';

  @override
  String get quizQ3OptResult => 'Ich fahre spontan';

  @override
  String get quizQ3OptFlexible => 'Mal so, mal so';

  @override
  String get quizQ4Question => 'Wie oft angelst du?';

  @override
  String get quizQ4Subtitle => 'Wir melden dir die besten Tage';

  @override
  String get quizQ4OptWeekly => 'Jede Woche';

  @override
  String get quizQ4OptMonthly => 'Ein paar Mal im Monat';

  @override
  String get quizQ4OptRarely => 'Ab und zu';

  @override
  String get onbAnalyzingTitle => 'Bedingungen werden analysiert';

  @override
  String get onbAnalyzingSubtitle => 'Wetter, Druck und Mond werden berechnet…';

  @override
  String get onbResultTitle => 'Deine Beiss-Vorhersage ist fertig';

  @override
  String get onbResultSubtitle =>
      'Der heutige Biss ist gratis. Die 7-Tage-Vorhersage gibt\'s im Abo.';

  @override
  String get onbResultTodayBadge => 'Heute · gratis';

  @override
  String get onbResultLockedLabel => '7-Tage-Vorhersage';

  @override
  String get onbResultCta => 'Vorhersage ansehen';

  @override
  String get paywallSkipToday => 'Erst heute gratis ansehen';

  @override
  String get paywallTitle => 'Vollzugriff freischalten';

  @override
  String get planYearly => '12 Monate';

  @override
  String get planWeekly => 'Woche';

  @override
  String trialBadgeFreeDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage gratis',
      one: '$days Tag gratis',
    );
    return '$_temp0';
  }

  @override
  String trialDayLabel(int n) {
    return 'Tag $n';
  }

  @override
  String get trialDay1Desc => 'Zugriff freigeschaltet';

  @override
  String get trialDayMidDesc => 'Wir erinnern dich einen Tag vorher';

  @override
  String get trialDayEndDesc => 'Abo beginnt';

  @override
  String get featureUnlimited => 'Alle Funktionen ohne Limits';

  @override
  String get featureUpdates => 'Regelmäßige Updates';

  @override
  String get featurePrivacy => 'Sicher und privat';

  @override
  String get featureSupport => 'Bevorzugter Support';

  @override
  String get faqTitle => 'Häufige Fragen';

  @override
  String get faqCancelQ => 'Kann ich kündigen?';

  @override
  String get faqCancelA =>
      'Ja, jederzeit über die App Store- oder Google Play-Einstellungen. Wenn du vor Ende der Testphase kündigst, wird nichts berechnet.';

  @override
  String get faqChargeQ => 'Wann werde ich belastet?';

  @override
  String get faqChargeA =>
      'Bei einer Testphase — nach deren Ende. Wir erinnern dich vorher, damit du entscheiden kannst.';

  @override
  String get faqIncludesQ => 'Was ist im Abo enthalten?';

  @override
  String get faqIncludesA =>
      'Alle App-Funktionen ohne Limits, regelmäßige Updates und bevorzugter Support.';

  @override
  String get paywallNoPaymentNow => 'Keine Zahlung jetzt';

  @override
  String get paywallCtaStartFree => 'Gratis starten';

  @override
  String get paywallCtaSubscribe => 'Abonnieren';

  @override
  String get paywallDisclaimer =>
      'Verlängert sich automatisch. Jederzeit kündbar';

  @override
  String get menuRestore => 'Käufe wiederherstellen';

  @override
  String get menuTerms => 'Nutzungsbedingungen';

  @override
  String get menuPrivacy => 'Datenschutz';

  @override
  String get menuPromo => 'Hast du einen Code?';

  @override
  String get menuRestart => 'Von vorn beginnen';

  @override
  String get promoTitle => 'Promo-Code eingeben';

  @override
  String get promoSubtitle =>
      'Wenn du einen Aktivierungscode hast — gib ihn unten ein';

  @override
  String get promoCtaActivate => 'Aktivieren';

  @override
  String get promoErrorInvalid => 'Ungültiger Code';

  @override
  String promoSuccess(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days Tage',
      one: '$days Tag',
    );
    return 'Abo aktiviert für $_temp0';
  }

  @override
  String get homeTitle => 'Startseite';

  @override
  String get homeSubNotActive => 'Abo nicht aktiv';

  @override
  String get homeOnboardingNotDone => 'Onboarding nicht abgeschlossen';

  @override
  String get homeAnswersLabel => 'Deine Antworten:';

  @override
  String get homeBtnReplayOnboarding => 'Onboarding neu starten';

  @override
  String get homeBtnToPaywall => 'Zum Paywall';

  @override
  String get homeBtnResetSub => 'Abo zurücksetzen';

  @override
  String homePremiumBadge(String remaining) {
    return 'Premium aktiv · noch $remaining';
  }

  @override
  String remainingDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n Tage',
      one: '$n Tag',
    );
    return '$_temp0';
  }

  @override
  String remainingHours(int n) {
    return '$n Std.';
  }

  @override
  String remainingMinutes(int n) {
    return '$n Min.';
  }

  @override
  String get tabHome => 'Start';

  @override
  String get tabAnalytics => 'Analyse';

  @override
  String get tabSettings => 'Einstellungen';

  @override
  String get homeTabEmpty => 'Der Start-Tab ist noch leer';

  @override
  String get analyticsTabEmpty => 'Der Analyse-Tab ist noch leer';

  @override
  String get settingsSubscriptionTitle => 'Abo';

  @override
  String get settingsSubActive => 'Premium aktiv';

  @override
  String get settingsSubInactive => 'Abo nicht aktiv';

  @override
  String settingsSubExpiresLeft(String remaining) {
    return 'noch $remaining';
  }

  @override
  String get settingsSubBtnGoPaywall => 'Abo aktivieren';

  @override
  String get settingsSubBtnManage => 'Abo verwalten';

  @override
  String get settingsRestartOnboarding => 'Onboarding neu starten';

  @override
  String get restartConfirmTitle => 'Onboarding neu starten?';

  @override
  String get restartConfirmMessage =>
      'Deine Antworten werden gelöscht und du kehrst zum Willkommensbildschirm zurück.';

  @override
  String get commonCancel => 'Abbrechen';

  @override
  String get commonConfirm => 'Neu starten';

  @override
  String get commonUndo => 'Rückgängig';

  @override
  String get commonDelete => 'Löschen';

  @override
  String get tabNotes => 'Notizen';

  @override
  String get noteNew => 'Notiz';

  @override
  String get notesEmptyTitle => 'Noch keine Notizen';

  @override
  String get notesEmptySubtitle =>
      'Halte deine Beobachtungen fest: Biss, Köder, Wetter.';

  @override
  String get noteNewTitle => 'Neue Notiz';

  @override
  String get noteEditTitle => 'Notiz';

  @override
  String get noteTextHint => 'Was ist dir aufgefallen? Biss, Köder, Wetter…';

  @override
  String get noteLocationLabel => 'Ort';

  @override
  String get noteLocationNone => 'Kein Ort';

  @override
  String get notePhotosLabel => 'Fotos';

  @override
  String get notePhotoCamera => 'Kamera';

  @override
  String get notePhotoGallery => 'Galerie';

  @override
  String get noteConditionsTitle => 'Bedingungen bei der Notiz';

  @override
  String get noteSave => 'Notiz speichern';

  @override
  String get noteDeleteConfirm => 'Notiz löschen?';

  @override
  String get noteDeleted => 'Notiz gelöscht';

  @override
  String get noteEmptyError => 'Text oder Foto hinzufügen';

  @override
  String get noteDiscardTitle => 'Änderungen verwerfen?';

  @override
  String get noteDiscard => 'Verwerfen';

  @override
  String get settingsNotificationsTitle => 'Benachrichtigungen';

  @override
  String get settingsNotifMaster => 'Alle Benachrichtigungen';

  @override
  String get settingsNotifReminders => 'Erinnerungen';

  @override
  String get settingsNotifNews => 'News & Updates';

  @override
  String get settingsAboutTitle => 'Über';

  @override
  String get settingsRateApp => 'App bewerten';

  @override
  String get settingsShareApp => 'Mit Freunden teilen';

  @override
  String get settingsContactSupport => 'Support kontaktieren';

  @override
  String shareMessage(String appName, String appLink) {
    return 'Probier $appName aus — $appLink';
  }

  @override
  String supportEmailSubject(String appName) {
    return 'Hilfe zu $appName';
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
  String get settingsAppearanceTitle => 'Erscheinungsbild';

  @override
  String get settingsLanguage => 'Sprache';

  @override
  String get settingsUnitsTitle => 'Einheiten';

  @override
  String get unitTemperature => 'Temperatur';

  @override
  String get unitWind => 'Wind';

  @override
  String get unitPressure => 'Luftdruck';

  @override
  String get settingsMoreTitle => 'Mehr';

  @override
  String get settingsSubInactiveSubtitle => 'Alle Funktionen freischalten';

  @override
  String get settingsThemeTitle => 'Design';

  @override
  String get themeSystem => 'System';

  @override
  String get themeLight => 'Hell';

  @override
  String get themeDark => 'Dunkel';

  @override
  String mockPurchase(String plan) {
    return 'Mock-Kauf: $plan';
  }

  @override
  String get mockRestore => 'Mock: Käufe wiederhergestellt';

  @override
  String get tabForecast => 'Prognose';

  @override
  String get locCurrent => 'Mein Standort';

  @override
  String get locDefault => 'Standardort';

  @override
  String get locationSheetTitle => 'Standort';

  @override
  String get locFallbackBanner =>
      'Standort ist aus — es wird der Standardspot gezeigt. Die Prognose passt evtl. nicht zu deiner Gegend.';

  @override
  String get locFallbackAction => 'Wählen';

  @override
  String get fcLoading => 'Prognose wird geladen…';

  @override
  String get fcError => 'Prognose konnte nicht geladen werden';

  @override
  String get fcErrorSubtitle => 'Prüfe deine Verbindung und versuche es erneut';

  @override
  String get fcRetry => 'Erneut versuchen';

  @override
  String get fcRefresh => 'Wochenprognose aktualisieren';

  @override
  String get fcRefreshing => 'Prognose wird aktualisiert…';

  @override
  String get fcRefreshStep1 => 'Wetter wird abgerufen…';

  @override
  String get fcRefreshStep2 => 'Druck und Wind werden gelesen…';

  @override
  String get fcRefreshStep3 => 'Mondphase wird geprüft…';

  @override
  String get fcRefreshStep4 => 'Beißfenster werden gesucht…';

  @override
  String get fcRefreshStep5 => 'Index wird neu berechnet…';

  @override
  String fcUpdatedAt(String time) {
    return 'aktualisiert um $time';
  }

  @override
  String get fcUpdatedJustNow => 'gerade aktualisiert';

  @override
  String fcUpdatedMinAgo(int minutes) {
    return 'aktualisiert vor $minutes Min.';
  }

  @override
  String fcUpdatedHoursAgo(int hours) {
    return 'aktualisiert vor $hours Std.';
  }

  @override
  String fcUpdatedDate(String date) {
    return 'aktualisiert $date';
  }

  @override
  String fcOfflineUpdated(String age) {
    return 'offline · $age';
  }

  @override
  String get fcFactorGood => 'gut';

  @override
  String get fcFactorNeutral => 'neutral';

  @override
  String get fcFactorWeak => 'schwach';

  @override
  String get tabSpots => 'Spots';

  @override
  String get spotsActiveTitle => 'Aktiver Spot';

  @override
  String get spotsSavedTitle => 'Gespeicherte Spots';

  @override
  String get spotsUseCurrent => 'Aktuellen Standort verwenden';

  @override
  String get spotsEmpty =>
      'Noch keine gespeicherten Spots.\nFüge einen auf der Karte hinzu.';

  @override
  String get spotsAddOnMap => 'Auf Karte hinzufügen';

  @override
  String get spotPickerTitle => 'Spot wählen';

  @override
  String get spotNameHint => 'Spot-Name (optional)';

  @override
  String get spotSaveBtn => 'Spot speichern';

  @override
  String get spotSaveActive => 'Speichern';

  @override
  String get spotNameDialogTitle => 'Spot-Name';

  @override
  String get spotEdit => 'Bearbeiten';

  @override
  String spotDefaultName(int n) {
    return 'Spot $n';
  }

  @override
  String get spotDeleted => 'Spot gelöscht';

  @override
  String get spotDeleteConfirm => 'Spot löschen?';

  @override
  String get spotSearchHint => 'Ort suchen';

  @override
  String get spotNothingFound => 'Nichts gefunden';

  @override
  String get spotLocationUnavailable =>
      'Standort konnte nicht ermittelt werden';

  @override
  String get fcToday => 'Heute';

  @override
  String get fcTomorrow => 'Morgen';

  @override
  String get fcIndexCaption => 'Beißindex';

  @override
  String get fcBestWindow => 'Bestes Fenster';

  @override
  String get fcBestWindowEmpty => 'Den ganzen Tag schwache Aktivität';

  @override
  String get fcHourlyTitle => 'Stündlich';

  @override
  String get fcWeekTitle => '7-Tage-Ausblick';

  @override
  String get fcUpcomingDays => 'Nächste Tage';

  @override
  String get fcSeeWeek => 'Woche ansehen';

  @override
  String get fcWhyTitle => 'Warum diese Bewertung';

  @override
  String get fcHowItWorksBtn => 'Wie die Prognose funktioniert';

  @override
  String get fcHowItWorksTitle => 'Wie die Prognose funktioniert';

  @override
  String get fcHowItWorksP1Title => 'Ein kluges Modell, kein Münzwurf';

  @override
  String get fcHowItWorksP1Body =>
      'Hinter jeder Bewertung steckt ein Modell, das täglich Dutzende Wetterfaktoren zusammenführt — Luftdruck und seine Schwankungen, Windstärke und -richtung, Luft- und Wassertemperatur, Bewölkung, Niederschlag, Mondphase und Jahreszeit. Wir gewichten jeden und machen daraus eine einzige, klare Beißbewertung.';

  @override
  String get fcHowItWorksP2Title => 'Auf dein Gewässer abgestimmt';

  @override
  String get fcHowItWorksP2Body =>
      'See, Fluss, Teich und Stausee leben nach eigenen Regeln. Der Algorithmus bezieht den Gewässertyp und seine Eigenheiten ein, um zu bestimmen, wo und wann Fische an deinem Spot eher aktiv sind.';

  @override
  String get fcHowItWorksP3Title => 'Beruht auf dem Verhalten der Fische';

  @override
  String get fcHowItWorksP3Body =>
      'Fische reagieren vorhersehbar auf Wetter — sie suchen angenehme Temperatur, Sauerstoff und Futter. Wir bauen diese Muster ein und übersetzen sie in konkrete Tipps: wo du dich hinsetzt, in welcher Tiefe du fischst und welche Stunden du abwartest.';

  @override
  String get fcHowItWorksP4Title => 'Beste Zeit und bester Ort';

  @override
  String get fcHowItWorksP4Body =>
      'Wir berechnen nicht nur heute, sondern auch die nächsten Tage und heben die stärksten Beißfenster hervor — damit du deinen Ansitz auf den vielversprechendsten Tag und die beste Stunde legst, statt zu raten.';

  @override
  String get fcHowItWorksDisclaimer =>
      'Es ist eine Wahrscheinlichkeit, kein Versprechen. Lies am Wasser immer die Lage und experimentiere — Stelle, Köder, Zeit.';

  @override
  String get storyTitle => 'Anatomie des Bisses';

  @override
  String get storySubtitle => 'Warum das kein Kaffeesatzlesen ist';

  @override
  String get storyHookTitle => 'Beißen ist keine Lotterie';

  @override
  String get storyHookBody =>
      'Fische sind wechselwarm: keine „Laune“, nur eine Reaktion auf Wasser und Himmel. Der Druck fällt, das Wasser wird wärmer, der Wind frischt auf — der Appetit ändert sich. Wir haben gelernt, diese Signale zu lesen und zu einer Bewertung zu bündeln. Daraus setzt sie sich zusammen.';

  @override
  String get storyPressureTitle => 'Barometer und Thermometer';

  @override
  String get storyPressureBody =>
      'Ein Fisch hat ein eingebautes Barometer — seine Schwimmblase. Ein scharfer Drucksprung betäubt ihn; ein langsames Fallen vor Schlechtwetter schaltet das Fressen ein. Das alles vor dem Hintergrund der Wassertemperatur, die der Luft nachhinkt — ein kleiner Teich wacht in Tagen auf, ein großer See braucht Wochen — deshalb modellieren wir die Trägheit des Wassers und stimmen sie auf dein Gewässer ab. Kaltes Wasser: träge am Grund. Aufgewärmt: am Fressen.';

  @override
  String get storyWindTitle => 'Wind und Stunde';

  @override
  String get storyWindBody =>
      'Der Wind ist der Freund des Anglers: Er drückt warmes Wasser und Futter ans windabgewandte Ufer und bringt Sauerstoff — dort sammeln sich die Fische. Und jeder hat seine Stunde: Karpfen lieben Dämmerung und warme Nacht, die Karausche den Morgen, während ein heißer Mittag den Biss abwürgt. Der Mond schiebt ein wenig nach. So ändert sich die Bewertung nicht nur von Tag zu Tag, sondern von Stunde zu Stunde.';

  @override
  String get storyTypeTitle => 'Jedes Gewässer hat seinen Charakter';

  @override
  String get storyTypeBody =>
      'See, Fluss, Teich, Kanal und Stausee leben je auf ihre Weise. Auf großem Wasser folgen die Fische dem Wind; im Fluss halten sie sich an Kurven, Gumpen und ruhiges Wasser unterhalb von Schnellen; im kleinen Teich drücken sie sich ans Schilf und an Hindernisse. Wir bestimmen dein Gewässer über die OpenStreetMap-Karte — Typ und Größe — und stimmen darauf sowohl das Erwärmungsmodell des Wassers als auch die Tipps zum Standort ab.';

  @override
  String get storyFishTitle => 'Karpfen ≠ Karausche';

  @override
  String get storyFishBody =>
      'Eine Engine, zwei Charaktere — und man darf sie nicht verwechseln. Der Karpfen ist ein vorsichtiger Feinschmecker: Er liebt warmes Wasser, langsam fallenden Druck vor Schlechtwetter und frisst sogar nachts. Die Karausche ist heikler bei Schwankungen, wacht später auf und wird schnell satt, ist aber unglaublich zäh — eine stickige warme Pfütze, die dem Karpfen zu schaffen macht, passt ihr bestens. Daher bewerten wir jeden nach eigenem Profil: Temperaturschwellen, Druckreaktion, Fresszeiten.';

  @override
  String get storyTacticsTitle => 'Nicht nur wann, sondern wie';

  @override
  String get storyTacticsBody =>
      'Zu wissen, dass es heute beißt, reicht nicht — das Wie zählt. Aus dem realen Wetter des Tages schlagen wir vor: das „Köder-Thermometer“ (kalt — klein und hell: Maden, Mais; warm — gehaltvoller: Boilies, Tigernüsse), welches Rig, wo du sitzt und welche Stunden du abwartest. Bei steigender Wassertemperatur füttern wir großzügig; bei Kälte und großer Hitze sparsam. Alles auf Wasser und Himmel dieses Tages abgestimmt, nicht nach Schema F.';

  @override
  String get storyHonestTitle => 'Wahrscheinlichkeit, kein Versprechen';

  @override
  String get storyHonestBody =>
      'Seien wir ehrlich: Das ist eine Einschätzung der Chancen, kein Fangversprechen. Tiefe, Bodenrelief, Hindernisse und wie viele Fische tatsächlich unter dir stehen — das sieht kein Satellit, und kein Modell weiß es. Die Prognose hilft dir, einen guten Tag, Ort und Zeitpunkt zu wählen — sie nimmt dem Angeln das Lotteriespiel. Der Rest liegt bei dir: probiere Stellen, wechsle Köder und Tiefen, experimentiere. Genau das macht den Reiz aus.';

  @override
  String get fcWhyHelps => 'Hilft';

  @override
  String get fcWhyHurts => 'Bremst';

  @override
  String get fcWhyNoCons => 'keine limitierenden Faktoren';

  @override
  String get fcWhyAnd => 'und';

  @override
  String fcWhyHelpsOne(Object factors) {
    return '$factors begünstigt den Biss.';
  }

  @override
  String fcWhyHelpsMany(Object factors) {
    return '$factors begünstigen den Biss.';
  }

  @override
  String fcWhyHurtsOne(Object factors) {
    return '$factors senkt die Fischaktivität.';
  }

  @override
  String fcWhyHurtsMany(Object factors) {
    return '$factors senken die Fischaktivität.';
  }

  @override
  String get fcWhyBalanced =>
      'Die Faktoren sind ausgeglichen — keine starken Aktivitätsschwankungen zu erwarten.';

  @override
  String get fcPhrasePressurePos =>
      'stabiler Luftdruck hält die Fische am Grund in Fresslaune';

  @override
  String get fcPhrasePressureNeg =>
      'Druckschwankungen bringen die Fische vom Fressen ab';

  @override
  String get fcPhraseTemperaturePos =>
      'das Wasser hat sich auf eine angenehme Fresstemperatur erwärmt';

  @override
  String get fcPhraseTemperatureNeg =>
      'kaltes Wasser bremst die Fische, sie fressen kaum';

  @override
  String get fcPhraseWindPos => 'leichte Wellen treiben das Futter ans Ufer';

  @override
  String get fcPhraseWindNeg =>
      'starker Wind treibt Wellen, die Fische ziehen in die Tiefe';

  @override
  String get fcPhraseCloudPos =>
      'Wolken dämpfen das Licht, die Fische fressen mutiger';

  @override
  String get fcPhraseCloudNeg =>
      'grelle Sonne macht die Fische scheu, sie verstecken sich';

  @override
  String get fcPhrasePrecipPos =>
      'trockenes, beständiges Wetter macht die Fische berechenbar';

  @override
  String get fcPhrasePrecipNeg =>
      'Niederschlag trübt das Wasser und stört den Druck';

  @override
  String get fcPhraseSeasonPos =>
      'saisonaler Höhepunkt — die Fische fressen sich satt';

  @override
  String get fcPhraseSeasonNeg =>
      'saisonale Flaute — der Stoffwechsel der Fische ist verlangsamt';

  @override
  String get fcPhraseMoonPos =>
      'aktive Mondphase — ein solunarer Fresshöhepunkt';

  @override
  String get fcPhraseMoonNeg => 'schwache Mondphase — eine solunare Flaute';

  @override
  String get fcConfidenceHigh => 'Hohe Zuverlässigkeit';

  @override
  String get fcConfidenceMedium => 'Mittlere Zuverlässigkeit';

  @override
  String get fcConfidenceLow => 'Geringe Zuverlässigkeit';

  @override
  String get fcDayConditions => 'Tageswetter';

  @override
  String get fcPeriodNight => 'Nacht';

  @override
  String get fcPeriodMorning => 'Morgen';

  @override
  String get fcPeriodDay => 'Tag';

  @override
  String get fcPeriodEvening => 'Abend';

  @override
  String get fcRateWeak => 'Schwach';

  @override
  String get fcRateMid => 'Mäßig';

  @override
  String get fcRateGood => 'Gut';

  @override
  String get fcRateGreat => 'Top';

  @override
  String get fcPeriodWhyTitle => 'Warum diese Bewertung';

  @override
  String get fcPeriodTimeEffect => 'Tageszeit';

  @override
  String get fcPeriodBaseTitle => 'Grundbedingungen';

  @override
  String get fcPeriodWater => 'Wasser';

  @override
  String get fcTodAdjCaption => 'Tageszeit-Korrektur';

  @override
  String fcTodDawn(String sunrise) {
    return 'Morgendämmerung gegen $sunrise — der tägliche Fresshöhepunkt, daher liegt dieser Zeitraum über dem Tagesniveau.';
  }

  @override
  String fcTodDusk(String sunset) {
    return 'Abenddämmerung gegen $sunset — vor der Dunkelheit fressen die Fische aktiv, daher wird die Bewertung angehoben.';
  }

  @override
  String fcTodWarmNight(String water, String warm) {
    return 'Das Wasser $water liegt auf oder über der Warmnacht-Marke ($warm); die Fische fressen auch nachts weiter — die Nachtbewertung bleibt nahe am Tageswert.';
  }

  @override
  String fcTodMidNight(String water, String cold, String warm) {
    return 'Das Wasser $water liegt zwischen der Kalt-Marke ($cold) und der Warmnacht-Marke ($warm) — nachts wird nur teilweise gefressen, je wärmer das Wasser, desto aktiver die Nacht.';
  }

  @override
  String fcTodColdNight(String water, String cold) {
    return 'Das Wasser $water liegt unter der Kalt-Marke ($cold) — in kaltem Wasser bewegen sich die Fische nachts kaum, daher fällt die Bewertung deutlich unter den Tageswert.';
  }

  @override
  String fcTodMiddayHot(String temp, String heat) {
    return 'Mittags ist es heiß ($temp, über $heat) — die Fische ziehen sich in Schatten und tieferes Wasser zurück, daher lässt der Biss nach.';
  }

  @override
  String fcTodColdDay(String water, String cold) {
    return 'Das Wasser ist kalt ($water, höchstens $cold); die Tageserwärmung macht den Mittag zur relativ besten Zeit.';
  }

  @override
  String get fcTodDayNeutral =>
      'Tagesstunden zwischen den Dämmerungsspitzen — ruhige, durchschnittliche Aktivität.';

  @override
  String get spawnTitle => 'Laichzeit-Fenster';

  @override
  String spawnPreSpawn(String water) {
    return 'Wasser $water und steigend Richtung Laichbereich — sieht nach dem Vorlauf zur Laichzeit aus.';
  }

  @override
  String spawnSpawning(String water) {
    return 'Wasser $water liegt im Laichbereich der Art — sieht nach Laichzeit aus.';
  }

  @override
  String spawnPostSpawn(String water) {
    return 'Wasser $water hat den Laichbereich nach oben verlassen — die Laichzeit scheint vorbei.';
  }

  @override
  String get spawnImpactPreSpawn =>
      'Vor dem Laichen oft ein Fressschub — der Biss läuft meist hoch (≈70–90 von 100). Fische, solange das Fenster offen ist.';

  @override
  String get spawnImpactSpawning =>
      'Der Index oben berücksichtigt das Laichen nicht. Läuft es wirklich, ist der echte Biss weit niedriger — typisch ≈10–20 von 100, für einige Tage.';

  @override
  String get spawnImpactPostSpawn =>
      'Nach dem Laichen folgt meist ein Fressschub — der Biss läuft wieder hoch (≈70–90 von 100).';

  @override
  String get spawnCaveatEstimated =>
      'Das ist die Prognose eines Fensters, kein genaues Datum — das Laichen läuft an jedem Gewässer anders und in Schüben, und das Wasser schätzen wir aus der Luft.';

  @override
  String get spawnCaveatRough =>
      'Eine grobe Prognose: großes, träges Gewässer, das Laichen ist überall anders und das Wasser schätzen wir aus der Luft — der Zeitpunkt kann deutlich schwanken.';

  @override
  String get moonNew => 'Neumond';

  @override
  String get moonWaxing => 'Zunehmend';

  @override
  String get moonFull => 'Vollmond';

  @override
  String get moonWaning => 'Abnehmend';

  @override
  String get fcHowToFish => 'Wie man heute angelt';

  @override
  String get fcHowToFishTomorrow => 'Wie man morgen angelt';

  @override
  String fcHowToFishOn(String date) {
    return 'Wie man am $date angelt';
  }

  @override
  String get fcWhenTitle => 'Wann';

  @override
  String get fcWindowsLabel => 'Beißfenster';

  @override
  String get fcWindowDawn => 'Morgenbiss (Dämmerung)';

  @override
  String get fcWindowDusk => 'Abendbiss (Dämmerung)';

  @override
  String get fcWindowNight => 'Nachtbiss';

  @override
  String get fcWindowMorning => 'Vormittag';

  @override
  String get fcWindowEvening => 'Abend';

  @override
  String get fcWindowDay => 'Mittag';

  @override
  String get fcWindowsWhyDawn =>
      'Karpfen fressen am meisten bei Tagesanbruch und in der Dämmerung.';

  @override
  String get fcWindowsWhyNight =>
      'In warmem Wasser fressen Karpfen nachts aktiv.';

  @override
  String get fcWindowsWhyDay => 'Mildes Tageswetter hält die Fische aktiv.';

  @override
  String get fcVerdictVeryLow =>
      'Harter Tag — der Biss ist träge, vielleicht besser auslassen.';

  @override
  String get fcVerdictLow =>
      'Schwacher Biss. Wenn du gehst — präzise und geduldig fischen.';

  @override
  String get fcVerdictMedium =>
      'Ein durchschnittlicher Tag — keine Garantie, aber eine Chance.';

  @override
  String fcVerdictMediumWindow(String from, String to) {
    return 'Es gibt eine Chance — versuch das Fenster $from–$to.';
  }

  @override
  String get fcVerdictGood => 'Guter Tag — halt einen Köder im Wasser.';

  @override
  String fcVerdictGoodWindow(String from, String to) {
    return 'Lohnt sich. Beste Zeit — $from–$to.';
  }

  @override
  String get fcVerdictExcellent => 'Ausgezeichneter Tag — der Biss läuft!';

  @override
  String fcVerdictExcellentWindow(String from, String to) {
    return 'Ausgezeichneter Tag! Verpass das Fenster $from–$to nicht.';
  }

  @override
  String get fcLevelVeryLow => 'Sehr niedrig';

  @override
  String get fcLevelLow => 'Niedrig';

  @override
  String get fcLevelMedium => 'Mäßig';

  @override
  String get fcLevelGood => 'Gut';

  @override
  String get fcLevelExcellent => 'Ausgezeichnet';

  @override
  String get fcFactorPressure => 'Luftdruck';

  @override
  String get fcFactorTemperature => 'Wassertemp.';

  @override
  String get fcFactorWind => 'Wind';

  @override
  String get fcFactorCloud => 'Bewölkung';

  @override
  String get fcFactorPrecipitation => 'Niederschlag';

  @override
  String get fcFactorSeason => 'Jahreszeit';

  @override
  String get fcFactorMoon => 'Mond';

  @override
  String get fcCondClear => 'Klar';

  @override
  String get fcCondPartly => 'Teils bewölkt';

  @override
  String get fcCondCloudy => 'Bewölkt';

  @override
  String get fcCondRain => 'Regen';

  @override
  String get fcCondStorm => 'Sturm';

  @override
  String get fcChipPressure => 'Druck';

  @override
  String get fcChipWind => 'Wind';

  @override
  String get fcChipWater => 'Wasser';

  @override
  String get fcChipTemp => 'Temperatur';

  @override
  String get fcChipMoon => 'Mond';

  @override
  String get fishCarp => 'Karpfen';

  @override
  String get fishCrucian => 'Karausche';

  @override
  String get fishSheetTitle => 'Fisch';

  @override
  String get fcUnitHpaSuffix => 'hPa';

  @override
  String get fcUnitMmHgSuffix => 'mmHg';

  @override
  String get fcUnitMsSuffix => 'm/s';

  @override
  String get fcUnitKmhSuffix => 'km/h';

  @override
  String get fcWindCalm => 'Windstill';

  @override
  String get fcWindN => 'N';

  @override
  String get fcWindNE => 'NO';

  @override
  String get fcWindE => 'O';

  @override
  String get fcWindSE => 'SO';

  @override
  String get fcWindS => 'S';

  @override
  String get fcWindSW => 'SW';

  @override
  String get fcWindW => 'W';

  @override
  String get fcWindNW => 'NW';

  @override
  String get tabAdvice => 'Taktik';

  @override
  String get adviceHeadline => 'Empfohlene Taktik';

  @override
  String get adviceDisclaimer =>
      'Hinweise nach der Wetterprognose, nicht für ein konkretes Gewässer.';

  @override
  String get adviceKindBait => 'Köder';

  @override
  String get adviceKindFeeding => 'Anfüttern';

  @override
  String get adviceKindDepth => 'Tiefe';

  @override
  String get adviceKindLocation => 'Stelle';

  @override
  String get adviceKindTiming => 'Zeit';

  @override
  String adviceWhyWater(String value) {
    return 'Wasser $value';
  }

  @override
  String get adviceWhyWaterRising => 'Wasser wird Tag für Tag wärmer';

  @override
  String get adviceWhyWaterFalling => 'Wasser kühlt Tag für Tag ab';

  @override
  String adviceWhyAirHot(String value) {
    return 'heiß — Luft $value';
  }

  @override
  String adviceWhyWind(String value) {
    return 'Wind $value';
  }

  @override
  String get adviceWhyWindLight => 'leichter Wind';

  @override
  String get adviceWhyPressureFalling => 'Druck fällt';

  @override
  String get adviceWhyRain => 'Regen tagsüber';

  @override
  String get adviceWhyBottomHabit => 'mildes Wasser — Karpfen stehen grundnah';

  @override
  String get adviceWhyBiteHigh => 'hoher Beißindex';

  @override
  String get adviceWhyBiteMid => 'mäßiger Beißindex';

  @override
  String get adviceWhyBiteLow => 'niedriger Beißindex';

  @override
  String get adviceWhyBestHours => 'Index erreicht jetzt sein Maximum';

  @override
  String get windFullN => 'Norden';

  @override
  String get windFullNE => 'Nordosten';

  @override
  String get windFullE => 'Osten';

  @override
  String get windFullSE => 'Südosten';

  @override
  String get windFullS => 'Süden';

  @override
  String get windFullSW => 'Südwesten';

  @override
  String get windFullW => 'Westen';

  @override
  String get windFullNW => 'Nordwesten';

  @override
  String get adviceBaitColdBrightTitle => 'Helle, kleine Köder';

  @override
  String get adviceBaitColdBrightBody =>
      'Kaltes Wasser — Mais, Maden, kleine Pellets. Der Karpfen frisst wenig und vorsichtig.';

  @override
  String get adviceBaitMidBoiliesTitle => 'Boilies & Pellets';

  @override
  String get adviceBaitMidBoiliesBody =>
      'Das Wasser wird wärmer — 10–16 mm Boilies und Pellets. Der Karpfen ist aktiver.';

  @override
  String get adviceBaitWarmFishmealTitle => 'Fischmehl-Boilies';

  @override
  String get adviceBaitWarmFishmealBody =>
      'Warmes Wasser, Spitzenappetit — gehaltvolle Fischmehl-Boilies, Tigernüsse, Mais.';

  @override
  String get adviceBaitHotSurfaceTitle => 'Schwimmende Köder';

  @override
  String get adviceBaitHotSurfaceBody =>
      'Hitze treibt den Karpfen nach oben — Pop-ups, schwimmende Pellets, etwas Brot.';

  @override
  String get adviceBaitWarmingTitle => 'Größer & aromatischer';

  @override
  String get adviceBaitWarmingBody =>
      'Steigende Temperatur — der Karpfen wird aktiv. Boilies, Tigernüsse, aromatisierte Köder.';

  @override
  String get adviceBaitCoolingTitle => 'Kleiner & greller';

  @override
  String get adviceBaitCoolingBody =>
      'Das Wasser fällt — die Fische werden vorsichtig. Kleine Pellets, Mais, Maden.';

  @override
  String get adviceFeedMinimalTitle => 'Sparsam anfüttern';

  @override
  String get adviceFeedMinimalBody =>
      'Nur ein paar Hände voll, eng platziert — überfüttere inaktive Fische nicht.';

  @override
  String get adviceFeedModerateTitle => 'Mäßig anfüttern';

  @override
  String get adviceFeedModerateBody =>
      'Mittlere Menge; regelmäßig in kleinen Portionen nachlegen.';

  @override
  String get adviceFeedHeavyTitle => 'Reichlich anfüttern';

  @override
  String get adviceFeedHeavyBody =>
      'Der Karpfen frisst kräftig — ein größerer Startplatz und häufiges Nachlegen zahlen sich aus.';

  @override
  String get adviceRigBottomTitle => 'Am Grund fischen';

  @override
  String get adviceRigBottomBody =>
      'Grundmontage am Boden oder an Kanten — die klassische Karpfenmontage.';

  @override
  String get adviceRigZigTitle => 'Zig-Rig probieren';

  @override
  String get adviceRigZigBody =>
      'Die Fische stehen im Mittelwasser — ein Zig 1–2 m über Grund kann punkten.';

  @override
  String get adviceRigSurfaceTitle => 'An der Oberfläche fischen';

  @override
  String get adviceRigSurfaceBody =>
      'Karpfen sonnen sich nahe der Oberfläche — Oberflächenmontage und schwimmender Köder.';

  @override
  String get adviceSwimWindwardTitle => 'Mit dem Wind fischen';

  @override
  String adviceSwimWindwardBody(String dir) {
    return 'Ein Wind aus $dir drückt warmes Oberflächenwasser und Futter ans gegenüberliegende Ufer; dort fressen die Karpfen.';
  }

  @override
  String get adviceSwimCalmFeaturesTitle => 'Strukturen anpeilen';

  @override
  String get adviceSwimCalmFeaturesBody =>
      'Leichter Wind — befische Kanten, Hindernisse, Schilf und Tiefenänderungen.';

  @override
  String get adviceSwimShelteredTitle => 'Tief oder schattig';

  @override
  String get adviceSwimShelteredBody =>
      'Bei Hitze kühleres tiefes Wasser und schattige Bereiche suchen.';

  @override
  String get adviceTimePressureDropTitle => 'Fenster vor der Front';

  @override
  String get adviceTimePressureDropBody =>
      'Der Druck fällt — eine Fressphase ist wahrscheinlich. Verpass die nächsten Stunden nicht.';

  @override
  String get adviceTimeBestWindowTitle => 'Bestes Fenster heute';

  @override
  String adviceTimeBestWindowBody(String from, String to) {
    return 'Spitzenaktivität gegen $from–$to. Sei etwas früher am Platz.';
  }

  @override
  String get adviceTimeDawnDuskTitle => 'Dämmerung morgens & abends';

  @override
  String get adviceTimeDawnDuskBody =>
      'Setz auf den frühen Morgen und späten Abend — der zuverlässigste Biss.';

  @override
  String get adviceTimeAllDayTitle => 'Den ganzen Tag aktiv';

  @override
  String get adviceTimeAllDayBody =>
      'Hoher Index — Karpfen fressen über den Tag; halt einen Köder im Wasser.';

  @override
  String get adviceTimeSlowPatientTitle => 'Geduldig sein';

  @override
  String get adviceTimeSlowPatientBody =>
      'Die Fische sind träge — präzise Präsentation, feinere Rigs, auf ein Fenster warten.';

  @override
  String get crucianBaitColdAnimalTitle => 'Tierischer Köder';

  @override
  String get crucianBaitColdAnimalBody =>
      'Kaltes Wasser — kleine rote Mückenlarven und Maden. Ein, zwei Larven pro Wurf; die Karausche frisst langsam.';

  @override
  String get crucianBaitWarmingTitle => 'Wurm & Made';

  @override
  String get crucianBaitWarmingBody =>
      'Das Wasser wird wärmer — die Karausche wird aktiv. Dendrobena-Wurm, ein Bündel Maden, Mückenlarven.';

  @override
  String get crucianBaitCoolingTitle => 'Kleiner & weicher';

  @override
  String get crucianBaitCoolingBody =>
      'Abkühlung — die Karausche wird heikel. Kleine Mückenlarven oder ein Sandwich, weicherer Köder.';

  @override
  String get crucianBaitSandwichTitle => 'Sandwich-Köder';

  @override
  String get crucianBaitSandwichBody =>
      'Übergangswasser — ein Sandwich: Made mit Graupen oder Mais. Die Karausche ist wählerisch.';

  @override
  String get crucianBaitWarmPlantTitle => 'Pflanzlicher Köder';

  @override
  String get crucianBaitWarmPlantBody =>
      'Warmes Wasser — Graupen, Grießteig, Mais, Teig. Die Karausche wechselt auf Pflanzenköder.';

  @override
  String get crucianBaitHotDoughTitle => 'Weicher Teig';

  @override
  String get crucianBaitHotDoughBody =>
      'Hitze — weicher Teig, Grießteig, Brotkrume. Ein leichter süßer Köder im oberen Wasser.';

  @override
  String get crucianFeedTinyTitle => 'Eng anfüttern';

  @override
  String get crucianFeedTinyBody =>
      'Die Karausche ist scheu und schnell satt — ein paar Prisen feines süßes Anfutter, nicht mehr.';

  @override
  String get crucianFeedSweetTitle => 'Süßes Anfutter';

  @override
  String get crucianFeedSweetBody =>
      'Feine Mischung mit Knoblauch- oder Vanillearoma; wenig und oft nachlegen, nicht überfüttern.';

  @override
  String get crucianFeedActiveTitle => 'Aktiv anfüttern';

  @override
  String get crucianFeedActiveBody =>
      'Die Karausche frisst gut — öfter, aber in kleinen Mengen nachlegen, um den Schwarm zu halten.';

  @override
  String get crucianRigFloatBottomTitle => 'Pose am Grund';

  @override
  String get crucianRigFloatBottomBody =>
      'Die klassische Karauschenmontage — Posenmontage, Köder liegt am Grund oder berührt ihn leicht.';

  @override
  String get crucianRigDropperTitle => 'Tropfblei & Absinken';

  @override
  String get crucianRigDropperBody =>
      'Die Karausche steht im Mittelwasser — langsam sinkender Köder, Bleie verteilen, beim Absinken fischen.';

  @override
  String get crucianRigShallowTitle => 'Flach nahe der Oberfläche';

  @override
  String get crucianRigShallowBody =>
      'Bei Hitze sonnt sich die Karausche im Flachen — leichte Montage, Köder in der warmen oberen Schicht.';

  @override
  String get crucianSwimReedsTitle => 'Schilfkante';

  @override
  String get crucianSwimReedsBody =>
      'Befische Lücken im Kraut, Schilfkanten und verkrautete Stellen — dort frisst die Karausche.';

  @override
  String get crucianSwimWarmShallowsTitle => 'Warmes Flachwasser';

  @override
  String get crucianSwimWarmShallowsBody =>
      'Das Wasser ist kalt — suche die wärmsten Flachzonen und sonnenbeschienenen Buchten.';

  @override
  String get crucianSwimDeepEdgeTitle => 'Tiefere Kante & Schatten';

  @override
  String get crucianSwimDeepEdgeBody =>
      'Bei Hitze verlässt die Karausche das Flache — befische Gumpen, Kanten und schattige Bereiche.';

  @override
  String get crucianTimePressureDropTitle => 'Geduldig sein';

  @override
  String get crucianTimePressureDropBody =>
      'Der Druck fällt — die Karausche wird heikel und passiv. Kleine weiche Köder, auf kurze Phasen warten.';

  @override
  String get crucianTimeBestWindowTitle => 'Bestes Fenster heute';

  @override
  String crucianTimeBestWindowBody(String from, String to) {
    return 'Spitzenaktivität gegen $from–$to. Sei etwas früher am Platz.';
  }

  @override
  String get crucianTimeMorningTitle => 'Morgenbiss';

  @override
  String get crucianTimeMorningBody =>
      'Setz auf den frühen Morgen — die klassische Karauschenphase, vor der Hitze.';

  @override
  String get crucianTimeStableWarmTitle => 'Auch tagsüber aktiv';

  @override
  String get crucianTimeStableWarmBody =>
      'Stabile Wärme — die Karausche frisst über den Tag; halt einen Köder im Wasser.';

  @override
  String get crucianTimePatientTitle => 'Eng & geduldig';

  @override
  String get crucianTimePatientBody =>
      'Die Karausche ist passiv — feine Montage, kleiner Köder, eine Stelle befischen und auf eine Phase warten.';

  @override
  String get spotTitle => 'Dein Spot';

  @override
  String get spotNoWater =>
      'Kein Gewässer in der Nähe dieses Punkts auf der Karte. Die Wettervorhersage funktioniert trotzdem — setze einen Spot, um das Gewässer zu lesen.';

  @override
  String get spotSetOnMap => 'Spot auf Karte setzen';

  @override
  String get spotCheckFailed =>
      'Karte konnte gerade nicht geprüft werden — die Wettervorhersage funktioniert weiterhin.';

  @override
  String get spotTypeLake => 'See';

  @override
  String get spotTypePond => 'Teich';

  @override
  String get spotTypeReservoir => 'Stausee';

  @override
  String get spotTypeRiver => 'Fluss';

  @override
  String get spotTypeCanal => 'Kanal';

  @override
  String get spotTypeWater => 'Gewässer';

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
    return 'Warmer Wind treibt Futter und wärmeres Wasser ans windabgewandte Ufer — dort sind die Fische wahrscheinlich aktiver. Aktives Ufer: $bank.';
  }

  @override
  String spotTipSheltered(String bank) {
    return 'Der Wind ist kälter als das Wasser — die Fische ziehen vom windigen Ufer ins ruhige Wasser. Geschütztes Ufer: $bank.';
  }

  @override
  String get spotTipNoWind =>
      'Kaum Wind — heute sticht kein Ufer heraus; die Fische verteilen sich über Strukturen und Tiefen.';

  @override
  String get spotTipColdWater =>
      'Kaltes Wasser — die Fische stehen tief und träge am Grund; Wind bewegt sie kaum.';

  @override
  String get spotWhereRiver =>
      'Suche ruhiges Wasser: Gumpen, Außenkurven, unterhalb von Schnellen, an Hindernissen und Brückenpfeilern.';

  @override
  String get spotWhereCanal =>
      'Ein Kanal ist gleichförmig — suche Auffälligkeiten: Kurven, Brücken, Zuflüsse und verkrautete Ufer.';

  @override
  String get spotWherePondSmall =>
      'Ein kleines Gewässer erwärmt sich schnell — Fische stehen an Schilf, Hindernissen und am Ufersaum, bei Hitze tiefer.';

  @override
  String get spotWhereMid =>
      'Ein mittelgroßes Gewässer — befische Buchten, Kanten und verkrautete Bereiche.';

  @override
  String get spotWhereLarge =>
      'Ein großes Gewässer — die Fische ziehen; achte auf Landzungen, Kanten und folge dem Wind.';

  @override
  String get spotWhereUnknown =>
      'Stillwasser — achte auf Schilf, Hindernisse, Kanten und Buchten.';

  @override
  String get spotStructInflow =>
      'In der Nähe mündet ein Bach oder Kanal — die Strömung bringt Futter und Sauerstoff; eine Top-Stelle, besonders bei Hitze.';

  @override
  String get spotStructReeds =>
      'Hier säumen Schilf oder Sumpf das Ufer — Deckung und Futterbank für Karpfen.';

  @override
  String get spotStructDam =>
      'Ein Damm oder Deich ist nah — ein scharfer Tiefenwechsel und eine klassische Standstelle.';

  @override
  String spotStructIslands(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Auf diesem Gewässer gibt es mehrere Inseln — Fische stehen oft an ihnen: Struktur, Tiefenwechsel und Deckung.',
      one:
          'Auf diesem Gewässer gibt es eine Insel — Fische stehen oft an Inseln: Struktur, Tiefenwechsel und Deckung.',
    );
    return '$_temp0';
  }

  @override
  String get spotSourceType => 'für diesen Gewässertyp';

  @override
  String get spotEditTitle => 'Position der Stelle';

  @override
  String get spotEditHint =>
      'Karte verschieben, um die Markierung zu setzen — bei Bedarf ans bessere Ufer.';

  @override
  String get spotSavePosition => 'Position speichern';

  @override
  String get spotViewOnMap => 'Auf der Karte ansehen';

  @override
  String get spotWindLabel => 'Wind';

  @override
  String spotWindFrom(String dir) {
    return 'Wind $dir';
  }

  @override
  String get spotDirN => 'aus Norden';

  @override
  String get spotDirNE => 'aus Nordosten';

  @override
  String get spotDirE => 'aus Osten';

  @override
  String get spotDirSE => 'aus Südosten';

  @override
  String get spotDirS => 'aus Süden';

  @override
  String get spotDirSW => 'aus Südwesten';

  @override
  String get spotDirW => 'aus Westen';

  @override
  String get spotDirNW => 'aus Nordwesten';

  @override
  String get spotUserHere =>
      'Dein Spot liegt bereits am aktiven Ufer — du bist am richtigen Platz.';

  @override
  String get spotUserOpposite =>
      'Dein Spot liegt auf der anderen Seite — am gegenüberliegenden Ufer könnte es besser laufen.';

  @override
  String get spotSourceMap => 'Nach OpenStreetMap-Daten';

  @override
  String get spotSourceWind => 'nach Wind und Wassertemperatur';

  @override
  String get spotDisclaimer =>
      'Eine Einschätzung der Lage aus Karte und Wetter — Tiefe, Grund und Fischbestand sehen wir nicht.';

  @override
  String get settingsAlertsPrimeTitle => 'Bester Tag der Woche';

  @override
  String get settingsAlertsPrimeSubtitle =>
      'Ein Hinweis auf den beißfreudigsten Tag der Woche an deinen Spots';

  @override
  String get settingsAlertsExcellentTitle => 'Alle Top-Tage';

  @override
  String get settingsAlertsExcellentSubtitle =>
      'Ein Hinweis am Vorabend jedes Tages mit Top-Beißverhalten';

  @override
  String get settingsAlertsForCarp => 'Karpfen-Benachrichtigungen';

  @override
  String get settingsAlertsForCrucian => 'Karausche-Benachrichtigungen';

  @override
  String alertTitlePrime(String fish) {
    return '$fish: bester Tag der Woche';
  }

  @override
  String alertTitleExcellent(String fish) {
    return '$fish: morgen top Beißverhalten';
  }

  @override
  String get alertWindowDawn => 'morgen in der Morgendämmerung';

  @override
  String get alertWindowDusk => 'morgen in der Abenddämmerung';

  @override
  String get alertWindowDay => 'morgen tagsüber';

  @override
  String get alertWindowNight => 'morgen nachts';

  @override
  String get alertWindowAny => 'morgen';

  @override
  String get alertSpotFallback => 'Dein Spot';

  @override
  String get tabTips => 'Tipps';

  @override
  String get tipsNext => 'Noch ein Tipp';

  @override
  String get tipLocationFirstTitle => 'Der Platz zählt mehr als der Köder';

  @override
  String get tipLocationFirstBody =>
      'Der häufigste Anfängerfehler: ankommen und „ins Nichts“ auswerfen. Erfahrene Karpfenangler sind sich einig — zu wissen, WO die Fische stehen, ist wichtiger als WOMIT man fischt; am falschen Platz hilft kein Köder. Eine Stunde, um fressende Fische zu finden (Sprünge, Blasenketten, Fische nahe der Oberfläche), bringt mehr als zehn Stunden blind hinter den Bissanzeigern. Beobachte das Wasser erst 15–20 Minuten, dann baue auf.';

  @override
  String get tipLocationFirstProof =>
      'Die Karpfenpresse nennt das Lesen des Wassers den größten Vorteil: „am falschen Platz fängst du nicht, Punkt.“';

  @override
  String get tipMarginsTitle =>
      'Fische die Uferzone — der unterschätzteste Trick';

  @override
  String get tipMarginsBody =>
      'Die meisten werfen so weit wie möglich und ignorieren das Wasser vor den Füßen. Dabei patrouilliert der Karpfen die Uferkante jeden Tag und jede Nacht — an jedem Gewässer. Ein bekannter Fall: Wer am Ufer fischte, fing doppelt so viel wie die, die in die Mitte warfen. Bonus — man sieht den Fisch, kann einem einzelnen Tier den Köder anbieten und aus seinem Verhalten lernen. Nähere dich dem Ufer leise.';

  @override
  String get tipMarginsProof =>
      'Guides zählen das Fischen in der Kante zu den am meisten unterschätzten Karpfentaktiken.';

  @override
  String get tipSharpHooksTitle =>
      'Ein stumpfer Haken ist ein verlorener Fisch';

  @override
  String get tipSharpHooksBody =>
      'Das übersehen Anfänger am häufigsten. Der Unterschied zwischen scharf und nadelscharf ist enorm: mehr Anfasser werden zu Bissen, mehr Bisse zu sicheren Haken. Haken stumpfen nicht nur an Steinen und Muscheln ab, sondern schon beim bloßen Liegen am Grund. Prüfe die Spitze vor JEDEM Wurf (Fingernagel-Test) und wechsle sie beim kleinsten Abstumpfen.';

  @override
  String get tipSharpHooksProof =>
      'Experten sind sich einig: Schärfe senkt Aussteiger deutlich und erhöht die Hakquote.';

  @override
  String get tipDontOverfeedTitle => 'Füttere den Platz nicht über';

  @override
  String get tipDontOverfeedBody =>
      'Der zweite klassische Fehler. Zu viel Futter verteilt die Fische über eine große Fläche und zieht sie vom Rig weg, und ein satter Karpfen ignoriert deinen Hakenköder. Besser wenig, aber genau — kleine Mengen auf einen Punkt. Überfüttern ist eine häufige Ursache für einen Schneidertag, obwohl die Fische da sind.';

  @override
  String get tipDontOverfeedProof =>
      '„Überfüttern“ steht ganz oben in den Listen typischer Karpfenfehler.';

  @override
  String get tipBaitRegularlyTitle =>
      'Regelmäßiges Anfüttern schlägt große Mengen';

  @override
  String get tipBaitRegularlyBody =>
      'Wenn möglich, füttere deinen Platz vorab und oft an. Ein Kilo täglich wirkt besser als fünf Kilo alle fünf Tage. Beständigkeit bringt Karpfen dazu, ohne Scheu für eine Gratismahlzeit zurückzukehren — und wenn du endlich fischst, sind die Bisse entschlossen. Bleib in der Kampagne bei einem Köder: Die Fische lernen, danach zu suchen, und fixieren sich oft darauf.';

  @override
  String get tipBaitRegularlyProof =>
      'Köderfirmen und Anfütter-Guides sind einig: Der Schlüssel ist Regelmäßigkeit, weniger, aber öfter.';

  @override
  String get tipHairRigTitle => 'Das Haar-Rig — warum es fängt';

  @override
  String get tipHairRigBody =>
      'Karpfen schlucken nicht sofort: Sie testen den Köder, saugen ihn ein und blasen ihn aus. Am Haken selbst spüren sie das Metall und stoßen ihn mit dem Köder wieder aus. Am „Haar“ liegt der Köder getrennt vom blanken Haken: beim Einsaugen gleitet der Haken frei ins Maul und fasst die Unterlippe. Seit den 1980ern hat dieses Prinzip die Hakquote revolutioniert und ist zum Rückgrat des modernen Karpfenangelns geworden.';

  @override
  String get tipHairRigProof =>
      'Jahrzehntelang bewährter Klassiker; das Saug-und-Test-Prinzip ist die Basis jedes modernen Rigs.';

  @override
  String get tipSweetcornTitle => 'Mais — billig und tödlich';

  @override
  String get tipSweetcornBody =>
      'Süßmais fängt weltweit Karpfen: leuchtend, süß, weich und reich an Aminosäuren — der Karpfen nimmt ihn als natürliche Nahrung an. Und er kostet fast nichts: dasselbe Gewicht an Boilies ist um ein Vielfaches teurer. Besonders dort, wo Karpfen vor allem Naturnahrung fressen, wirkt er oft sofort.';

  @override
  String get tipSweetcornProof =>
      'Mais gilt als einer der günstigsten und wirksamsten Köder; der Preisunterschied zu Boilies ist um ein Vielfaches.';

  @override
  String get tipMixedSizesTitle => 'Misch die Ködergrößen';

  @override
  String get tipMixedSizesBody =>
      'Misch die Boilie-Größen (etwa 12–15 mm und 18–22 mm), damit sich Karpfen nicht auf ein Kaliber einstellen und vorsichtig werden — die Chance, dass sie den Hakenköder nehmen, steigt. Klein (12–15 mm) für Winter und beangelte Gewässer, groß (18–22 mm) gegen Kleinfisch und für Großkarpfen.';

  @override
  String get tipMixedSizesProof =>
      '„Gemischte Größen“ ist ein Standardtrick, um die Größen-Selektivität der Fische zu brechen.';

  @override
  String get tipFallingPressureTitle =>
      'Fallender Luftdruck — ein Fressfenster';

  @override
  String get tipFallingPressureBody =>
      'Wenn eine Front naht und der Druck fällt, fressen Fische oft kräftiger. Karpfen reagieren milder als Raubfische (Grundbewohner, weniger empfindlich), doch Angler beobachten: bei niedrigem Druck fressen sie länger und williger. Das beste Fenster liegt 6–12 Stunden vor der Front. Wichtig: Es gibt keine magische Druckzahl — es wirkt der fallende TREND, nicht ein Messwert.';

  @override
  String get tipFallingPressureProof =>
      'Zeitschriften-Beobachtungen verzeichneten bis zu ~40% mehr Fressaktivität bei fallendem Druck; die meistzitierte Studie (1983, Barsch) fand aber nur eine schwache Korrelation — daher ehrlicher: ein Trend, keine Garantie.';

  @override
  String get tipCrucianShyBitesTitle =>
      'Karauschen sind scheue Koster — tauche die Pose ab';

  @override
  String get tipCrucianShyBitesBody =>
      'Ein Karauschenbiss kann kaum sichtbar sein — ein Viertel-Eintauchen einer feinen Antenne. Schaut zu viel Antenne heraus, übersiehst du die zarten Zupfer. Beschwere die Pose so weit ab, dass nur ein Minimum herausragt. Karauschen spucken den Köder aus, sobald sie Widerstand spüren — alles muss leicht und feinfühlig sein.';

  @override
  String get tipCrucianShyBitesProof =>
      'Karauschen-Guides sind einig: Pose abtauchen; eine feine Antenne registriert scheue Bisse.';

  @override
  String get tipCrucianFineTackleTitle => 'Karauschen: fein und klein';

  @override
  String get tipCrucianFineTackleBody =>
      'Dicke Schnur und große Haken sind tabu. Nimm einen feinen, aber starken Haken in kleiner Größe: 18–20 für Made/Caster, 16 für Mais/Pellet. Nicht überfüttern (Schleien und Brassen rücken ein): Beginne mit golfballgroßen Futterballen und ein paar Köderproben, und lege nur nach, wenn du gut fängst.';

  @override
  String get tipCrucianFineTackleProof =>
      'Standardrat für Karauschen — feines Gerät, kleiner Haken, dosiertes Füttern.';

  @override
  String get tipCrucianSlowFallTitle => 'Karauschen nehmen den fallenden Köder';

  @override
  String get tipCrucianSlowFallBody =>
      'Oft beißen sie, während der Köder langsam absinkt. Verteile kleine Schrote gleichmäßig für einen langsamen Fall, und setze das letzte winzige Anzeige-Schrot nur 5–7 cm vom Haken — es zeigt einen scheuen Biss schnell an.';

  @override
  String get tipCrucianSlowFallProof =>
      'Langsamer Fall plus ein Anzeige-Schrot nahe am Haken ist eine typische Karauschentaktik.';

  @override
  String get tipWaterTempTitle => 'Das Wasser zählt mehr als der Kalender';

  @override
  String get tipWaterTempBody =>
      'Karpfen sind wechselwarm — der Appetit folgt der WASSERtemperatur, nicht dem Datum. Höchste Aktivität bei etwa 18–24 °C; unter ~10 °C verlangsamt sich der Stoffwechsel und das Fressen hört fast auf. In der Praxis: bei kaltem Wasser klein ködern und in der Mittagswärme im Flachen fischen; bei Hitze nachts und in der Dämmerung. Erwarte kein Fressen bei eisigem Wasser am Mittag.';

  @override
  String get tipWaterTempProof =>
      'Biologie der Karpfenfische: Der Stoffwechsel hängt direkt von der Wassertemperatur ab — daher bricht der Biss im Winter stark ein.';

  @override
  String get tipPvaBagTitle => 'PVA-Beutel — eine Portion direkt am Haken';

  @override
  String get tipPvaBagBody =>
      'Ein wasserlöslicher PVA-Beutel mit Pellet oder Krümel am Haken legt ein sauberes Futterhäufchen genau dort ab, wo dein Köder landet. Er löst sich in Minuten auf, hinterlässt einen attraktiven Fleck und eine verwicklungsfreie Präsentation beim Wurf. Top auf Schlamm und im Kraut, wo ein einzelner Köder untergeht — der Karpfen findet einen „Tisch“ und frisst direkt über dem Rig.';

  @override
  String get tipPvaBagProof =>
      'PVA-Zubehör ist im modernen Karpfenangeln Standard, um Futter genau am Haken zu platzieren.';

  @override
  String get tipFeatureFindingTitle =>
      'Finde die Strukturen — Karpfen patrouillieren die Kanten';

  @override
  String get tipFeatureFindingBody =>
      'Fische sind nicht gleichmäßig verteilt — sie stehen an Strukturen: Kanten, Tiefenänderungen, hartem Grund im Schlamm, Krautkanten, Hindernissen. Vor dem Angeln den Grund mit einem Blei „erfühlen“: schleifen und spüren, wie sich der Boden ändert, die Tiefe am Absinken zählen. Ein Wurf auf eine gefundene Kante schlägt den Zufallswurf „auf Weite“.';

  @override
  String get tipFeatureFindingProof =>
      'Strukturen mit Marker oder Blei auszuloten ist eine Grundfertigkeit — Karpfen patrouillieren Strukturen, nicht die offene Leere.';

  @override
  String get tipStayQuietTitle => 'Sei leise am Ufer — Karpfen sind scheu';

  @override
  String get tipStayQuietBody =>
      'Karpfen spüren Schwingungen über die Seitenlinie und „hören“ mit dem Körper. Schwere Schritte, zugeschlagene Türen, Klopfen am Boot, ein schwerer Wurf vor die Füße — und die Fische verlassen das Flache und die Uferzone. Nähere dich dem Wasser leise, halte Licht von der Oberfläche fern, baue sanft auf. Am wichtigsten beim Angeln an der Kante und im Flachen.';

  @override
  String get tipStayQuietProof =>
      'Die Seitenlinie des Karpfens nimmt kleinste Bewegungen wahr — lauter Lärm macht die Fische tatsächlich wachsam.';

  @override
  String get tipParticlesTitle => 'Partikel (Hanf) halten den Schwarm';

  @override
  String get tipParticlesBody =>
      'Kleines Futter wie Hanf erzeugt einen Fleck, an dem Karpfen wühlen und an einer Stelle fressen, ohne schnell satt zu werden — die Fische bleiben über dem Rig. Sicherheitshinweis: Trockene Partikel (besonders Tigernüsse und Bohnen) müssen vor Gebrauch eingeweicht UND gar gekocht werden — ungar können sie dem Fisch schaden.';

  @override
  String get tipParticlesProof =>
      'Hanf ist ein Klassiker, um einen Schwarm zu halten; Partikel richtig vorzubereiten ist eine bekannte Fisch-Sicherheitsregel.';

  @override
  String get tipFishCareTitle => 'Schone den Fisch — er beißt wieder';

  @override
  String get tipFishCareBody =>
      'Ein großer Karpfen wächst über Jahrzehnte und kann erneut gefangen werden — wenn er gesund zurückgesetzt wird. Nasse Hände und eine nasse Matte oder Gras, minimale Zeit außerhalb des Wassers, lege den Fisch nie auf trockenen Sand oder Steine, hake schonend ab (noch ein Grund für einen scharfen Haken). Fotos tief über der Matte, schnell. Ein gesund zurückgesetzter Karpfen ist ein künftiger Biss — für dich und andere.';

  @override
  String get tipFishCareProof =>
      'Catch-and-Release-Grundsätze unter Karpfenanglern: schonende Behandlung erhält den Bestand und deine künftigen Fänge.';

  @override
  String get tipCrucianWarmShallowsTitle =>
      'Karauschen lieben das warme Flachwasser';

  @override
  String get tipCrucianWarmShallowsBody =>
      'Karauschen lieben Wärme und Kraut. Im Frühjahr und Frühsommer kommen sie zuerst im erwärmten Flachwasser zum Fressen — kleine Buchten, an Schilf und Seerosen, wo das Wasser ein paar Grad wärmer ist. Suche ruhige, krautige, gut erwärmte Stellen; in der Tiefe gibt es zu dieser Zeit kaum Karauschen. Je wärmer das Wasser, desto aktiver die Karausche.';

  @override
  String get tipCrucianWarmShallowsProof =>
      'Die Karausche ist ein wärmeliebender Krautfisch; die frühe Erwärmung des Flachwassers erklärt, warum sie dort zuerst frisst.';

  @override
  String get fcAlgoFactsTitle => 'Wissenswertes zum Algorithmus';

  @override
  String get fcAlgoFactLabel => 'Fakt des Tages';

  @override
  String get algoFactWaterModelTitle =>
      'Wir rechnen mit dem Wasser, nicht mit der Luft';

  @override
  String get algoFactWaterModelBody =>
      'Karpfen leben im Wasser, und das erwärmt sich verzögert. Statt die Lufttemperatur direkt zu nehmen, modellieren wir die Wassertemperatur über eine Wärmeaustausch-Gleichung — wie eine abkühlende Tasse Tee.';

  @override
  String get algoFactThermalInertiaTitle =>
      'Jedes Gewässer hat seine eigene Wärmeträgheit';

  @override
  String get algoFactThermalInertiaBody =>
      'Ein Fluss reagiert in ein paar Tagen aufs Wetter, ein Teich langsamer, ein großer Stausee schwingt erst über Wochen. Deshalb passen wir die Erwärmungsgeschwindigkeit an Typ und Größe des Gewässers an.';

  @override
  String get algoFactPressureTrendTitle =>
      'Entscheidend ist der Drucktrend, nicht der Pegel';

  @override
  String get algoFactPressureTrendBody =>
      'Der beste Biss kommt nicht bei einem ‚guten‘ Druck, sondern bei einem sanften Fallen vor einer Front. Ein scharfer Absturz und ein scharfer Sprung werden beide bestraft. Wir lesen den Trend über 6 und über 24 Stunden.';

  @override
  String get algoFactFrontMemoryTitle =>
      'Wir erinnern uns einen Tag an eine durchgezogene Front';

  @override
  String get algoFactFrontMemoryBody =>
      'Selbst wenn sich der Druck erholt hat, stehen die Fische nach einer Kaltfront noch unter Schock. Wir halten einen eigenen Abzug einen ganzen Tag — Karpfen brauchen ein bis zwei Tage.';

  @override
  String get algoFactWeakestLinkTitle => 'Das Prinzip des schwächsten Glieds';

  @override
  String get algoFactWeakestLinkBody =>
      'Viele Rechner addieren nur Punkte, sodass guter Druck eiskaltes Wasser ‚rettet‘. Bei uns wirken Temperatur, Saison und Druck wie Sicherungen: kein perfekter Wind rettet totes Wasser.';

  @override
  String get algoFactHeatCalmTitle => 'Ein Abzug für Hitze plus Flaute';

  @override
  String get algoFactHeatCalmBody =>
      'Der Abzug greift nur, wenn Hitze und Flaute zusammentreffen — dann wird der Sauerstoff im Wasser knapp. Für sich allein sind ein heißer Tag oder Windstille weniger schädlich.';

  @override
  String get algoFactRealSunTitle => 'Beißzeiten an der echten Sonne';

  @override
  String get algoFactRealSunBody =>
      'Kein festes ‚Biss um 6 Uhr‘. Wir nehmen den tatsächlichen Sonnenauf- und -untergang für deinen Spot, verstärken Morgen- und Abenddämmerung und dämpfen die heiße Mittagszeit.';

  @override
  String get algoFactSpawnPhysicsTitle =>
      'Laichzeit aus Physik, nicht aus dem Kalender';

  @override
  String get algoFactSpawnPhysicsBody =>
      'Die Laichphase berechnen wir aus Wassertemperatur und Tageslänge auf deinem Breitengrad. Und wir sind ehrlich zur Sicherheit: an einem trägen Gewässer ist das Signal unscharf.';

  @override
  String get algoFactSpeciesModelsTitle =>
      'Karpfen und Karausche sind zwei Modelle';

  @override
  String get algoFactSpeciesModelsBody =>
      'Es ist keine Formel mit einem Häkchen. Karauschen haben ein höheres Temperaturoptimum, reagieren empfindlicher auf Druck, mögen leichtes Kräuseln und beißen nachts kaum — Dutzende Parameter sind je Art abgestimmt.';

  @override
  String get algoFactBiteWindowsTitle => 'Beißfenster statt bloßer Stunden';

  @override
  String get algoFactBiteWindowsBody =>
      'Wir fassen die guten Stunden zu durchgehenden Fenstern zusammen, überbrücken einzelne Einbrüche und fügen Fenster, die über Mitternacht reichen, korrekt zusammen.';

  @override
  String alertBody(String spot, String when, int index) {
    return '$spot: $when, Beiß-Index $index';
  }
}
