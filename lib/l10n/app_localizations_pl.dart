// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Polish (`pl`).
class AppLocalizationsPl extends AppLocalizations {
  AppLocalizationsPl([String locale = 'pl']) : super(locale);

  @override
  String get welcomeTitle => 'Planuj pod branie, nie pod weekend';

  @override
  String get welcomeSubtitle =>
      'Znajdziemy najlepsze okno na karpia i karasia na podstawie realnych warunków, a nie zgadywania';

  @override
  String get welcomeCta => 'Zaczynamy';

  @override
  String get languageSheetTitle => 'Język';

  @override
  String get languageSheetSubtitle => 'Wybierz swój język';

  @override
  String get themeSheetSubtitle => 'Wybierz wygląd aplikacji';

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
  String get languagePl => 'Polski';

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
  String get langShortPl => 'PL';

  @override
  String get commonContinue => 'Dalej';

  @override
  String get gateProTitle => 'Dostępne w Pro';

  @override
  String get quizQ1Question => 'Na co łowisz?';

  @override
  String get quizQ1Subtitle => 'Dopasujemy prognozę do Twojej ryby';

  @override
  String get quizQ1OptLearn => 'Karp';

  @override
  String get quizQ1OptHabit => 'Karaś';

  @override
  String get quizQ1OptSolve => 'Obie';

  @override
  String get quizQ2Question => 'Zdarza się wyjazd bez brania?';

  @override
  String get quizQ2Subtitle => 'Bądź szczery — to pomoże nam pomóc Tobie';

  @override
  String get quizQ2OptDaily => 'Tak, nieraz';

  @override
  String get quizQ2OptWeekly => 'Czasami';

  @override
  String get quizQ2OptRarely => 'Rzadko — zwykle biorę';

  @override
  String get quizQ3Question => 'Jak planujesz wyprawy?';

  @override
  String get quizQ3Subtitle => 'Decyduje o tym, co pokażemy Ci najpierw';

  @override
  String get quizQ3OptSimple => 'Planuję z wyprzedzeniem';

  @override
  String get quizQ3OptResult => 'Jadę spontanicznie';

  @override
  String get quizQ3OptFlexible => 'Różnie';

  @override
  String get quizQ4Question => 'Jak często łowisz?';

  @override
  String get quizQ4Subtitle => 'Powiadomimy Cię o najlepszych dniach';

  @override
  String get quizQ4OptWeekly => 'Co tydzień';

  @override
  String get quizQ4OptMonthly => 'Parę razy w miesiącu';

  @override
  String get quizQ4OptRarely => 'Od czasu do czasu';

  @override
  String get onbAnalyzingTitle => 'Analizujemy warunki';

  @override
  String get onbAnalyzingSubtitle => 'Przeliczamy pogodę, ciśnienie i księżyc…';

  @override
  String get onbResultTitle => 'Twoja prognoza brań jest gotowa';

  @override
  String get onbResultSubtitle =>
      'Dzisiejsze branie jest darmowe. Prognoza na 7 dni odblokowuje się z subskrypcją.';

  @override
  String get onbResultTodayBadge => 'Dziś · za darmo';

  @override
  String get onbResultLockedLabel => 'Prognoza na 7 dni';

  @override
  String get onbResultCta => 'Pokaż moją prognozę';

  @override
  String get paywallSkipToday => 'Najpierw zobacz dziś za darmo';

  @override
  String get winbackTitle => '1 dzień Pro na nasz koszt';

  @override
  String get winbackBody =>
      'Odblokuj wszystko na 24 godziny: prognozę brań, najlepsze okna i taktykę pod Twoje łowisko. Bez płatności — po prostu wypróbuj.';

  @override
  String get winbackCtaClaim => 'Odbierz 1 dzień';

  @override
  String get winbackCtaSkip => 'Kontynuuj bez Pro';

  @override
  String get paywallTitle =>
      'Otwórz pełną analizę połowu dla Twojego łowiska na nadchodzący tydzień';

  @override
  String get paywallSaveBadge => 'Oszczędź 85%';

  @override
  String get unlockTitle => 'Odblokuj wszystkie funkcje Pro';

  @override
  String get unlockBody =>
      'Dziesiątki reguł połowu karpia i karasia — ciśnienie, temperatura wody, wiatr, księżyc, pora roku i pora dnia w jednej uczciwej ocenie od 0 do 100. A wszystko to na podstawie pogody Twojego konkretnego zbiornika.';

  @override
  String get tblFree => 'Darmowe';

  @override
  String get tblPro => 'Pro';

  @override
  String get tblLimited => 'Ograniczone';

  @override
  String get tblForecast => 'Prognoza brań na 7 dni · kiedy jechać';

  @override
  String get tblTactics => 'Codzienna taktyka · co i jak łowić';

  @override
  String get tblSpot => 'Twoje łowisko bez tajemnic · gdzie się ustawić';

  @override
  String get tblAlerts => 'Alerty o najlepszym dniu · dzień wcześniej';

  @override
  String get tblPlaybook => 'Poradnik karpia i karasia';

  @override
  String get tblJournal => 'Dziennik · warunki i indeks brań';

  @override
  String get planYearly => '12 miesięcy';

  @override
  String get planWeekly => 'Tydzień';

  @override
  String trialBadgeFreeDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dnia za darmo',
      many: '$days dni za darmo',
      few: '$days dni za darmo',
      one: '$days dzień za darmo',
    );
    return '$_temp0';
  }

  @override
  String trialDayLabel(int n) {
    return 'Dzień $n';
  }

  @override
  String get trialDay1Desc => 'Start okresu próbnego';

  @override
  String get trialDayMidDesc => 'Przypomnimy Ci';

  @override
  String get trialDayEndDesc => 'Start planu';

  @override
  String get paywallAlgoTitle => 'Inteligentny algorytm brań';

  @override
  String get paywallAlgoBody =>
      'Dziesiątki reguł dopasowanych do biologii karpia — ciśnienie, temperatura wody, wiatr, księżyc, pora roku i pora dnia w jednej uczciwej ocenie 0–100. A wszystko to dla pogody na Twoim własnym zbiorniku.';

  @override
  String get featureForecast => 'Prognoza brań na 7 dni — wiesz, kiedy jechać';

  @override
  String get featureTactics => 'Codzienna taktyka — co i jak łowić, czym nęcić';

  @override
  String get featureSpot =>
      '„Twoje łowisko” — analiza wody: typ, wielkość, gdzie stanąć przy wietrze';

  @override
  String get featureAlerts =>
      'Alerty o najlepszym dniu — push wieczorem przed szczytem brań na Twoim łowisku';

  @override
  String get faqTitle => 'Najczęstsze pytania';

  @override
  String get faqCancelQ => 'Czy mogę zrezygnować?';

  @override
  String get faqCancelA =>
      'Tak, w każdej chwili w ustawieniach App Store lub Google Play. Jeśli zrezygnujesz przed końcem okresu próbnego, nie pobierzemy opłaty.';

  @override
  String get faqChargeQ => 'Kiedy zostanę obciążony?';

  @override
  String get faqChargeA =>
      'Jeśli wybrano darmowy okres próbny — po jego zakończeniu. Przypomnimy Ci dzień wcześniej, abyś mógł zdecydować.';

  @override
  String get faqIncludesQ => 'Co obejmuje subskrypcja?';

  @override
  String get faqIncludesA =>
      'Pełną prognozę brań dla wszystkich Twoich łowisk, godzinowe okna brań, regularne aktualizacje i priorytetowe wsparcie.';

  @override
  String get paywallNoPaymentNow => 'Dziś bez płatności';

  @override
  String get paywallCtaStartFree => 'Rozpocznij okres próbny';

  @override
  String get paywallCtaSubscribe => 'Subskrybuj';

  @override
  String get paywallDisclaimer =>
      'Odnawia się automatycznie. Rezygnacja w każdej chwili';

  @override
  String get menuRestore => 'Przywróć zakupy';

  @override
  String get menuTerms => 'Warunki korzystania';

  @override
  String get menuPrivacy => 'Polityka prywatności';

  @override
  String get menuPromo => 'Masz kod?';

  @override
  String get menuRestart => 'Zacznij od nowa';

  @override
  String get promoTitle => 'Wpisz kod promocyjny';

  @override
  String get promoSubtitle => 'Jeśli masz kod aktywacyjny — wpisz go poniżej';

  @override
  String get promoCtaActivate => 'Aktywuj';

  @override
  String get promoErrorInvalid => 'Nieprawidłowy kod';

  @override
  String promoSuccess(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days dnia',
      many: '$days dni',
      few: '$days dni',
      one: '$days dzień',
    );
    return 'Subskrypcja aktywowana na $_temp0';
  }

  @override
  String get homeTitle => 'Główna';

  @override
  String get homeSubNotActive => 'Subskrypcja nieaktywna';

  @override
  String get homeOnboardingNotDone => 'Wprowadzenie nieukończone';

  @override
  String get homeAnswersLabel => 'Twoje odpowiedzi:';

  @override
  String get homeBtnReplayOnboarding => 'Powtórz wprowadzenie';

  @override
  String get homeBtnToPaywall => 'Do paywalla';

  @override
  String get homeBtnResetSub => 'Zresetuj subskrypcję';

  @override
  String homePremiumBadge(String remaining) {
    return 'Premium aktywne · pozostało $remaining';
  }

  @override
  String remainingDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n dnia',
      many: '$n dni',
      few: '$n dni',
      one: '$n dzień',
    );
    return '$_temp0';
  }

  @override
  String remainingHours(int n) {
    return '$n godz.';
  }

  @override
  String remainingMinutes(int n) {
    return '$n min';
  }

  @override
  String get tabHome => 'Główna';

  @override
  String get tabAnalytics => 'Analityka';

  @override
  String get tabSettings => 'Ustawienia';

  @override
  String get homeTabEmpty => 'Zakładka Główna jest na razie pusta';

  @override
  String get analyticsTabEmpty => 'Zakładka Analityka jest na razie pusta';

  @override
  String get settingsSubscriptionTitle => 'Subskrypcja';

  @override
  String get settingsSubActive => 'Premium aktywne';

  @override
  String get settingsSubInactive => 'Subskrypcja nieaktywna';

  @override
  String settingsSubExpiresLeft(String remaining) {
    return 'pozostało $remaining';
  }

  @override
  String get settingsSubBtnGoPaywall => 'Aktywuj subskrypcję';

  @override
  String get settingsSubBtnManage => 'Zarządzaj subskrypcją';

  @override
  String get settingsRestartOnboarding => 'Powtórz wprowadzenie';

  @override
  String get restartConfirmTitle => 'Powtórzyć wprowadzenie?';

  @override
  String get restartConfirmMessage =>
      'Twoje odpowiedzi zostaną wyczyszczone i wrócisz do ekranu powitalnego.';

  @override
  String get commonCancel => 'Anuluj';

  @override
  String get commonConfirm => 'Powtórz';

  @override
  String get commonUndo => 'Cofnij';

  @override
  String get commonDelete => 'Usuń';

  @override
  String get tabNotes => 'Notatki';

  @override
  String get noteNew => 'Notatka';

  @override
  String get notesEmptyTitle => 'Brak notatek';

  @override
  String get notesEmptySubtitle =>
      'Zapisuj swoje wędkarskie obserwacje: branie, przynętę, pogodę.';

  @override
  String get noteNewTitle => 'Nowa notatka';

  @override
  String get noteEditTitle => 'Notatka';

  @override
  String get noteTextHint => 'Co zauważyłeś? Branie, przynęta, pogoda…';

  @override
  String get noteLocationLabel => 'Lokalizacja';

  @override
  String get noteLocationNone => 'Bez lokalizacji';

  @override
  String get notePhotosLabel => 'Zdjęcia';

  @override
  String get notePhotoCamera => 'Aparat';

  @override
  String get notePhotoGallery => 'Galeria';

  @override
  String get noteConditionsTitle => 'Warunki w chwili notatki';

  @override
  String get noteSave => 'Zapisz notatkę';

  @override
  String get noteDeleteConfirm => 'Usunąć notatkę?';

  @override
  String get noteDeleted => 'Notatka usunięta';

  @override
  String get noteEmptyError => 'Dodaj tekst lub zdjęcie';

  @override
  String get noteDiscardTitle => 'Odrzucić zmiany?';

  @override
  String get noteDiscard => 'Odrzuć';

  @override
  String get settingsNotificationsTitle => 'Powiadomienia';

  @override
  String get settingsNotifMaster => 'Wszystkie powiadomienia';

  @override
  String get settingsNotifReminders => 'Przypomnienia';

  @override
  String get settingsNotifNews => 'Nowości i aktualizacje';

  @override
  String get settingsAboutTitle => 'O aplikacji';

  @override
  String get settingsRateApp => 'Oceń aplikację';

  @override
  String get settingsShareApp => 'Poleć znajomym';

  @override
  String get settingsContactSupport => 'Skontaktuj się z pomocą';

  @override
  String shareMessage(String appName, String appLink) {
    return 'Sprawdź $appName — $appLink';
  }

  @override
  String supportEmailSubject(String appName) {
    return 'Pomoc z $appName';
  }

  @override
  String supportEmailBody(
    String appName,
    String version,
    String build,
    String platform,
    String locale,
  ) {
    return '\n\n\n---\nAplikacja: $appName v$version ($build)\nPlatforma: $platform\nJęzyk: $locale';
  }

  @override
  String appVersionFooter(String appName, String version, String build) {
    return '$appName · v$version ($build)';
  }

  @override
  String get settingsAppearanceTitle => 'Wygląd';

  @override
  String get settingsLanguage => 'Język';

  @override
  String get settingsUnitsTitle => 'Jednostki';

  @override
  String get unitTemperature => 'Temperatura';

  @override
  String get unitWind => 'Wiatr';

  @override
  String get unitPressure => 'Ciśnienie';

  @override
  String get settingsMoreTitle => 'Więcej';

  @override
  String get settingsSubInactiveSubtitle => 'Odblokuj wszystkie funkcje';

  @override
  String get settingsThemeTitle => 'Motyw';

  @override
  String get themeSystem => 'Systemowy';

  @override
  String get themeLight => 'Jasny';

  @override
  String get themeDark => 'Ciemny';

  @override
  String mockPurchase(String plan) {
    return 'Zakup testowy: $plan';
  }

  @override
  String get mockRestore => 'Test: zakupy przywrócone';

  @override
  String get tabForecast => 'Prognoza';

  @override
  String get locCurrent => 'Moja lokalizacja';

  @override
  String get locDefault => 'Lokalizacja domyślna';

  @override
  String get locationSheetTitle => 'Lokalizacja';

  @override
  String get locFallbackBanner =>
      'Lokalizacja jest wyłączona — pokazujemy domyślne łowisko. Prognoza może nie pasować do Twojego rejonu.';

  @override
  String get locFallbackAction => 'Wybierz';

  @override
  String get fcLoading => 'Wczytywanie prognozy…';

  @override
  String get fcError => 'Nie udało się wczytać prognozy';

  @override
  String get fcErrorSubtitle => 'Sprawdź połączenie i spróbuj ponownie';

  @override
  String get fcRetry => 'Ponów';

  @override
  String get fcRefresh => 'Odśwież prognozę tygodniową';

  @override
  String get fcRefreshing => 'Aktualizowanie prognozy…';

  @override
  String get fcRefreshStep1 => 'Pobieramy pogodę…';

  @override
  String get fcRefreshStep2 => 'Odczytujemy ciśnienie i wiatr…';

  @override
  String get fcRefreshStep3 => 'Sprawdzamy fazę księżyca…';

  @override
  String get fcRefreshStep4 => 'Szukamy okien brań…';

  @override
  String get fcRefreshStep5 => 'Przeliczamy indeks…';

  @override
  String fcUpdatedAt(String time) {
    return 'zaktualizowano o $time';
  }

  @override
  String get fcUpdatedJustNow => 'zaktualizowano przed chwilą';

  @override
  String fcUpdatedMinAgo(int minutes) {
    return 'zaktualizowano $minutes min temu';
  }

  @override
  String fcUpdatedHoursAgo(int hours) {
    return 'zaktualizowano $hours godz. temu';
  }

  @override
  String fcUpdatedDate(String date) {
    return 'zaktualizowano $date';
  }

  @override
  String fcOfflineUpdated(String age) {
    return 'offline · $age';
  }

  @override
  String get fcFactorGood => 'dobry';

  @override
  String get fcFactorNeutral => 'neutralny';

  @override
  String get fcFactorWeak => 'słaby';

  @override
  String get tabSpots => 'Łowiska';

  @override
  String get spotsActiveTitle => 'Aktywne łowisko';

  @override
  String get spotsSavedTitle => 'Zapisane łowiska';

  @override
  String get spotsUseCurrent => 'Użyj bieżącej lokalizacji';

  @override
  String get spotsEmpty => 'Brak zapisanych łowisk.\nDodaj je na mapie.';

  @override
  String get spotsAddOnMap => 'Dodaj na mapie';

  @override
  String get spotPickerTitle => 'Wybierz łowisko';

  @override
  String get spotNameHint => 'Nazwa łowiska (opcjonalnie)';

  @override
  String get spotSaveBtn => 'Zapisz łowisko';

  @override
  String get spotSaveActive => 'Zapisz';

  @override
  String get spotNameDialogTitle => 'Nazwa łowiska';

  @override
  String get spotEdit => 'Edytuj';

  @override
  String spotDefaultName(int n) {
    return 'Łowisko $n';
  }

  @override
  String get spotDeleted => 'Łowisko usunięte';

  @override
  String get spotDeleteConfirm => 'Usunąć łowisko?';

  @override
  String get spotSearchHint => 'Szukaj miejsca';

  @override
  String get spotNothingFound => 'Nic nie znaleziono';

  @override
  String get spotLocationUnavailable => 'Nie udało się ustalić lokalizacji';

  @override
  String get fcToday => 'Dziś';

  @override
  String get fcTomorrow => 'Jutro';

  @override
  String get fcIndexCaption => 'Indeks brań';

  @override
  String get fcBestWindow => 'Najlepsze okno';

  @override
  String get fcBestWindowEmpty => 'Słaba aktywność przez cały dzień';

  @override
  String get fcHourlyTitle => 'Godzinowo';

  @override
  String get fcWeekTitle => 'Prognoza na 7 dni';

  @override
  String get fcUpcomingDays => 'Najbliższe dni';

  @override
  String get fcSeeWeek => 'Zobacz tydzień';

  @override
  String get fcWhyTitle => 'Skąd ta ocena';

  @override
  String get fcHowItWorksBtn => 'Jak działa prognoza';

  @override
  String get fcHowItWorksTitle => 'Jak działa prognoza';

  @override
  String get fcHowItWorksP1Title => 'Inteligentny model, nie rzut monetą';

  @override
  String get fcHowItWorksP1Body =>
      'Za każdą oceną stoi model, który każdego dnia łączy dziesiątki czynników pogodowych — ciśnienie atmosferyczne i jego wahania, prędkość i kierunek wiatru, temperaturę powietrza i wody, zachmurzenie, opady, fazę księżyca i porę roku. Każdy ważymy i zamieniamy w jedną, czytelną ocenę brań.';

  @override
  String get fcHowItWorksP2Title => 'Dopasowany do Twojej wody';

  @override
  String get fcHowItWorksP2Body =>
      'Jezioro, rzeka, staw i zbiornik rządzą się własnymi prawami. Algorytm uwzględnia typ wody i jej cechy, by wskazać, gdzie i kiedy ryby są bardziej aktywne dokładnie na Twoim łowisku.';

  @override
  String get fcHowItWorksP3Title => 'Oparty na zachowaniu ryb';

  @override
  String get fcHowItWorksP3Body =>
      'Ryby reagują na pogodę w przewidywalny sposób — szukają komfortowej temperatury, tlenu i pokarmu. Wbudowaliśmy te wzorce i przekładamy je na konkretne wskazówki: gdzie się ustawić, na jakiej głębokości łowić i na które godziny czekać na branie.';

  @override
  String get fcHowItWorksP4Title => 'Najlepszy czas i miejsce';

  @override
  String get fcHowItWorksP4Body =>
      'Prognozujemy nie tylko dziś, ale i dni naprzód, oraz wskazujemy najmocniejsze okna brań — abyś zaplanował wyprawę na najbardziej obiecujący dzień i godzinę, zamiast zgadywać.';

  @override
  String get fcHowItWorksDisclaimer =>
      'To prawdopodobieństwo, nie obietnica. Nad wodą zawsze czytaj łowisko i eksperymentuj — miejsce, przynęta, czas.';

  @override
  String get storyTitle => 'Anatomia brania';

  @override
  String get storySubtitle => 'Dlaczego to nie wróżenie z fusów';

  @override
  String get storyHookTitle => 'Branie to nie loteria';

  @override
  String get storyHookBody =>
      'Ryby są zmiennocieplne: żadnego „nastroju”, tylko reakcja na wodę i niebo. Spada ciśnienie, woda się ogrzewa, zrywa się wiatr — apetyt się zmienia. Nauczyliśmy się czytać te sygnały i składać je w jedną ocenę. Oto co się na nią składa.';

  @override
  String get storyPressureTitle => 'Barometr i termometr';

  @override
  String get storyPressureBody =>
      'Ryba ma wbudowany barometr — pęcherz pławny. Gwałtowny skok ciśnienia ją oszałamia; powolny spadek przed załamaniem pogody włącza żerowanie. Wszystko to rozgrywa się na tle temperatury wody, która zostaje w tyle za powietrzem — mały staw budzi się w kilka dni, duże jezioro w tygodnie — więc modelujemy bezwładność wody i dopasowujemy ją do Twojego zbiornika. Zimna woda: ospałe ryby przy dnie. Ogrzana: na żerze.';

  @override
  String get storyWindTitle => 'Wiatr i godzina';

  @override
  String get storyWindBody =>
      'Wiatr to przyjaciel wędkarza: spycha ciepłą wodę i pokarm na zawietrzny brzeg oraz dotlenia — tam zbierają się ryby. I każdy ma swoją godzinę: karp kocha zmierzch i ciepłą noc, karaś poranek, a upalne południe wycisza branie. Księżyc nieco to koryguje. Dlatego ocena zmienia się nie tylko z dnia na dzień, ale i z godziny na godzinę.';

  @override
  String get storyTypeTitle => 'Każda woda ma swój charakter';

  @override
  String get storyTypeBody =>
      'Jezioro, rzeka, staw, kanał i zbiornik żyją po swojemu. Na dużej wodzie ryby idą za wiatrem; na rzece trzymają się zakoli, dołów i spokojnej wody pod bystrzami; w małym stawie tulą się do trzcin i zaczepów. Rozpoznajemy Twoją wodę z mapy OpenStreetMap — jej typ i wielkość — i dopasowujemy zarówno model ogrzewania wody, jak i wskazówki gdzie szukać do Twojego zbiornika.';

  @override
  String get storyFishTitle => 'Karp ≠ karaś';

  @override
  String get storyFishBody =>
      'Jeden silnik, dwa charaktery — i nie wolno ich mylić. Karp to ostrożny smakosz: lubi ciepłą wodę, powolny spadek ciśnienia przed załamaniem pogody i żeruje nawet nocą. Karaś jest bardziej wrażliwy na wahania, budzi się później i szybko się nasyca, lecz jest niewiarygodnie wytrzymały — duszna ciepła kałuża, która przeszkadza karpiowi, jemu odpowiada w sam raz. Dlatego oceniamy każdego według własnego profilu: progi temperatury, reakcja na ciśnienie, godziny żerowania.';

  @override
  String get storyTacticsTitle => 'Nie tylko kiedy, ale i jak';

  @override
  String get storyTacticsBody =>
      'Wiedza, że dziś bierze, to za mało — liczy się jak. Na podstawie realnej pogody dnia podpowiadamy: „termometr przynęty” (zimno — małe i jaskrawe: białe robaki, kukurydza; ciepło — treściwe: kulki, orzeszki tygrysie), jaki zestaw zastosować, gdzie usiąść i na które godziny czekać. Na ogrzewającej się wodzie nęcimy obficie; w zimnie i upale — oszczędnie. Wszystko dopasowane do wody i nieba tego dnia, nie według schematu.';

  @override
  String get storyHonestTitle => 'Prawdopodobieństwo, nie obietnica';

  @override
  String get storyHonestBody =>
      'Bądźmy szczerzy: to ocena szans, a nie obietnica połowu. Głębokość, ukształtowanie dna, zaczepy i ile ryb faktycznie jest pod Tobą — tego satelita nie zobaczy, a żaden model nie zna. Prognoza pomaga wybrać dobry dzień, miejsce i czas — wyjmuje z wędkowania loterię. Reszta należy do Ciebie: próbuj miejsc, zmieniaj przynęty i głębokości, eksperymentuj. Na tym polega cała frajda.';

  @override
  String get fcWhyHelps => 'Sprzyja';

  @override
  String get fcWhyHurts => 'Przeszkadza';

  @override
  String get fcWhyNoCons => 'brak czynników ograniczających';

  @override
  String get fcWhyAnd => 'i';

  @override
  String fcWhyHelpsOne(Object factors) {
    return '$factors sprzyja braniu.';
  }

  @override
  String fcWhyHelpsMany(Object factors) {
    return '$factors sprzyjają braniu.';
  }

  @override
  String fcWhyHurtsOne(Object factors) {
    return '$factors obniża aktywność ryb.';
  }

  @override
  String fcWhyHurtsMany(Object factors) {
    return '$factors obniżają aktywność ryb.';
  }

  @override
  String get fcWhyBalanced =>
      'Czynniki się równoważą — nie spodziewaj się gwałtownych wahań aktywności.';

  @override
  String get fcPhrasePressurePos =>
      'stabilne ciśnienie utrzymuje ryby na żerze przy dnie';

  @override
  String get fcPhrasePressureNeg =>
      'wahania ciśnienia zniechęcają ryby do żeru';

  @override
  String get fcPhraseTemperaturePos =>
      'woda ogrzała się do komfortowego zakresu żerowania';

  @override
  String get fcPhraseTemperatureNeg =>
      'zimna woda spowalnia ryby i rzadko żerują';

  @override
  String get fcPhraseWindPos => 'lekka fala spycha pokarm w stronę brzegu';

  @override
  String get fcPhraseWindNeg =>
      'silny wiatr podnosi falę, a ryby schodzą głębiej';

  @override
  String get fcPhraseCloudPos =>
      'zachmurzenie przygasza światło, więc ryby żerują śmielej';

  @override
  String get fcPhraseCloudNeg =>
      'jaskrawe słońce czyni ryby ostrożnymi i się chowają';

  @override
  String get fcPhrasePrecipPos =>
      'sucha, ustabilizowana pogoda utrzymuje ryby w przewidywalnym rytmie';

  @override
  String get fcPhrasePrecipNeg => 'deszcz mąci wodę i rozchwiewa ciśnienie';

  @override
  String get fcPhraseSeasonPos => 'sezonowy szczyt — ryby intensywnie żerują';

  @override
  String get fcPhraseSeasonNeg =>
      'sezonowy zastój — metabolizm ryb jest spowolniony';

  @override
  String get fcPhraseMoonPos =>
      'aktywna faza księżyca — solarno-lunarny szczyt żeru';

  @override
  String get fcPhraseMoonNeg => 'słaba faza księżyca — solarno-lunarny zastój';

  @override
  String get fcConfidenceHigh => 'Wysoka pewność';

  @override
  String get fcConfidenceMedium => 'Średnia pewność';

  @override
  String get fcConfidenceLow => 'Niska pewność';

  @override
  String get fcDayConditions => 'Pogoda w ciągu dnia';

  @override
  String get fcPeriodNight => 'Noc';

  @override
  String get fcPeriodMorning => 'Rano';

  @override
  String get fcPeriodDay => 'Dzień';

  @override
  String get fcPeriodEvening => 'Wieczór';

  @override
  String get fcRateWeak => 'Słabe';

  @override
  String get fcRateMid => 'Przeciętne';

  @override
  String get fcRateGood => 'Dobre';

  @override
  String get fcRateGreat => 'Świetne';

  @override
  String get fcPeriodWhyTitle => 'Skąd ta ocena';

  @override
  String get fcPeriodTimeEffect => 'Pora dnia';

  @override
  String get fcPeriodBaseTitle => 'Warunki bazowe';

  @override
  String get fcPeriodWater => 'Woda';

  @override
  String get fcTodAdjCaption => 'Korekta na porę dnia';

  @override
  String fcTodDawn(String sunrise) {
    return 'Świt około $sunrise to dzienny szczyt żerowania, więc ten okres jest podniesiony ponad poziom dzienny.';
  }

  @override
  String fcTodDusk(String sunset) {
    return 'Zmierzch około $sunset — ryby intensywnie żerują przed zmrokiem, więc ocena jest podniesiona.';
  }

  @override
  String fcTodWarmNight(String water, String warm) {
    return 'Woda $water jest na poziomie progu ciepłej nocy $warm lub powyżej, więc ryby żerują także po zmroku — nocna ocena pozostaje blisko poziomu dziennego.';
  }

  @override
  String fcTodMidNight(String water, String cold, String warm) {
    return 'Woda $water jest między progiem zimna ($cold) a progiem ciepłej nocy ($warm) — nocne żerowanie jest tylko częściowe, a im cieplejsza woda, tym żywsza noc.';
  }

  @override
  String fcTodColdNight(String water, String cold) {
    return 'Woda $water jest poniżej progu zimna $cold — w zimnej wodzie ryby ledwie się ruszają w nocy, więc ocena spada znacznie poniżej poziomu dziennego.';
  }

  @override
  String fcTodMiddayHot(String temp, String heat) {
    return 'Południe jest upalne ($temp, powyżej $heat) — ryby chronią się w cieniu i głębszej wodzie, więc branie słabnie.';
  }

  @override
  String fcTodColdDay(String water, String cold) {
    return 'Woda jest zimna ($water, na poziomie $cold lub poniżej); dzienne ogrzanie czyni południe relatywnie najlepszym oknem.';
  }

  @override
  String get fcTodDayNeutral =>
      'Godziny dzienne między szczytami świtu i zmierzchu — spokojna, przeciętna aktywność.';

  @override
  String get spawnTitle => 'Okno tarła';

  @override
  String spawnPreSpawn(String water) {
    return 'Woda $water i ogrzewa się w stronę zakresu tarła — wygląda to na okres przed tarłem.';
  }

  @override
  String spawnSpawning(String water) {
    return 'Woda $water mieści się w zakresie tarła tego gatunku — wygląda to na tarło.';
  }

  @override
  String spawnPostSpawn(String water) {
    return 'Woda $water przekroczyła zakres tarła — tarło wygląda na zakończone.';
  }

  @override
  String get spawnImpactPreSpawn =>
      'Częsty jest wybuch żerowania przed tarłem — branie zwykle utrzymuje się wysoko (≈70–90 ze 100). Łów, póki okno jest otwarte.';

  @override
  String get spawnImpactSpawning =>
      'Powyższy indeks nie uwzględnia tarła. Jeśli faktycznie trwa, realne branie jest dużo niższe — zwykle ≈10–20 ze 100, przez kilka dni.';

  @override
  String get spawnImpactPostSpawn =>
      'Po tarle zwykle następuje wybuch żerowania — branie znów rośnie (≈70–90 ze 100).';

  @override
  String get spawnCaveatEstimated =>
      'Prognozujemy okno, a nie dokładną datę — tarło przebiega różnie i falami na każdej wodzie, a temperaturę wody szacujemy z temperatury powietrza.';

  @override
  String get spawnCaveatRough =>
      'Zgrubna prognoza: duża, bezwładna woda, tarło wszędzie wygląda inaczej, a wodę szacujemy z powietrza — termin może się wyraźnie przesunąć.';

  @override
  String get moonNew => 'Nów';

  @override
  String get moonWaxing => 'Przybywający';

  @override
  String get moonFull => 'Pełnia';

  @override
  String get moonWaning => 'Ubywający';

  @override
  String get fcHowToFish => 'Jak łowić dziś';

  @override
  String get fcHowToFishTomorrow => 'Jak łowić jutro';

  @override
  String fcHowToFishOn(String date) {
    return 'Jak łowić $date';
  }

  @override
  String get fcWhenTitle => 'Kiedy';

  @override
  String get fcWindowsLabel => 'Okna brań';

  @override
  String get fcWindowDawn => 'poranne branie (świt)';

  @override
  String get fcWindowDusk => 'wieczorne branie (zmierzch)';

  @override
  String get fcWindowNight => 'nocne branie';

  @override
  String get fcWindowMorning => 'rano';

  @override
  String get fcWindowEvening => 'wieczorem';

  @override
  String get fcWindowDay => 'w południe';

  @override
  String get fcWindowsWhyDawn =>
      'Karp żeruje najmocniej o pierwszym i ostatnim świetle — o świcie i o zmierzchu.';

  @override
  String get fcWindowsWhyNight => 'W ciepłej wodzie karp aktywnie żeruje nocą.';

  @override
  String get fcWindowsWhyDay =>
      'Łagodna pogoda w ciągu dnia utrzymuje aktywność ryb.';

  @override
  String get fcVerdictVeryLow => 'Trudny dzień — branie ospałe, lepiej odpuść.';

  @override
  String get fcVerdictLow =>
      'Słabe branie. Jeśli jedziesz — łów precyzyjnie i cierpliwie.';

  @override
  String get fcVerdictMedium =>
      'Przeciętny dzień — bez gwarancji, ale jest szansa.';

  @override
  String fcVerdictMediumWindow(String from, String to) {
    return 'Jest szansa — spróbuj w oknie $from–$to.';
  }

  @override
  String get fcVerdictGood => 'Dobry dzień — trzymaj przynętę w wodzie.';

  @override
  String fcVerdictGoodWindow(String from, String to) {
    return 'Warto jechać. Najlepszy czas — $from–$to.';
  }

  @override
  String get fcVerdictExcellent => 'Doskonały dzień — branie trwa!';

  @override
  String fcVerdictExcellentWindow(String from, String to) {
    return 'Doskonały dzień! Nie przegap okna $from–$to.';
  }

  @override
  String get fcLevelVeryLow => 'Bardzo niski';

  @override
  String get fcLevelLow => 'Niski';

  @override
  String get fcLevelMedium => 'Umiarkowany';

  @override
  String get fcLevelGood => 'Dobry';

  @override
  String get fcLevelExcellent => 'Doskonały';

  @override
  String get fcFactorPressure => 'Ciśnienie';

  @override
  String get fcFactorTemperature => 'Temp. wody';

  @override
  String get fcFactorWind => 'Wiatr';

  @override
  String get fcFactorCloud => 'Zachmurzenie';

  @override
  String get fcFactorPrecipitation => 'Opady';

  @override
  String get fcFactorSeason => 'Pora roku';

  @override
  String get fcFactorMoon => 'Księżyc';

  @override
  String get fcCondClear => 'Bezchmurnie';

  @override
  String get fcCondPartly => 'Częściowe zachmurzenie';

  @override
  String get fcCondCloudy => 'Pochmurno';

  @override
  String get fcCondRain => 'Deszcz';

  @override
  String get fcCondStorm => 'Burza';

  @override
  String get fcChipPressure => 'Ciśnienie';

  @override
  String get fcChipWind => 'Wiatr';

  @override
  String get fcChipWater => 'Woda';

  @override
  String get fcChipTemp => 'Temperatura';

  @override
  String get fcChipMoon => 'Księżyc';

  @override
  String get fishCarp => 'Karp';

  @override
  String get fishCrucian => 'Karaś';

  @override
  String get fishSheetTitle => 'Ryba';

  @override
  String get fcUnitHpaSuffix => 'hPa';

  @override
  String get fcUnitMmHgSuffix => 'mmHg';

  @override
  String get fcUnitMsSuffix => 'm/s';

  @override
  String get fcUnitKmhSuffix => 'km/h';

  @override
  String get fcWindCalm => 'Cisza';

  @override
  String get fcWindN => 'Pn';

  @override
  String get fcWindNE => 'PnW';

  @override
  String get fcWindE => 'W';

  @override
  String get fcWindSE => 'PdW';

  @override
  String get fcWindS => 'Pd';

  @override
  String get fcWindSW => 'PdZ';

  @override
  String get fcWindW => 'Z';

  @override
  String get fcWindNW => 'PnZ';

  @override
  String get tabAdvice => 'Taktyka';

  @override
  String get adviceHeadline => 'Sugerowana taktyka';

  @override
  String get adviceDisclaimer =>
      'Wskazówki na podstawie prognozy pogody, nie konkretnego zbiornika.';

  @override
  String get adviceKindBait => 'Przynęta';

  @override
  String get adviceKindAroma => 'Zapach';

  @override
  String get adviceKindFeeding => 'Nęcenie';

  @override
  String get adviceKindDepth => 'Głębokość';

  @override
  String get adviceKindLocation => 'Miejsce';

  @override
  String get adviceKindTiming => 'Czas';

  @override
  String adviceWhyWater(String value) {
    return 'woda $value';
  }

  @override
  String get adviceWhyWaterRising => 'woda ogrzewa się z dnia na dzień';

  @override
  String get adviceWhyWaterFalling => 'woda stygnie z dnia na dzień';

  @override
  String adviceWhyAirHot(String value) {
    return 'upalnie — powietrze $value';
  }

  @override
  String adviceWhyWind(String value) {
    return 'wiatr $value';
  }

  @override
  String get adviceWhyWindLight => 'słaby wiatr';

  @override
  String get adviceWhyPressureFalling => 'ciśnienie spada';

  @override
  String get adviceWhyRain => 'deszcz w ciągu dnia';

  @override
  String get adviceWhyBottomHabit => 'łagodna woda — karp trzyma się przy dnie';

  @override
  String get adviceWhyBiteHigh => 'wysoki indeks brań';

  @override
  String get adviceWhyBiteMid => 'umiarkowany indeks brań';

  @override
  String get adviceWhyBiteLow => 'niski indeks brań';

  @override
  String get adviceWhyBestHours => 'indeks ma szczyt o tej porze';

  @override
  String get windFullN => 'północny';

  @override
  String get windFullNE => 'północno-wschodni';

  @override
  String get windFullE => 'wschodni';

  @override
  String get windFullSE => 'południowo-wschodni';

  @override
  String get windFullS => 'południowy';

  @override
  String get windFullSW => 'południowo-zachodni';

  @override
  String get windFullW => 'zachodni';

  @override
  String get windFullNW => 'północno-zachodni';

  @override
  String get adviceBaitColdBrightTitle => 'Małe jaskrawe przynęty';

  @override
  String get adviceBaitColdBrightBody =>
      'Zimna woda — kukurydza, białe robaki, drobny pellet. Karp żeruje mało i ostrożnie.';

  @override
  String get adviceBaitMidBoiliesTitle => 'Kulki i pellet';

  @override
  String get adviceBaitMidBoiliesBody =>
      'Woda się ogrzewa — kulki 10–16 mm i pellet. Karp jest bardziej aktywny.';

  @override
  String get adviceBaitWarmFishmealTitle => 'Kulki rybne';

  @override
  String get adviceBaitWarmFishmealBody =>
      'Ciepła woda, szczyt apetytu — treściwe kulki rybne, orzeszki tygrysie, kukurydza.';

  @override
  String get adviceBaitHotSurfaceTitle => 'Przynęty pływające';

  @override
  String get adviceBaitHotSurfaceBody =>
      'Upał wypycha karpia w górę — pop-upy, pływający pellet, odrobina chleba.';

  @override
  String get adviceBaitWarmingTitle => 'Większe i bardziej pachnące';

  @override
  String get adviceBaitWarmingBody =>
      'Trend ocieplenia — karp się rozkręca. Kulki, orzeszki tygrysie, aromatyzowane przynęty.';

  @override
  String get adviceBaitCoolingTitle => 'Zmniejsz i rozjaśnij';

  @override
  String get adviceBaitCoolingBody =>
      'Woda stygnie — ryby stają się ostrożne. Drobny pellet, kukurydza, białe robaki.';

  @override
  String get adviceAromaSweetFruityTitle => 'Słodko-owocowy zapach';

  @override
  String get adviceAromaSweetFruityBody =>
      'Słodko-owocowy profil (truskawka, scopex, miód). Trzymaj jeden zapach w zanęcie i na haczyku — rozpuszczalny w wodzie, wabi bez przekarmienia.';

  @override
  String get adviceAromaFishmealTitle => 'Zapach rybny';

  @override
  String get adviceAromaFishmealBody =>
      'Ciepła woda, szczyt żeru — profil rybny (mączka rybna, kryl, wątroba). Działa w bazie zanęty i na haczyku: oleje i aminokwasy karmią.';

  @override
  String get adviceAromaSpicyTitle => 'Korzenny zapach';

  @override
  String get adviceAromaSpicyBody =>
      'Zimna, zabarwiona woda — profil korzenny (chili, pieprz, Robin Red). Trzymaj go w zanęcie i na haczyku — mocny sygnał, gdy ryby są ospałe.';

  @override
  String get adviceFeedMinimalTitle => 'Nęć oszczędnie';

  @override
  String get adviceFeedMinimalBody =>
      'Tylko parę garści, skupionych ciasno — nie przekarmiaj nieaktywnych ryb.';

  @override
  String get adviceFeedModerateTitle => 'Nęć umiarkowanie';

  @override
  String get adviceFeedModerateBody =>
      'Średnia ilość; dokładaj regularnie, po trochu.';

  @override
  String get adviceFeedHeavyTitle => 'Nęć obficie';

  @override
  String get adviceFeedHeavyBody =>
      'Karp mocno żeruje — większe nęcenie startowe i częste dokładki się opłacają.';

  @override
  String get adviceRigBottomTitle => 'Łów przy dnie';

  @override
  String get adviceRigBottomBody =>
      'Zestaw denny na dnie lub przy strukturach — klasyczny zestaw na karpia.';

  @override
  String get adviceRigZigTitle => 'Spróbuj zig rig';

  @override
  String get adviceRigZigBody =>
      'Ryby trzymają się w toni — zig 1–2 m nad dnem może zadziałać.';

  @override
  String get adviceRigSurfaceTitle => 'Łów przy powierzchni';

  @override
  String get adviceRigSurfaceBody =>
      'Karp wygrzewa się przy powierzchni — zestaw powierzchniowy i pływająca przynęta.';

  @override
  String get adviceSwimWindwardTitle => 'Łów pod wiatr';

  @override
  String adviceSwimWindwardBody(String dir) {
    return 'Wiatr $dir spycha ciepłą wodę powierzchniową i pokarm na przeciwległy brzeg; tam żeruje karp.';
  }

  @override
  String get adviceSwimCalmFeaturesTitle => 'Celuj w struktury';

  @override
  String get adviceSwimCalmFeaturesBody =>
      'Słaby wiatr — obrabiaj uskoki, zaczepy, trzciny i zmiany głębokości.';

  @override
  String get adviceSwimShelteredTitle => 'Głębiej lub w cień';

  @override
  String get adviceSwimShelteredBody =>
      'W upale szukaj chłodniejszej, głębszej wody i zacienionych miejsc.';

  @override
  String get adviceSpotReeds =>
      'Trzciny w pobliżu — rzucaj tuż przy krawędzi trzcin, karp patroluje brzeg.';

  @override
  String get adviceSpotInflow =>
      'W pobliżu dopływ — świeża, dotleniona woda i naniesiony pokarm, mocno w upale.';

  @override
  String get adviceSpotDam =>
      'Tama w pobliżu — głębia i stare koryto; karp tam stoi, zwłaszcza w upale.';

  @override
  String get adviceSpotIsland =>
      'Wyspa w pobliżu — magnes na karpia; obrabiaj jej krawędzie i uskoki.';

  @override
  String get adviceTimePressureDropTitle => 'Okno przed frontem';

  @override
  String get adviceTimePressureDropBody =>
      'Ciśnienie spada — prawdopodobne żerowanie. Nie przegap najbliższych godzin.';

  @override
  String get adviceTimeBestWindowTitle => 'Dzisiejsze najlepsze okno';

  @override
  String adviceTimeBestWindowBody(String from, String to) {
    return 'Szczyt aktywności około $from–$to. Bądź na łowisku nieco wcześniej.';
  }

  @override
  String get adviceTimeDawnDuskTitle => 'Świt i zmierzch';

  @override
  String get adviceTimeDawnDuskBody =>
      'Stawiaj na wczesny ranek i późny wieczór — najpewniejsze branie.';

  @override
  String get adviceTimeAllDayTitle => 'Aktywny cały dzień';

  @override
  String get adviceTimeAllDayBody =>
      'Wysoki indeks — karp żeruje przez cały dzień; trzymaj przynętę w wodzie.';

  @override
  String get adviceTimeSlowPatientTitle => 'Bądź cierpliwy';

  @override
  String get adviceTimeSlowPatientBody =>
      'Ryby są ospałe — precyzyjna prezentacja, delikatniejsze zestawy, czekaj na okno.';

  @override
  String get crucianBaitColdAnimalTitle => 'Przynęta zwierzęca';

  @override
  String get crucianBaitColdAnimalBody =>
      'Zimna woda — drobna ochotka i białe robaki. Po jednej–dwie larwy; karaś żeruje powoli.';

  @override
  String get crucianBaitWarmingTitle => 'Robak i białe robaki';

  @override
  String get crucianBaitWarmingBody =>
      'Woda się ogrzewa — karaś się rozkręca. Rosówka, pęczek białych robaków, ochotka.';

  @override
  String get crucianBaitCoolingTitle => 'Zmniejsz i zmiękcz';

  @override
  String get crucianBaitCoolingBody =>
      'Stygnięcie — karaś staje się grymaśny. Drobna ochotka lub kanapka, miększa przynęta.';

  @override
  String get crucianBaitSandwichTitle => 'Przynęta kanapkowa';

  @override
  String get crucianBaitSandwichBody =>
      'Woda przejściowa — kanapka: białe robaki z pęczakiem lub kukurydzą. Karaś jest wybredny.';

  @override
  String get crucianBaitWarmPlantTitle => 'Przynęta roślinna';

  @override
  String get crucianBaitWarmPlantBody =>
      'Ciepła woda — pęczak, ciasto z kaszy manny, kukurydza, ciasto. Karaś przechodzi na przynęty roślinne.';

  @override
  String get crucianBaitHotDoughTitle => 'Miękkie ciasto';

  @override
  String get crucianBaitHotDoughBody =>
      'Upał — miękkie ciasto, ciasto z kaszy manny, miękisz chleba. Lekka słodka przynęta w toni.';

  @override
  String get crucianFeedTinyTitle => 'Nęć skupiony';

  @override
  String get crucianFeedTinyBody =>
      'Karaś jest płochliwy i szybko się nasyca — kilka szczypt drobnej słodkiej zanęty, nie więcej.';

  @override
  String get crucianFeedSweetTitle => 'Słodka zanęta';

  @override
  String get crucianFeedSweetBody =>
      'Drobna mieszanka z zapachem czosnku lub wanilii; dokładaj po trochu i często, nie przekarmiaj.';

  @override
  String get crucianFeedActiveTitle => 'Nęć aktywnie';

  @override
  String get crucianFeedActiveBody =>
      'Karaś dobrze żeruje — dokładaj częściej, ale małymi porcjami, by utrzymać ławicę.';

  @override
  String get crucianRigFloatBottomTitle => 'Spławik przy dnie';

  @override
  String get crucianRigFloatBottomBody =>
      'Klasyczny zestaw na karasia — zestaw spławikowy, przynęta leży na dnie lub ledwie go dotyka.';

  @override
  String get crucianRigDropperTitle => 'Śródwodny opad';

  @override
  String get crucianRigDropperBody =>
      'Karaś podniósł się w toń — wolno opadająca przynęta, rozłóż śruciny, łów na opadzie.';

  @override
  String get crucianRigShallowTitle => 'Płytko przy powierzchni';

  @override
  String get crucianRigShallowBody =>
      'W upale karaś wygrzewa się na płyciznach — lekki zestaw, przynęta w ciepłej górnej warstwie.';

  @override
  String get crucianSwimReedsTitle => 'Krawędzie trzcin';

  @override
  String get crucianSwimReedsBody =>
      'Obrabiaj przerwy w roślinności, krawędzie trzcin i zarośnięte miejsca — tam żeruje karaś.';

  @override
  String get crucianSwimWarmShallowsTitle => 'Ciepłe płycizny';

  @override
  String get crucianSwimWarmShallowsBody =>
      'Woda jest zimna — szukaj najcieplejszych płycizn i zatok nagrzanych słońcem.';

  @override
  String get crucianSwimDeepEdgeTitle => 'Głębsza krawędź i cień';

  @override
  String get crucianSwimDeepEdgeBody =>
      'W upale karaś opuszcza płycizny — łów doły, uskoki i zacienione miejsca.';

  @override
  String get crucianTimePressureDropTitle => 'Bądź cierpliwy';

  @override
  String get crucianTimePressureDropBody =>
      'Ciśnienie spada — karaś staje się grymaśny i bierny. Małe miękkie przynęty, czekaj na krótkie okna.';

  @override
  String get crucianTimeBestWindowTitle => 'Dzisiejsze najlepsze okno';

  @override
  String crucianTimeBestWindowBody(String from, String to) {
    return 'Szczyt aktywności około $from–$to. Bądź na łowisku nieco wcześniej.';
  }

  @override
  String get crucianTimeMorningTitle => 'Poranne branie';

  @override
  String get crucianTimeMorningBody =>
      'Stawiaj na wczesny ranek — klasyczne okno karasia, przed upałem.';

  @override
  String get crucianTimeStableWarmTitle => 'Aktywny także w dzień';

  @override
  String get crucianTimeStableWarmBody =>
      'Stabilne ciepło — karaś żeruje przez cały dzień; trzymaj przynętę w wodzie.';

  @override
  String get crucianTimePatientTitle => 'Skupiony i cierpliwy';

  @override
  String get crucianTimePatientBody =>
      'Karaś jest bierny — delikatny zestaw, mała przynęta, obrabiaj jedno miejsce i czekaj na okno.';

  @override
  String get spotTitle => 'Twoje łowisko';

  @override
  String get spotNoWater =>
      'W tym punkcie mapy nie ma zbiornika wodnego. Prognoza pogody nadal działa — ustaw łowisko, by odczytać wodę.';

  @override
  String get spotSetOnMap => 'Ustaw łowisko na mapie';

  @override
  String get spotCheckFailed =>
      'Nie udało się teraz sprawdzić mapy — prognoza pogody nadal działa.';

  @override
  String get spotTypeLake => 'Jezioro';

  @override
  String get spotTypePond => 'Staw';

  @override
  String get spotTypeReservoir => 'Zbiornik';

  @override
  String get spotTypeRiver => 'Rzeka';

  @override
  String get spotTypeCanal => 'Kanał';

  @override
  String get spotTypeWater => 'Woda';

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
    return 'Ciepły wiatr napędza pokarm i cieplejszą wodę na zawietrzny brzeg — ryby są tam zapewne bardziej aktywne. Aktywny brzeg: $bank.';
  }

  @override
  String spotTipSheltered(String bank) {
    return 'Wiatr jest chłodniejszy niż woda — ryby odsuwają się od odsłoniętego brzegu w spokojniejszą wodę. Osłonięta strona: $bank.';
  }

  @override
  String get spotTipNoWind =>
      'Niemal bezwietrznie — żaden brzeg się dziś nie wyróżnia; ryby są rozproszone po strukturach i głębokościach.';

  @override
  String get spotTipColdWater =>
      'Zimna woda — ryby stoją głęboko i ospale przy dnie; wiatr niewiele je teraz porusza.';

  @override
  String get spotWhereRiver =>
      'Szukaj spokojnej wody: dołów, zewnętrznych zakoli, miejsc pod bystrzami, przy zaczepach i filarach mostów.';

  @override
  String get spotWhereCanal =>
      'Kanał jest jednorodny — poluj na anomalie: zakola, mosty, dopływy i zarośnięte brzegi.';

  @override
  String get spotWherePondSmall =>
      'Mała woda szybko się nagrzewa — ryby trzymają się trzcin, zaczepów i brzegów, schodząc głębiej w upale.';

  @override
  String get spotWhereMid =>
      'Woda średniej wielkości — obrabiaj zatoki, uskoki i zarośnięte miejsca.';

  @override
  String get spotWhereLarge =>
      'Duża woda — ryby wędrują; patrz na cyple, uskoki i idź za wiatrem.';

  @override
  String get spotWhereUnknown =>
      'Woda stojąca — patrz na trzciny, zaczepy, uskoki i zatoki.';

  @override
  String get spotStructInflow =>
      'W pobliżu wpada strumień lub kanał — prąd niesie pokarm i tlen; doskonałe miejsce, zwłaszcza w upale.';

  @override
  String get spotStructReeds =>
      'Brzeg porastają tu trzciny lub szuwary — osłona i półka pokarmowa dla karpia.';

  @override
  String get spotStructDam =>
      'Blisko jest tama lub grobla — gwałtowna zmiana głębokości i klasyczne miejsce stania ryb.';

  @override
  String spotStructIslands(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Na tej wodzie jest $count wyspy — ryby często trzymają się przy nich: struktura, zmiany głębokości i osłona.',
      many:
          'Na tej wodzie jest $count wysp — ryby często trzymają się przy nich: struktura, zmiany głębokości i osłona.',
      few:
          'Na tej wodzie są $count wyspy — ryby często trzymają się przy nich: struktura, zmiany głębokości i osłona.',
      one:
          'Na tej wodzie jest wyspa — ryby często trzymają się przy wyspach: struktura, zmiany głębokości i osłona.',
    );
    return '$_temp0';
  }

  @override
  String get spotSourceType => 'dla tego typu wody';

  @override
  String get spotEditTitle => 'Pozycja łowiska';

  @override
  String get spotEditHint =>
      'Przesuń mapę, by ustawić znacznik — w razie potrzeby przesuń go na lepszy brzeg.';

  @override
  String get spotSavePosition => 'Zapisz pozycję';

  @override
  String get spotViewOnMap => 'Zobacz na mapie';

  @override
  String get spotWindLabel => 'Wiatr';

  @override
  String spotWindFrom(String dir) {
    return 'Wiatr $dir';
  }

  @override
  String get spotDirN => 'z północy';

  @override
  String get spotDirNE => 'z północnego wschodu';

  @override
  String get spotDirE => 'ze wschodu';

  @override
  String get spotDirSE => 'z południowego wschodu';

  @override
  String get spotDirS => 'z południa';

  @override
  String get spotDirSW => 'z południowego zachodu';

  @override
  String get spotDirW => 'z zachodu';

  @override
  String get spotDirNW => 'z północnego zachodu';

  @override
  String get spotUserHere =>
      'Twoje łowisko jest już na aktywnym brzegu — jesteś we właściwym miejscu.';

  @override
  String get spotUserOpposite =>
      'Twoje łowisko jest po drugiej stronie — może lepiej łowić po przeciwnej stronie wody.';

  @override
  String get spotSourceMap => 'Z danych OpenStreetMap';

  @override
  String get spotSourceWind => 'z wiatru i temperatury wody';

  @override
  String get spotDisclaimer =>
      'Odczyt warunków z mapy i pogody — nie widzimy głębokości, dna ani zarybienia.';

  @override
  String get settingsAlertsPrimeTitle => 'Najlepszy dzień tygodnia';

  @override
  String get settingsAlertsPrimeSubtitle =>
      'Jedno powiadomienie o najlepszym dniu brań w tygodniu na Twoich łowiskach';

  @override
  String get settingsAlertsExcellentTitle => 'Wszystkie doskonałe dni';

  @override
  String get settingsAlertsExcellentSubtitle =>
      'Powiadomienie wieczorem przed każdym dniem z doskonałym braniem';

  @override
  String get settingsAlertsForCarp => 'Powiadomienia o karpiu';

  @override
  String get settingsAlertsForCrucian => 'Powiadomienia o karasiu';

  @override
  String alertTitlePrime(String fish) {
    return '$fish: najlepszy dzień tygodnia';
  }

  @override
  String alertTitleExcellent(String fish) {
    return '$fish: doskonałe branie jutro';
  }

  @override
  String get alertWindowDawn => 'jutro o świcie';

  @override
  String get alertWindowDusk => 'jutro o zmierzchu';

  @override
  String get alertWindowDay => 'jutro w dzień';

  @override
  String get alertWindowNight => 'jutro w nocy';

  @override
  String get alertWindowAny => 'jutro';

  @override
  String get alertSpotFallback => 'Twoje łowisko';

  @override
  String get tabTips => 'Porady';

  @override
  String get tipsNext => 'Kolejna porada';

  @override
  String get tipLocationFirstTitle => 'Miejsce liczy się bardziej niż przynęta';

  @override
  String get tipLocationFirstBody =>
      'Najczęstszy błąd początkujących to przyjechać i rzucić w nicość. Doświadczeni karpiarze są zgodni: wiedzieć GDZIE są ryby bije na głowę wiedzę CZEGO użyć — w złym stanowisku żadna przynęta nie pomoże. Godzina poświęcona na znalezienie żerujących ryb (plusy, smużki pęcherzyków, ryby krążące przy powierzchni) zwraca się bardziej niż dziesięć godzin łowienia na ślepo za sygnalizatorami. Najpierw obserwuj wodę 15–20 minut, dopiero potem się rozkładaj.';

  @override
  String get tipLocationFirstProof =>
      'Media karpiowe nazywają czytanie wody największą przewagą: w złym miejscu nie złowisz, kropka.';

  @override
  String get tipMarginsTitle =>
      'Łów przy brzegu — najbardziej niedoceniana przewaga';

  @override
  String get tipMarginsBody =>
      'Większość wędkarzy rzuca jak najdalej i ignoruje wodę u własnych stóp. A karp patroluje przybrzeżną półkę każdego dnia i każdej nocy, na każdej wodzie. W jednym znanym przypadku łowiący przy brzegu złowili dwa razy więcej niż ci rzucający na środek. Bonus: widzisz rybę, podasz przynętę konkretnej sztuce i uczysz się z jej zachowania. Podchodź do brzegu cicho.';

  @override
  String get tipMarginsProof =>
      'Przewodnicy zaliczają łowienie tuż przy brzegu do najbardziej niedocenianych taktyk karpiowych.';

  @override
  String get tipSharpHooksTitle => 'Tępy haczyk to stracona ryba';

  @override
  String get tipSharpHooksBody =>
      'To właśnie przeoczają początkujący najczęściej. Różnica między ostrym a ostrym jak igła haczykiem jest ogromna: więcej kontaktów zamienia się w brania, więcej brań w pewne zacięcia. Haczyki tępią się nie tylko o kamienie i małże, ale i po prostu leżąc na dnie. Sprawdzaj grot przed KAŻDYM rzutem (test na paznokciu) i wymieniaj go przy pierwszych oznakach stępienia.';

  @override
  String get tipSharpHooksProof =>
      'Eksperci karpiowi są zgodni — ostrość mocno ogranicza wypięcia i podnosi skuteczność zacięć.';

  @override
  String get tipDontOverfeedTitle => 'Nie przekarmiaj stanowiska';

  @override
  String get tipDontOverfeedBody =>
      'Drugi klasyczny błąd. Za dużo zanęty rozprasza ryby po dużym obszarze i odciąga je od zestawu, a najedzony karp ignoruje Twoją przynętę. Lepiej mało, ale celnie — małe porcje w jedno ciasne miejsce. Przekarmienie to częsta przyczyna pudła, nawet gdy ryby są tuż obok.';

  @override
  String get tipDontOverfeedProof =>
      'Przekarmienie jest na czele większości list typowych błędów w karpiarstwie.';

  @override
  String get tipBaitRegularlyTitle =>
      'Regularne nęcenie bije pojedyncze duże dawki';

  @override
  String get tipBaitRegularlyBody =>
      'Jeśli możesz, nęć łowisko często. Kilogram codziennie działa lepiej niż pięć kilogramów co pięć dni. Konsekwencja uczy karpia wracać po darmowy posiłek bez strachu — więc gdy w końcu łowisz, brania są pewne. Trzymaj się jednej przynęty przez cały sezon: ryby uczą się jej szukać i często się na niej skupiają.';

  @override
  String get tipBaitRegularlyProof =>
      'Producenci przynęt i poradniki nęcenia są zgodni — kluczem jest regularność, mniej, ale częściej.';

  @override
  String get tipHairRigTitle => 'Zestaw włosowy — dlaczego łowi';

  @override
  String get tipHairRigBody =>
      'Karp nie połyka przynęty od razu — testuje ją, wciągając i wypluwając. Z przynętą na samym haczyku czuje metal i wypluwa ją razem z haczykiem. Na włosie przynęta tkwi z dala od gołego haczyka: gdy zostaje wciągnięta, haczyk swobodnie wsuwa się do pyska i zaczepia o dolną wargę. Od lat 80. ta zasada zrewolucjonizowała skuteczność zacięć i stała się fundamentem współczesnego karpiarstwa.';

  @override
  String get tipHairRigProof =>
      'Sprawdzony przez dekady klasyk; zasada wciągania i testowania leży u podstaw każdego współczesnego zestawu karpiowego.';

  @override
  String get tipSweetcornTitle => 'Kukurydza — tania i zabójcza';

  @override
  String get tipSweetcornBody =>
      'Kukurydza łowi karpia na całym świecie: jaskrawa, słodka, miękka i bogata w aminokwasy, więc karp przyjmuje ją jak naturalny pokarm. A kosztuje grosze — ta sama waga kulek jest wielokrotnie droższa. Często daje natychmiastowy efekt tam, gdzie karp żeruje głównie na naturalnym pokarmie.';

  @override
  String get tipSweetcornProof =>
      'Kukurydza jest uznawana za jedną z najtańszych i najskuteczniejszych przynęt; różnica ceny względem kulek sięga dziesiątek razy.';

  @override
  String get tipMixedSizesTitle => 'Mieszaj rozmiary przynęty';

  @override
  String get tipMixedSizesBody =>
      'Mieszaj rozmiary kulek (np. 12–15 mm i 18–22 mm), by karp nie nastroił się na jeden kaliber i nie żerował ostrożnie — rośnie szansa, że weźmie Twoją przynętę haczykową. Małe (12–15 mm) na zimę i wody presyjne, duże (18–22 mm) przeciw rybie towarzyszącej i na okazy.';

  @override
  String get tipMixedSizesProof =>
      'Mieszanie rozmiarów to standardowy trik na przełamanie selektywności ryb co do wielkości.';

  @override
  String get tipFallingPressureTitle => 'Spadające ciśnienie — okno żerowania';

  @override
  String get tipFallingPressureBody =>
      'Gdy zbliża się front i ciśnienie spada, ryby często żerują mocniej. Karp reaguje łagodniej niż drapieżniki (przydenny, mniej wrażliwy), ale wędkarze zauważają, że na niskim ciśnieniu żeruje dłużej i chętniej. Najlepsze okno to 6–12 godzin przed frontem. Ważne: nie ma magicznej wartości ciśnienia — działa TREND spadkowy, a nie odczyt.';

  @override
  String get tipFallingPressureProof =>
      'Obserwacje z czasopism notowały wzrost żerowania o ~40% na spadającym ciśnieniu; jednak najczęściej cytowane badanie (1983, bass) wykazało tylko słabą korelację — więc uczciwie mówić o trendzie, nie o gwarancji.';

  @override
  String get tipCrucianShyBitesTitle =>
      'Karaś bierze nieśmiało — dociąż spławik';

  @override
  String get tipCrucianShyBitesBody =>
      'Branie karasia bywa ledwie widoczne — ćwierć zanurzenia cienkiej antenki. Jeśli nad wodą wystaje za dużo antenki, przegapisz delikatne stuknięcia. Dociąż spławik tak, by wystawało absolutne minimum. Karaś wypluwa przynętę w chwili, gdy poczuje opór, więc wszystko musi być lekkie i czułe.';

  @override
  String get tipCrucianShyBitesProof =>
      'Przewodnicy karasiowi są zgodni — dociąż spławik; cienka antenka rejestruje nieśmiałe brania.';

  @override
  String get tipCrucianFineTackleTitle => 'Karaś: delikatnie i mało';

  @override
  String get tipCrucianFineTackleBody =>
      'Gruba żyłka i duże haczyki odpadają. Użyj cienkiego, ale mocnego haczyka w małym rozmiarze: 18–20 na białe robaki/caster, 16 na kukurydzę/pellet. Nie przekarmiaj (wejdą lin i leszcz): zacznij od kulek zanęty wielkości piłeczki golfowej i kilku ziaren przynęty, dokładaj tylko, gdy dobrze bierze.';

  @override
  String get tipCrucianFineTackleProof =>
      'Standardowa rada na karasia — delikatny zestaw, mały haczyk, wyważone nęcenie.';

  @override
  String get tipCrucianSlowFallTitle => 'Karaś bierze opadającą przynętę';

  @override
  String get tipCrucianSlowFallBody =>
      'Często bierze, gdy przynęta powoli opada. Rozłóż małe śruciny równomiernie dla wolnego opadu, a ostatnią drobną śrucinę-sygnalizator ustaw zaledwie 5–7 cm od haczyka — szybko zarejestruje nieśmiałe branie.';

  @override
  String get tipCrucianSlowFallProof =>
      'Wolny opad plus śrucina-sygnalizator przy haczyku to typowa taktyka na karasia.';

  @override
  String get tipWaterTempTitle => 'Woda bije kalendarz';

  @override
  String get tipWaterTempBody =>
      'Karp jest zmiennocieplny — apetyt zależy od temperatury WODY, a nie od daty. Szczyt aktywności to około 18–24 °C; poniżej ~10 °C metabolizm zwalnia i żerowanie niemal ustaje. W praktyce: w zimnej wodzie zmniejsz przynętę i łów w południowym cieple na płyciznach; w upale łów nocą i o świcie. Nie licz na żer w lodowatej wodzie w południe.';

  @override
  String get tipWaterTempProof =>
      'Biologia karpiowatych: metabolizm zależy wprost od temperatury wody — dlatego zimą branie gwałtownie spada.';

  @override
  String get tipPvaBagTitle => 'Woreczek PVA — kąsek tuż przy haczyku';

  @override
  String get tipPvaBagBody =>
      'Rozpuszczalny w wodzie woreczek PVA z pelletem lub okruchem nadziany na haczyk zrzuca równą porcję zanęty dokładnie tam, gdzie ląduje przynęta. Rozpuszcza się w kilka minut, zostawiając wabiącą plamę i prezentację bez splątań po rzucie. Błyszczy na mule i w roślinności, gdzie pojedyncza przynęta ginie — karp znajduje „stół” i żeruje wprost nad Twoim zestawem.';

  @override
  String get tipPvaBagProof =>
      'Akcesoria PVA to współczesny standard karpiarstwa do precyzyjnego umieszczania zanęty przy haczyku.';

  @override
  String get tipFeatureFindingTitle =>
      'Znajdź struktury — karp patroluje kontury';

  @override
  String get tipFeatureFindingBody =>
      'Ryby nie są rozmieszczone równomiernie — trzymają się struktur: uskoków, zmian głębokości, twardego dna pośród mułu, krawędzi roślinności, zaczepów. Przed łowieniem „wyczuj” dno ołowiem: ciągnij go i wyczuwaj, jak zmienia się grunt, licz głębokość po opadzie. Rzut na znalezioną strukturę bije losowy rzut „na dystans”.';

  @override
  String get tipFeatureFindingProof =>
      'Wyczuwanie struktur markerem lub ołowiem to podstawowa umiejętność karpiarza — karp patroluje struktury, nie otwartą pustkę.';

  @override
  String get tipStayQuietTitle =>
      'Bądź cicho na brzegu — karpia łatwo spłoszyć';

  @override
  String get tipStayQuietBody =>
      'Karp wyczuwa drgania linią boczną i „słyszy” ciałem. Ciężkie kroki, trzaśnięcie drzwiami, stukanie w łódkę, ciężki rzut u własnych stóp — i ryby opuszczają płycizny i strefę przybrzeżną. Podchodź do wody cicho, nie świeć po powierzchni, rozkładaj się delikatnie. Liczy się to najbardziej przy łowieniu z brzegu i na płyciznach.';

  @override
  String get tipStayQuietProof =>
      'Linia boczna karpia wychwytuje najsłabszy ruch — głośny hałas naprawdę stawia ryby w gotowości.';

  @override
  String get tipParticlesTitle => 'Ziarna (konopie) trzymają ławicę';

  @override
  String get tipParticlesBody =>
      'Drobna zanęta jak konopie tworzy plamę, która każe karpiowi ryć i żerować w jednym miejscu bez szybkiego nasycenia — więc ryby zostają nad Twoim zestawem. Uwaga bezpieczeństwa: suche ziarna (zwłaszcza orzeszki tygrysie i fasolę) trzeba przed użyciem namoczyć ORAZ ugotować do miękkości — niedogotowane mogą zaszkodzić rybie.';

  @override
  String get tipParticlesProof =>
      'Konopie to klasyka na utrzymanie ławicy; właściwe przygotowanie ziaren to dobrze znana zasada bezpieczeństwa ryb.';

  @override
  String get tipFishCareTitle => 'Dbaj o rybę — weźmie znowu';

  @override
  String get tipFishCareBody =>
      'Duży karp rośnie dekadami i można go złowić ponownie — jeśli wróci zdrowy do wody. Mokre dłonie i mokra mata lub trawa, minimum czasu poza wodą, nigdy nie kładź ryby na suchym piasku ani kamieniach, odhaczaj delikatnie (kolejny powód, by haczyk był ostry). Zdjęcia nisko nad matą, szybko. Zdrowo wypuszczony karp to przyszłe branie — dla Ciebie i innych.';

  @override
  String get tipFishCareProof =>
      'Praktyka „złów i wypuść” wśród karpiarzy: delikatne obchodzenie się chroni zarybienie i Twoje przyszłe połowy.';

  @override
  String get tipCrucianWarmShallowsTitle => 'Karaś kocha ciepłe płycizny';

  @override
  String get tipCrucianWarmShallowsBody =>
      'Karaś kocha ciepło i roślinność. Wiosną i wczesnym latem najpierw przychodzi żerować na nagrzanych płyciznach — w małych zatokach, przy trzcinach i grzybieniach, gdzie woda jest o parę stopni cieplejsza. Szukaj cichych, zarośniętych, dobrze nagrzanych miejsc; w głębi o tej porze karasia niemal nie ma. Im cieplejsza woda, tym aktywniejszy karaś.';

  @override
  String get tipCrucianWarmShallowsProof =>
      'Karaś to ciepłolubna ryba roślinności; wczesne nagrzewanie płycizn tłumaczy, czemu właśnie tam żeruje najpierw.';

  @override
  String get fcAlgoFactsTitle => 'Wgląd w algorytm';

  @override
  String get fcAlgoFactLabel => 'Ciekawostka dnia';

  @override
  String get algoFactWaterModelTitle => 'Śledzimy wodę, nie powietrze';

  @override
  String get algoFactWaterModelBody =>
      'Karp żyje w wodzie, a ta ogrzewa się z opóźnieniem. Zamiast używać wprost temperatury powietrza, modelujemy temperaturę wody równaniem wymiany ciepła — jak stygnący kubek herbaty.';

  @override
  String get algoFactThermalInertiaTitle =>
      'Każdy zbiornik ma własną bezwładność cieplną';

  @override
  String get algoFactThermalInertiaBody =>
      'Rzeka reaguje na pogodę w parę dni, staw wolniej, a duży zbiornik potrzebuje tygodni, by się zmienić. Dlatego dopasowujemy tempo ogrzewania do typu i wielkości zbiornika.';

  @override
  String get algoFactPressureTrendTitle =>
      'Liczy się trend ciśnienia, nie poziom';

  @override
  String get algoFactPressureTrendBody =>
      'Najlepsze branie przychodzi nie przy jakimś „dobrym” ciśnieniu, lecz podczas łagodnego spadku przed frontem. Gwałtowny krach i gwałtowny skok są karane. Czytamy trend zarówno w ciągu 6, jak i 24 godzin.';

  @override
  String get algoFactFrontMemoryTitle =>
      'Pamiętamy przejście frontu przez dobę';

  @override
  String get algoFactFrontMemoryBody =>
      'Nawet gdy ciśnienie już wróciło, ryby wciąż są w szoku po zimnym froncie. Utrzymujemy osobną karę przez całą dobę — karp potrzebuje dnia lub dwóch na regenerację.';

  @override
  String get algoFactWeakestLinkTitle => 'Zasada najsłabszego ogniwa';

  @override
  String get algoFactWeakestLinkBody =>
      'Wiele kalkulatorów po prostu sumuje punkty, więc dobre ciśnienie „ratuje” lodowatą wodę. U nas temperatura, pora roku i ciśnienie działają jak bezpieczniki: żaden idealny wiatr nie uratuje martwej wody.';

  @override
  String get algoFactHeatCalmTitle => 'Kara za upał i zupełną ciszę';

  @override
  String get algoFactHeatCalmBody =>
      'Spadek wchodzi w grę tylko, gdy upał i zupełna cisza zbiegają się razem — wtedy wodzie brakuje tlenu. Same w sobie upalny dzień czy brak wiatru nie są aż tak szkodliwe.';

  @override
  String get algoFactRealSunTitle =>
      'Szczyty żeru powiązane z prawdziwym słońcem';

  @override
  String get algoFactRealSunBody =>
      'Żadnego sztywnego „branie o 6 rano”. Bierzemy faktyczny wschód i zachód słońca dla Twojego łowiska, wzmacniamy okna poranne i wieczorne, a tłumimy upalne południe.';

  @override
  String get algoFactSpawnPhysicsTitle => 'Tarło z fizyki, nie z kalendarza';

  @override
  String get algoFactSpawnPhysicsBody =>
      'Wyliczamy fazę tarła z temperatury wody i długości dnia na Twojej szerokości geograficznej. I uczciwie mówimy o pewności: na bezwładnym zbiorniku sygnał jest rozmyty.';

  @override
  String get algoFactSpeciesModelsTitle => 'Karp i karaś to dwa różne modele';

  @override
  String get algoFactSpeciesModelsBody =>
      'To nie jeden wzór z polem wyboru. Karaś ma wyższe optimum temperatury, jest bardziej wrażliwy na ciśnienie, lubi lekką falę i niemal nie bierze nocą — dziesiątki parametrów są strojone osobno dla gatunku.';

  @override
  String get algoFactBiteWindowsTitle => 'Okna brań, nie tylko godziny';

  @override
  String get algoFactBiteWindowsBody =>
      'Zbieramy dobre godziny w ciągłe okna, mostkujemy pojedyncze spadki godzinowe i poprawnie zszywamy okna przechodzące przez północ.';

  @override
  String alertBody(String spot, String when, int index) {
    return '$spot: $when, indeks brań $index';
  }
}
