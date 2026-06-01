// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get welcomeTitle => 'Bienvenue';

  @override
  String get welcomeSubtitle => 'Configuration rapide — moins d\'une minute';

  @override
  String get welcomeCta => 'Commencer';

  @override
  String get languageSheetTitle => 'Langue';

  @override
  String get languageSheetSubtitle => 'Choisissez votre langue';

  @override
  String get themeSheetSubtitle => 'Choisissez l\'apparence de l\'app';

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
  String get commonContinue => 'Continuer';

  @override
  String get quizQ1Question => 'Quel poisson vises-tu ?';

  @override
  String get quizQ1Subtitle => 'On adapte la prévision à ton poisson';

  @override
  String get quizQ1OptLearn => 'Carpe';

  @override
  String get quizQ1OptHabit => 'Carassin';

  @override
  String get quizQ1OptSolve => 'Les deux';

  @override
  String get quizQ2Question => 'Sorti pour rien ?';

  @override
  String get quizQ2Subtitle => 'Sois honnête — ça nous aide à t\'aider';

  @override
  String get quizQ2OptDaily => 'Oui, plus d\'une fois';

  @override
  String get quizQ2OptWeekly => 'Parfois';

  @override
  String get quizQ2OptRarely => 'Rare — je prends souvent';

  @override
  String get quizQ3Question => 'Comment planifies-tu ?';

  @override
  String get quizQ3Subtitle => 'Détermine ce qu\'on t\'affiche d\'abord';

  @override
  String get quizQ3OptSimple => 'Je planifie à l\'avance';

  @override
  String get quizQ3OptResult => 'J\'y vais spontanément';

  @override
  String get quizQ3OptFlexible => 'Ça dépend';

  @override
  String get quizQ4Question => 'Tu pêches souvent ?';

  @override
  String get quizQ4Subtitle => 'On t\'alerte des meilleurs jours';

  @override
  String get quizQ4OptWeekly => 'Chaque semaine';

  @override
  String get quizQ4OptMonthly => 'Quelques fois par mois';

  @override
  String get quizQ4OptRarely => 'De temps en temps';

  @override
  String get onbAnalyzingTitle => 'Analyse des conditions';

  @override
  String get onbAnalyzingSubtitle => 'Calcul météo, pression et lune…';

  @override
  String get onbResultTitle => 'Ta prévision de touche est prête';

  @override
  String get onbResultSubtitle =>
      'La touche du jour est gratuite. La prévision sur 7 jours s\'ouvre avec l\'abonnement.';

  @override
  String get onbResultTodayBadge => 'Aujourd\'hui · gratuit';

  @override
  String get onbResultLockedLabel => 'Prévision sur 7 jours';

  @override
  String get onbResultCta => 'Voir ma prévision';

  @override
  String get paywallSkipToday => 'D\'abord voir aujourd\'hui gratuitement';

  @override
  String get paywallTitle => 'Débloquez l\'accès complet';

  @override
  String get planYearly => '12 mois';

  @override
  String get planWeekly => 'Semaine';

  @override
  String trialBadgeFreeDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jours gratuits',
      one: '$days jour gratuit',
    );
    return '$_temp0';
  }

  @override
  String trialDayLabel(int n) {
    return 'Jour $n';
  }

  @override
  String get trialDay1Desc => 'Accès débloqué';

  @override
  String get trialDayMidDesc => 'Nous vous rappellerons un jour avant';

  @override
  String get trialDayEndDesc => 'L\'abonnement commence';

  @override
  String get featureUnlimited => 'Toutes les fonctionnalités sans limite';

  @override
  String get featureUpdates => 'Mises à jour régulières';

  @override
  String get featurePrivacy => 'Sûr et privé';

  @override
  String get featureSupport => 'Support prioritaire';

  @override
  String get faqTitle => 'Questions fréquentes';

  @override
  String get faqCancelQ => 'Puis-je annuler ?';

  @override
  String get faqCancelA =>
      'Oui, à tout moment via les paramètres App Store ou Google Play. Si vous annulez avant la fin de l\'essai, rien ne sera prélevé.';

  @override
  String get faqChargeQ => 'Quand serai-je débité ?';

  @override
  String get faqChargeA =>
      'Si vous avez choisi une période d\'essai — à sa fin. Nous vous préviendrons à l\'avance pour que vous puissiez décider.';

  @override
  String get faqIncludesQ => 'Qu\'inclut l\'abonnement ?';

  @override
  String get faqIncludesA =>
      'Toutes les fonctionnalités sans limite, des mises à jour régulières et un support prioritaire.';

  @override
  String get paywallNoPaymentNow => 'Aucun paiement maintenant';

  @override
  String get paywallCtaStartFree => 'Commencer gratuitement';

  @override
  String get paywallCtaSubscribe => 'S\'abonner';

  @override
  String get paywallDisclaimer =>
      'Renouvellement automatique. Annulation à tout moment';

  @override
  String get menuRestore => 'Restaurer les achats';

  @override
  String get menuTerms => 'Conditions d\'utilisation';

  @override
  String get menuPrivacy => 'Politique de confidentialité';

  @override
  String get menuPromo => 'Avez-vous un code ?';

  @override
  String get menuRestart => 'Recommencer';

  @override
  String get promoTitle => 'Entrez le code promo';

  @override
  String get promoSubtitle =>
      'Si vous avez un code d\'activation — entrez-le ci-dessous';

  @override
  String get promoCtaActivate => 'Activer';

  @override
  String get promoErrorInvalid => 'Code invalide';

  @override
  String promoSuccess(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days jours',
      one: '$days jour',
    );
    return 'Abonnement activé pour $_temp0';
  }

  @override
  String get homeTitle => 'Accueil';

  @override
  String get homeSubNotActive => 'Abonnement non actif';

  @override
  String get homeOnboardingNotDone => 'Onboarding non terminé';

  @override
  String get homeAnswersLabel => 'Vos réponses :';

  @override
  String get homeBtnReplayOnboarding => 'Recommencer l\'onboarding';

  @override
  String get homeBtnToPaywall => 'Vers le paywall';

  @override
  String get homeBtnResetSub => 'Réinitialiser l\'abonnement';

  @override
  String homePremiumBadge(String remaining) {
    return 'Premium active · $remaining restants';
  }

  @override
  String remainingDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n jours',
      one: '$n jour',
    );
    return '$_temp0';
  }

  @override
  String remainingHours(int n) {
    return '$n h';
  }

  @override
  String remainingMinutes(int n) {
    return '$n min';
  }

  @override
  String get tabHome => 'Accueil';

  @override
  String get tabAnalytics => 'Analyses';

  @override
  String get tabSettings => 'Réglages';

  @override
  String get homeTabEmpty => 'L\'onglet Accueil est vide pour l\'instant';

  @override
  String get analyticsTabEmpty => 'L\'onglet Analyses est vide pour l\'instant';

  @override
  String get settingsSubscriptionTitle => 'Abonnement';

  @override
  String get settingsSubActive => 'Premium active';

  @override
  String get settingsSubInactive => 'Abonnement non actif';

  @override
  String settingsSubExpiresLeft(String remaining) {
    return '$remaining restants';
  }

  @override
  String get settingsSubBtnGoPaywall => 'Activer l\'abonnement';

  @override
  String get settingsSubBtnManage => 'Gérer l\'abonnement';

  @override
  String get settingsRestartOnboarding => 'Recommencer l\'onboarding';

  @override
  String get restartConfirmTitle => 'Recommencer l\'onboarding ?';

  @override
  String get restartConfirmMessage =>
      'Vos réponses seront effacées et vous retournerez à l\'écran d\'accueil.';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonConfirm => 'Recommencer';

  @override
  String get commonUndo => 'Annuler';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get tabNotes => 'Notes';

  @override
  String get noteNew => 'Note';

  @override
  String get notesEmptyTitle => 'Pas encore de notes';

  @override
  String get notesEmptySubtitle =>
      'Note tes observations : touche, appât, météo.';

  @override
  String get noteNewTitle => 'Nouvelle note';

  @override
  String get noteEditTitle => 'Note';

  @override
  String get noteTextHint => 'Qu\'as-tu remarqué ? Touche, appât, météo…';

  @override
  String get noteLocationLabel => 'Lieu';

  @override
  String get noteLocationNone => 'Aucun lieu';

  @override
  String get notePhotosLabel => 'Photos';

  @override
  String get notePhotoCamera => 'Appareil photo';

  @override
  String get notePhotoGallery => 'Galerie';

  @override
  String get noteConditionsTitle => 'Conditions au moment de la note';

  @override
  String get noteSave => 'Enregistrer la note';

  @override
  String get noteDeleteConfirm => 'Supprimer la note ?';

  @override
  String get noteDeleted => 'Note supprimée';

  @override
  String get noteEmptyError => 'Ajoute du texte ou une photo';

  @override
  String get noteDiscardTitle => 'Abandonner les modifications ?';

  @override
  String get noteDiscard => 'Abandonner';

  @override
  String get settingsNotificationsTitle => 'Notifications';

  @override
  String get settingsNotifMaster => 'Toutes les notifications';

  @override
  String get settingsNotifReminders => 'Rappels';

  @override
  String get settingsNotifNews => 'Actualités';

  @override
  String get settingsAboutTitle => 'À propos';

  @override
  String get settingsRateApp => 'Évaluer l\'app';

  @override
  String get settingsShareApp => 'Partager avec des amis';

  @override
  String get settingsContactSupport => 'Contacter le support';

  @override
  String shareMessage(String appName, String appLink) {
    return 'Essayez $appName — $appLink';
  }

  @override
  String supportEmailSubject(String appName) {
    return 'Aide pour $appName';
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
  String get settingsAppearanceTitle => 'Apparence';

  @override
  String get settingsLanguage => 'Langue';

  @override
  String get settingsUnitsTitle => 'Unités';

  @override
  String get unitTemperature => 'Température';

  @override
  String get unitWind => 'Vent';

  @override
  String get unitPressure => 'Pression';

  @override
  String get settingsMoreTitle => 'Plus';

  @override
  String get settingsSubInactiveSubtitle =>
      'Débloquez toutes les fonctionnalités';

  @override
  String get settingsThemeTitle => 'Thème';

  @override
  String get themeSystem => 'Système';

  @override
  String get themeLight => 'Clair';

  @override
  String get themeDark => 'Sombre';

  @override
  String mockPurchase(String plan) {
    return 'Achat simulé : $plan';
  }

  @override
  String get mockRestore => 'Simulé : achats restaurés';

  @override
  String get tabForecast => 'Prévision';

  @override
  String get locCurrent => 'Ma position';

  @override
  String get locDefault => 'Position par défaut';

  @override
  String get locationSheetTitle => 'Position';

  @override
  String get locFallbackBanner =>
      'La localisation est désactivée — spot par défaut affiché. La prévision peut ne pas correspondre à ta zone.';

  @override
  String get locFallbackAction => 'Choisir';

  @override
  String get fcLoading => 'Chargement de la prévision…';

  @override
  String get fcError => 'Impossible de charger la prévision';

  @override
  String get fcErrorSubtitle => 'Vérifie ta connexion et réessaie';

  @override
  String get fcRetry => 'Réessayer';

  @override
  String get fcRefresh => 'Actualiser la prévision de la semaine';

  @override
  String get fcRefreshing => 'Mise à jour de la prévision…';

  @override
  String get fcRefreshStep1 => 'Récupération de la météo…';

  @override
  String get fcRefreshStep2 => 'Lecture de la pression et du vent…';

  @override
  String get fcRefreshStep3 => 'Vérification de la phase lunaire…';

  @override
  String get fcRefreshStep4 => 'Recherche des fenêtres de mordant…';

  @override
  String get fcRefreshStep5 => 'Recalcul de l\'indice…';

  @override
  String fcUpdatedAt(String time) {
    return 'mis à jour à $time';
  }

  @override
  String get fcUpdatedJustNow => 'mis à jour à l\'instant';

  @override
  String fcUpdatedMinAgo(int minutes) {
    return 'mis à jour il y a $minutes min';
  }

  @override
  String fcUpdatedHoursAgo(int hours) {
    return 'mis à jour il y a $hours h';
  }

  @override
  String fcUpdatedDate(String date) {
    return 'mis à jour $date';
  }

  @override
  String fcOfflineUpdated(String age) {
    return 'hors ligne · $age';
  }

  @override
  String get fcFactorGood => 'bon';

  @override
  String get fcFactorNeutral => 'neutre';

  @override
  String get fcFactorWeak => 'faible';

  @override
  String get tabSpots => 'Spots';

  @override
  String get spotsActiveTitle => 'Spot actif';

  @override
  String get spotsSavedTitle => 'Spots enregistrés';

  @override
  String get spotsUseCurrent => 'Utiliser ma position';

  @override
  String get spotsEmpty => 'Aucun spot enregistré.\nAjoute-en un sur la carte.';

  @override
  String get spotsAddOnMap => 'Ajouter sur la carte';

  @override
  String get spotPickerTitle => 'Choisir un spot';

  @override
  String get spotNameHint => 'Nom du spot (optionnel)';

  @override
  String get spotSaveBtn => 'Enregistrer le spot';

  @override
  String get spotSaveActive => 'Enregistrer';

  @override
  String get spotNameDialogTitle => 'Nom du spot';

  @override
  String get spotEdit => 'Modifier';

  @override
  String spotDefaultName(int n) {
    return 'Spot $n';
  }

  @override
  String get spotDeleted => 'Spot supprimé';

  @override
  String get spotDeleteConfirm => 'Supprimer le spot ?';

  @override
  String get spotSearchHint => 'Rechercher un lieu';

  @override
  String get spotNothingFound => 'Rien trouvé';

  @override
  String get spotLocationUnavailable => 'Impossible d\'obtenir ta position';

  @override
  String get fcToday => 'Aujourd\'hui';

  @override
  String get fcTomorrow => 'Demain';

  @override
  String get fcIndexCaption => 'Indice de mordant';

  @override
  String get fcBestWindow => 'Meilleure fenêtre';

  @override
  String get fcBestWindowEmpty => 'Activité faible toute la journée';

  @override
  String get fcHourlyTitle => 'Par heure';

  @override
  String get fcWeekTitle => 'Aperçu 7 jours';

  @override
  String get fcUpcomingDays => 'Jours à venir';

  @override
  String get fcSeeWeek => 'Voir la semaine';

  @override
  String get fcWhyTitle => 'Pourquoi ce score';

  @override
  String get fcHowItWorksBtn => 'Comment fonctionne la prévision';

  @override
  String get fcHowItWorksTitle => 'Comment fonctionne la prévision';

  @override
  String get fcHowItWorksP1Title => 'Un modèle malin, pas un coup de dés';

  @override
  String get fcHowItWorksP1Body =>
      'Derrière chaque score se cache un modèle qui réunit chaque jour des dizaines de facteurs météo : pression atmosphérique et ses variations, force et direction du vent, température de l\'air et de l\'eau, nébulosité, précipitations, phase lunaire et saison. Nous pondérons chacun et en faisons un seul score de mordant clair.';

  @override
  String get fcHowItWorksP2Title => 'Adapté à ton plan d\'eau';

  @override
  String get fcHowItWorksP2Body =>
      'Un lac, une rivière, un étang et un réservoir vivent selon leurs propres règles. L\'algorithme prend en compte le type d\'eau et ses particularités pour cibler où et quand le poisson est le plus susceptible d\'être actif sur ton spot.';

  @override
  String get fcHowItWorksP3Title => 'Fondé sur le comportement du poisson';

  @override
  String get fcHowItWorksP3Body =>
      'Le poisson réagit à la météo de façon prévisible : il recherche une température confortable, de l\'oxygène et de la nourriture. Nous intégrons ces schémas et les traduisons en conseils concrets : où t\'installer, à quelle profondeur pêcher et quelles heures attendre.';

  @override
  String get fcHowItWorksP4Title => 'Le meilleur moment et lieu';

  @override
  String get fcHowItWorksP4Body =>
      'Nous calculons non seulement aujourd\'hui mais aussi les jours à venir et mettons en avant les meilleures fenêtres de mordant — pour que tu planifies ta partie le jour et l\'heure les plus prometteurs, sans deviner.';

  @override
  String get fcHowItWorksDisclaimer =>
      'C\'est une probabilité, pas une promesse. Au bord de l\'eau, lis toujours le terrain et expérimente : lieu, appât, moment.';

  @override
  String get storyTitle => 'Anatomie du mordant';

  @override
  String get storySubtitle =>
      'Pourquoi ce n\'est pas lire dans le marc de café';

  @override
  String get storyHookTitle => 'Le mordant n\'est pas une loterie';

  @override
  String get storyHookBody =>
      'Les poissons sont à sang froid : pas d\'« humeur », juste une réaction à l\'eau et au ciel. La pression baisse, l\'eau se réchauffe, le vent se lève — l\'appétit change. Nous avons appris à lire ces signaux et à les réunir en un seul score. Voilà ce qui le compose.';

  @override
  String get storyPressureTitle => 'Baromètre et thermomètre';

  @override
  String get storyPressureBody =>
      'Le poisson a un baromètre intégré : sa vessie natatoire. Un saut brusque de pression l\'assomme ; une baisse lente avant le mauvais temps déclenche la frénésie. Le tout sur fond de température de l\'eau, qui suit l\'air avec du retard — un petit étang se réveille en quelques jours, un grand lac met des semaines — c\'est pourquoi nous modélisons l\'inertie de l\'eau et l\'ajustons à ton plan d\'eau. Eau froide : engourdi au fond. Réchauffée : en train de se nourrir.';

  @override
  String get storyWindTitle => 'Vent et heure';

  @override
  String get storyWindBody =>
      'Le vent est l\'ami du pêcheur : il pousse l\'eau chaude et la nourriture vers la rive sous le vent et apporte de l\'oxygène — c\'est là que le poisson se rassemble. Et chacun a son heure : la carpe aime le crépuscule et la nuit chaude, le carassin le matin, tandis qu\'un midi brûlant coupe le mordant. La lune influe un peu. Ainsi le score change non seulement d\'un jour à l\'autre, mais d\'une heure à l\'autre.';

  @override
  String get storyTypeTitle => 'Chaque eau a son caractère';

  @override
  String get storyTypeBody =>
      'Un lac, une rivière, un étang, un canal et un réservoir vivent chacun à leur façon. Sur les grandes eaux le poisson suit le vent ; en rivière il tient les courbes, les fosses et les eaux calmes en aval des rapides ; dans un petit étang il se colle aux roseaux et aux obstacles. Nous identifions ton eau via la carte OpenStreetMap — son type et sa taille — et ajustons aussi bien le modèle de réchauffement de l\'eau que les conseils sur où chercher.';

  @override
  String get storyFishTitle => 'Carpe ≠ carassin';

  @override
  String get storyFishBody =>
      'Un moteur, deux caractères — et il ne faut pas les confondre. La carpe est une gourmande prudente : elle aime l\'eau chaude, une baisse lente de pression avant le mauvais temps, et se nourrit même la nuit. Le carassin est plus capricieux face aux variations, se réveille plus tard et se rassasie vite, mais il est incroyablement robuste — une mare chaude et étouffante qui gêne la carpe lui convient parfaitement. C\'est pourquoi nous évaluons chacun selon son profil : seuils de température, réaction à la pression, heures de nourrissage.';

  @override
  String get storyTacticsTitle => 'Pas seulement quand, mais comment';

  @override
  String get storyTacticsBody =>
      'Savoir que ça mord aujourd\'hui ne suffit pas — le comment compte. À partir de la météo réelle du jour, nous suggérons : le « thermomètre de l\'appât » (froid — petit et vif : asticots, maïs ; chaud — plus nourrissant : bouillettes, noix tigrées), quel montage utiliser, où t\'asseoir et quelles heures attendre. Sur une eau qui se réchauffe, on amorce généreusement ; par temps froid et forte chaleur, avec parcimonie. Tout est ajusté à l\'eau et au ciel du jour, pas par habitude.';

  @override
  String get storyHonestTitle => 'Une probabilité, pas une promesse';

  @override
  String get storyHonestBody =>
      'Soyons honnêtes : c\'est une estimation des chances, pas une promesse de prise. La profondeur, le relief du fond, les obstacles et combien de poissons se tiennent vraiment sous toi — un satellite ne le voit pas, et aucun modèle ne le sait. La prévision t\'aide à choisir un bon jour, un bon endroit et un bon moment — elle retire la loterie de la pêche. Le reste dépend de toi : essaie des postes, change d\'appâts et de profondeurs, expérimente. C\'est là tout le plaisir.';

  @override
  String get fcWhyHelps => 'Aide';

  @override
  String get fcWhyHurts => 'Freine';

  @override
  String get fcWhyNoCons => 'aucun facteur limitant';

  @override
  String get fcWhyAnd => 'et';

  @override
  String fcWhyHelpsOne(Object factors) {
    return '$factors favorise le mordant.';
  }

  @override
  String fcWhyHelpsMany(Object factors) {
    return '$factors favorisent le mordant.';
  }

  @override
  String fcWhyHurtsOne(Object factors) {
    return '$factors réduit l\'activité du poisson.';
  }

  @override
  String fcWhyHurtsMany(Object factors) {
    return '$factors réduisent l\'activité du poisson.';
  }

  @override
  String get fcWhyBalanced =>
      'Les facteurs s\'équilibrent — pas de fortes variations d\'activité attendues.';

  @override
  String get fcPhrasePressurePos =>
      'une pression stable garde les poissons en train de se nourrir près du fond';

  @override
  String get fcPhrasePressureNeg =>
      'les variations de pression coupent l\'appétit des poissons';

  @override
  String get fcPhraseTemperaturePos =>
      'l\'eau s\'est réchauffée à une température confortable pour se nourrir';

  @override
  String get fcPhraseTemperatureNeg =>
      'l\'eau froide ralentit les poissons, qui se nourrissent peu';

  @override
  String get fcPhraseWindPos =>
      'un léger clapotis pousse la nourriture vers la berge';

  @override
  String get fcPhraseWindNeg =>
      'le vent fort lève des vagues et les poissons descendent en profondeur';

  @override
  String get fcPhraseCloudPos =>
      'les nuages atténuent la lumière, les poissons se nourrissent plus hardiment';

  @override
  String get fcPhraseCloudNeg =>
      'le soleil vif rend les poissons méfiants et ils se cachent';

  @override
  String get fcPhrasePrecipPos =>
      'un temps sec et stable rend les poissons prévisibles';

  @override
  String get fcPhrasePrecipNeg =>
      'la pluie trouble l\'eau et perturbe la pression';

  @override
  String get fcPhraseSeasonPos =>
      'pic saisonnier — les poissons se nourrissent intensément';

  @override
  String get fcPhraseSeasonNeg =>
      'creux saisonnier — le métabolisme des poissons est ralenti';

  @override
  String get fcPhraseMoonPos =>
      'phase lunaire active — un pic d\'activité solunaire';

  @override
  String get fcPhraseMoonNeg => 'phase lunaire faible — une accalmie solunaire';

  @override
  String get fcConfidenceHigh => 'Confiance élevée';

  @override
  String get fcConfidenceMedium => 'Confiance moyenne';

  @override
  String get fcConfidenceLow => 'Confiance faible';

  @override
  String get fcDayConditions => 'Météo du jour';

  @override
  String get fcPeriodNight => 'Nuit';

  @override
  String get fcPeriodMorning => 'Matin';

  @override
  String get fcPeriodDay => 'Jour';

  @override
  String get fcPeriodEvening => 'Soir';

  @override
  String get fcRateWeak => 'Faible';

  @override
  String get fcRateMid => 'Moyen';

  @override
  String get fcRateGood => 'Bon';

  @override
  String get fcRateGreat => 'Top';

  @override
  String get fcPeriodWhyTitle => 'Pourquoi cette note';

  @override
  String get fcPeriodTimeEffect => 'Moment de la journée';

  @override
  String get fcPeriodBaseTitle => 'Conditions de base';

  @override
  String get fcPeriodWater => 'Eau';

  @override
  String get fcTodAdjCaption => 'Ajustement selon l\'heure';

  @override
  String fcTodDawn(String sunrise) {
    return 'L\'aube vers $sunrise est le pic d\'alimentation de la journée, ce créneau passe donc au-dessus du niveau de journée.';
  }

  @override
  String fcTodDusk(String sunset) {
    return 'Le crépuscule vers $sunset — les poissons se nourrissent activement avant la nuit, la note est donc relevée.';
  }

  @override
  String fcTodWarmNight(String water, String warm) {
    return 'L\'eau $water est au niveau de nuit chaude ($warm) ou au-dessus ; les poissons continuent de se nourrir la nuit et la note nocturne reste proche de celle du jour.';
  }

  @override
  String fcTodMidNight(String water, String cold, String warm) {
    return 'L\'eau $water se situe entre le seuil froid ($cold) et celui de nuit chaude ($warm) : la nuit, l\'activité est partielle, et plus l\'eau est chaude, plus la nuit est active.';
  }

  @override
  String fcTodColdNight(String water, String cold) {
    return 'L\'eau $water est sous le seuil froid ($cold) : en eau froide les poissons bougent à peine la nuit, la note descend donc nettement sous celle du jour.';
  }

  @override
  String fcTodMiddayHot(String temp, String heat) {
    return 'À midi il fait chaud ($temp, au-dessus de $heat) — les poissons se réfugient à l\'ombre et en profondeur, l\'activité baisse.';
  }

  @override
  String fcTodColdDay(String water, String cold) {
    return 'L\'eau est froide ($water, au plus $cold) ; le réchauffement diurne fait de midi le meilleur moment relatif.';
  }

  @override
  String get fcTodDayNeutral =>
      'Heures de journée entre les pics de l\'aube et du crépuscule — activité calme et moyenne.';

  @override
  String get spawnTitle => 'Fenêtre de frai';

  @override
  String spawnPreSpawn(String water) {
    return 'Eau à $water et en hausse vers la plage de frai — on dirait l\'approche du frai.';
  }

  @override
  String spawnSpawning(String water) {
    return 'Eau à $water, dans la plage de frai de l\'espèce — on dirait le frai.';
  }

  @override
  String spawnPostSpawn(String water) {
    return 'Eau à $water ayant dépassé la plage de frai — le frai semble terminé.';
  }

  @override
  String get spawnImpactPreSpawn =>
      'Avant le frai, une ruée alimentaire est fréquente — les touches sont souvent élevées (≈70–90 sur 100). Pêchez tant que la fenêtre est ouverte.';

  @override
  String get spawnImpactSpawning =>
      'L\'indice ci-dessus ne tient pas compte du frai. S\'il est vraiment en cours, les touches réelles sont bien plus faibles — généralement ≈10–20 sur 100, pendant plusieurs jours.';

  @override
  String get spawnImpactPostSpawn =>
      'Après le frai vient souvent une ruée alimentaire — les touches repartent à la hausse (≈70–90 sur 100).';

  @override
  String get spawnCaveatEstimated =>
      'Ceci prévoit la fenêtre, pas une date exacte — le frai se déroule différemment et par vagues sur chaque plan d\'eau, et nous estimons l\'eau à partir de l\'air.';

  @override
  String get spawnCaveatRough =>
      'Une prévision grossière : plan d\'eau vaste et inerte, le frai diffère partout et l\'eau est estimée à partir de l\'air — les dates peuvent varier sensiblement.';

  @override
  String get moonNew => 'Nouvelle lune';

  @override
  String get moonWaxing => 'Croissante';

  @override
  String get moonFull => 'Pleine lune';

  @override
  String get moonWaning => 'Décroissante';

  @override
  String get fcHowToFish => 'Comment pêcher aujourd\'hui';

  @override
  String get fcHowToFishTomorrow => 'Comment pêcher demain';

  @override
  String fcHowToFishOn(String date) {
    return 'Comment pêcher le $date';
  }

  @override
  String get fcWhenTitle => 'Quand';

  @override
  String get fcWindowsLabel => 'Fenêtres de mordant';

  @override
  String get fcWindowDawn => 'mordant du matin (aube)';

  @override
  String get fcWindowDusk => 'mordant du soir (crépuscule)';

  @override
  String get fcWindowNight => 'mordant de nuit';

  @override
  String get fcWindowMorning => 'matin';

  @override
  String get fcWindowEvening => 'soir';

  @override
  String get fcWindowDay => 'midi';

  @override
  String get fcWindowsWhyDawn =>
      'La carpe se nourrit surtout à l\'aube et au crépuscule.';

  @override
  String get fcWindowsWhyNight =>
      'En eau chaude, la carpe se nourrit activement la nuit.';

  @override
  String get fcWindowsWhyDay =>
      'Une météo douce en journée garde le poisson actif.';

  @override
  String get fcVerdictVeryLow =>
      'Journée difficile — le mordant est mou, mieux vaut peut-être s\'abstenir.';

  @override
  String get fcVerdictLow =>
      'Mordant faible. Si tu y vas — pêche précis et patient.';

  @override
  String get fcVerdictMedium =>
      'Une journée moyenne — sans garantie, mais il y a une chance.';

  @override
  String fcVerdictMediumWindow(String from, String to) {
    return 'Il y a une chance — tente la fenêtre $from–$to.';
  }

  @override
  String get fcVerdictGood => 'Bonne journée — garde un appât dans l\'eau.';

  @override
  String fcVerdictGoodWindow(String from, String to) {
    return 'Ça vaut le coup. Meilleur moment — $from–$to.';
  }

  @override
  String get fcVerdictExcellent => 'Journée excellente — ça mord !';

  @override
  String fcVerdictExcellentWindow(String from, String to) {
    return 'Journée excellente ! Ne manque pas la fenêtre $from–$to.';
  }

  @override
  String get fcLevelVeryLow => 'Très faible';

  @override
  String get fcLevelLow => 'Faible';

  @override
  String get fcLevelMedium => 'Modéré';

  @override
  String get fcLevelGood => 'Bon';

  @override
  String get fcLevelExcellent => 'Excellent';

  @override
  String get fcFactorPressure => 'Pression';

  @override
  String get fcFactorTemperature => 'Temp. eau';

  @override
  String get fcFactorWind => 'Vent';

  @override
  String get fcFactorCloud => 'Nébulosité';

  @override
  String get fcFactorPrecipitation => 'Précipitations';

  @override
  String get fcFactorSeason => 'Saison';

  @override
  String get fcFactorMoon => 'Lune';

  @override
  String get fcCondClear => 'Dégagé';

  @override
  String get fcCondPartly => 'Partiellement nuageux';

  @override
  String get fcCondCloudy => 'Nuageux';

  @override
  String get fcCondRain => 'Pluie';

  @override
  String get fcCondStorm => 'Orage';

  @override
  String get fcChipPressure => 'Pression';

  @override
  String get fcChipWind => 'Vent';

  @override
  String get fcChipWater => 'Eau';

  @override
  String get fcChipTemp => 'Température';

  @override
  String get fcChipMoon => 'Lune';

  @override
  String get fishCarp => 'Carpe';

  @override
  String get fishCrucian => 'Carassin';

  @override
  String get fishSheetTitle => 'Poisson';

  @override
  String get fcUnitHpaSuffix => 'hPa';

  @override
  String get fcUnitMmHgSuffix => 'mmHg';

  @override
  String get fcUnitMsSuffix => 'm/s';

  @override
  String get fcUnitKmhSuffix => 'km/h';

  @override
  String get fcWindCalm => 'Calme';

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
  String get fcWindSW => 'SO';

  @override
  String get fcWindW => 'O';

  @override
  String get fcWindNW => 'NO';

  @override
  String get tabAdvice => 'Tactique';

  @override
  String get adviceHeadline => 'Tactique suggérée';

  @override
  String get adviceDisclaimer =>
      'Conseils d\'après la prévision météo, pas pour un plan d\'eau précis.';

  @override
  String get adviceKindBait => 'Appât';

  @override
  String get adviceKindFeeding => 'Amorçage';

  @override
  String get adviceKindDepth => 'Profondeur';

  @override
  String get adviceKindLocation => 'Poste';

  @override
  String get adviceKindTiming => 'Moment';

  @override
  String adviceWhyWater(String value) {
    return 'eau $value';
  }

  @override
  String get adviceWhyWaterRising => 'l\'eau se réchauffe de jour en jour';

  @override
  String get adviceWhyWaterFalling => 'l\'eau se refroidit de jour en jour';

  @override
  String adviceWhyAirHot(String value) {
    return 'chaud — air $value';
  }

  @override
  String adviceWhyWind(String value) {
    return 'vent $value';
  }

  @override
  String get adviceWhyWindLight => 'vent léger';

  @override
  String get adviceWhyPressureFalling => 'la pression baisse';

  @override
  String get adviceWhyRain => 'pluie dans la journée';

  @override
  String get adviceWhyBottomHabit => 'eau douce — la carpe tient près du fond';

  @override
  String get adviceWhyBiteHigh => 'indice de mordant élevé';

  @override
  String get adviceWhyBiteMid => 'indice de mordant moyen';

  @override
  String get adviceWhyBiteLow => 'indice de mordant faible';

  @override
  String get adviceWhyBestHours => 'l\'indice culmine à cette heure';

  @override
  String get windFullN => 'du nord';

  @override
  String get windFullNE => 'du nord-est';

  @override
  String get windFullE => 'de l\'est';

  @override
  String get windFullSE => 'du sud-est';

  @override
  String get windFullS => 'du sud';

  @override
  String get windFullSW => 'du sud-ouest';

  @override
  String get windFullW => 'de l\'ouest';

  @override
  String get windFullNW => 'du nord-ouest';

  @override
  String get adviceBaitColdBrightTitle => 'Appâts petits et vifs';

  @override
  String get adviceBaitColdBrightBody =>
      'Eau froide — maïs, asticots, petits pellets. La carpe mange peu et avec prudence.';

  @override
  String get adviceBaitMidBoiliesTitle => 'Bouillettes et pellets';

  @override
  String get adviceBaitMidBoiliesBody =>
      'L\'eau se réchauffe — bouillettes de 10–16 mm et pellets. La carpe est plus active.';

  @override
  String get adviceBaitWarmFishmealTitle => 'Bouillettes farine de poisson';

  @override
  String get adviceBaitWarmFishmealBody =>
      'Eau chaude, appétit maximal — bouillettes riches en farine de poisson, noix tigrées, maïs.';

  @override
  String get adviceBaitHotSurfaceTitle => 'Appâts flottants';

  @override
  String get adviceBaitHotSurfaceBody =>
      'La chaleur fait monter la carpe — pop-ups, pellets flottants, un peu de pain.';

  @override
  String get adviceBaitWarmingTitle => 'Plus gros et parfumé';

  @override
  String get adviceBaitWarmingBody =>
      'Tendance au réchauffement — la carpe s\'active. Bouillettes, noix tigrées, appâts aromatisés.';

  @override
  String get adviceBaitCoolingTitle => 'Plus petit et vif';

  @override
  String get adviceBaitCoolingBody =>
      'L\'eau baisse — le poisson devient prudent. Petits pellets, maïs, asticots.';

  @override
  String get adviceFeedMinimalTitle => 'Amorce avec parcimonie';

  @override
  String get adviceFeedMinimalBody =>
      'Juste quelques poignées, serrées — ne suralimente pas un poisson inactif.';

  @override
  String get adviceFeedModerateTitle => 'Amorce modérément';

  @override
  String get adviceFeedModerateBody =>
      'Volume moyen ; recharge régulièrement en petites quantités.';

  @override
  String get adviceFeedHeavyTitle => 'Amorce abondamment';

  @override
  String get adviceFeedHeavyBody =>
      'La carpe mange fort — un tapis de départ plus large et des rappels fréquents paient.';

  @override
  String get adviceRigBottomTitle => 'Pêcher au fond';

  @override
  String get adviceRigBottomBody =>
      'Montage au fond, posé ou près des structures — le montage carpe classique.';

  @override
  String get adviceRigZigTitle => 'Essaie un zig rig';

  @override
  String get adviceRigZigBody =>
      'Le poisson tient entre deux eaux — un zig à 1–2 m du fond peut marquer.';

  @override
  String get adviceRigSurfaceTitle => 'Pêcher en surface';

  @override
  String get adviceRigSurfaceBody =>
      'La carpe lézarde près de la surface — montage de surface et appât flottant.';

  @override
  String get adviceSwimWindwardTitle => 'Pêcher dans le vent';

  @override
  String adviceSwimWindwardBody(String dir) {
    return 'Un vent $dir pousse l\'eau chaude de surface et la nourriture vers la rive opposée ; c\'est là que la carpe se nourrit.';
  }

  @override
  String get adviceSwimCalmFeaturesTitle => 'Vise les structures';

  @override
  String get adviceSwimCalmFeaturesBody =>
      'Vent léger — travaille les cassures, les obstacles, les roseaux et les ruptures de profondeur.';

  @override
  String get adviceSwimShelteredTitle => 'Au fond ou à l\'ombre';

  @override
  String get adviceSwimShelteredBody =>
      'Par forte chaleur, cherche l\'eau profonde plus fraîche et les zones ombragées.';

  @override
  String get adviceTimePressureDropTitle => 'Fenêtre avant le front';

  @override
  String get adviceTimePressureDropBody =>
      'La pression baisse — une phase d\'alimentation est probable. Ne manque pas les prochaines heures.';

  @override
  String get adviceTimeBestWindowTitle => 'Meilleure fenêtre du jour';

  @override
  String adviceTimeBestWindowBody(String from, String to) {
    return 'Activité maximale vers $from–$to. Sois sur ton poste un peu en avance.';
  }

  @override
  String get adviceTimeDawnDuskTitle => 'Aube et crépuscule';

  @override
  String get adviceTimeDawnDuskBody =>
      'Mise sur le petit matin et la fin de soirée — le mordant le plus fiable.';

  @override
  String get adviceTimeAllDayTitle => 'Active toute la journée';

  @override
  String get adviceTimeAllDayBody =>
      'Indice élevé — la carpe se nourrit toute la journée ; garde un appât dans l\'eau.';

  @override
  String get adviceTimeSlowPatientTitle => 'Sois patient';

  @override
  String get adviceTimeSlowPatientBody =>
      'Le poisson est mou — présentation précise, montages plus fins, attends une fenêtre.';

  @override
  String get crucianBaitColdAnimalTitle => 'Appât animal';

  @override
  String get crucianBaitColdAnimalBody =>
      'Eau froide — petits vers de vase et asticots. Une ou deux larves à la fois ; le carassin mange lentement.';

  @override
  String get crucianBaitWarmingTitle => 'Ver et asticot';

  @override
  String get crucianBaitWarmingBody =>
      'L\'eau se réchauffe — le carassin s\'active. Ver de terreau, une grappe d\'asticots, vers de vase.';

  @override
  String get crucianBaitCoolingTitle => 'Plus petit et tendre';

  @override
  String get crucianBaitCoolingBody =>
      'Refroidissement — le carassin devient capricieux. Petits vers de vase ou un sandwich, appât plus tendre.';

  @override
  String get crucianBaitSandwichTitle => 'Appât sandwich';

  @override
  String get crucianBaitSandwichBody =>
      'Eau de transition — un sandwich : asticot avec orge perlé ou maïs. Le carassin fait le difficile.';

  @override
  String get crucianBaitWarmPlantTitle => 'Appât végétal';

  @override
  String get crucianBaitWarmPlantBody =>
      'Eau chaude — orge perlé, pâte de semoule, maïs, pâte. Le carassin passe aux appâts végétaux.';

  @override
  String get crucianBaitHotDoughTitle => 'Pâte molle';

  @override
  String get crucianBaitHotDoughBody =>
      'Chaleur — pâte molle, pâte de semoule, mie de pain. Un appât sucré et léger dans la couche supérieure.';

  @override
  String get crucianFeedTinyTitle => 'Amorce serré';

  @override
  String get crucianFeedTinyBody =>
      'Le carassin est craintif et se rassasie vite — quelques pincées d\'amorce fine et sucrée, pas plus.';

  @override
  String get crucianFeedSweetTitle => 'Amorce sucrée';

  @override
  String get crucianFeedSweetBody =>
      'Mélange fin parfumé à l\'ail ou à la vanille ; recharge peu et souvent, sans suralimenter.';

  @override
  String get crucianFeedActiveTitle => 'Amorce activement';

  @override
  String get crucianFeedActiveBody =>
      'Le carassin mange bien — recharge plus souvent mais en petites quantités pour tenir le banc.';

  @override
  String get crucianRigFloatBottomTitle => 'Flotteur au fond';

  @override
  String get crucianRigFloatBottomBody =>
      'Le montage carassin classique — pêche au flotteur, appât posé ou effleurant le fond.';

  @override
  String get crucianRigDropperTitle => 'Plombée de chute';

  @override
  String get crucianRigDropperBody =>
      'Le carassin est monté entre deux eaux — appât à descente lente, étale la plombée, pêche à la chute.';

  @override
  String get crucianRigShallowTitle => 'Peu profond près du haut';

  @override
  String get crucianRigShallowBody =>
      'Par chaleur le carassin lézarde dans le peu profond — montage léger, appât dans la couche chaude de surface.';

  @override
  String get crucianSwimReedsTitle => 'Bordure de roseaux';

  @override
  String get crucianSwimReedsBody =>
      'Travaille les trouées dans l\'herbier, les bordures de roseaux et les zones envahies — c\'est là que le carassin se nourrit.';

  @override
  String get crucianSwimWarmShallowsTitle => 'Hauts-fonds chauds';

  @override
  String get crucianSwimWarmShallowsBody =>
      'L\'eau est froide — cherche les hauts-fonds les plus chauds et les baies chauffées par le soleil.';

  @override
  String get crucianSwimDeepEdgeTitle => 'Cassure profonde et ombre';

  @override
  String get crucianSwimDeepEdgeBody =>
      'Par chaleur le carassin quitte le peu profond — pêche les fosses, les cassures et les zones ombragées.';

  @override
  String get crucianTimePressureDropTitle => 'Sois patient';

  @override
  String get crucianTimePressureDropBody =>
      'La pression baisse — le carassin devient capricieux et passif. Petits appâts tendres, attends de courtes phases.';

  @override
  String get crucianTimeBestWindowTitle => 'Meilleure fenêtre du jour';

  @override
  String crucianTimeBestWindowBody(String from, String to) {
    return 'Activité maximale vers $from–$to. Sois sur ton poste un peu en avance.';
  }

  @override
  String get crucianTimeMorningTitle => 'Mordant du matin';

  @override
  String get crucianTimeMorningBody =>
      'Mise sur le petit matin — la phase classique du carassin, avant la chaleur.';

  @override
  String get crucianTimeStableWarmTitle => 'Actif aussi en journée';

  @override
  String get crucianTimeStableWarmBody =>
      'Chaleur stable — le carassin se nourrit toute la journée ; garde un appât dans l\'eau.';

  @override
  String get crucianTimePatientTitle => 'Précis et patient';

  @override
  String get crucianTimePatientBody =>
      'Le carassin est passif — montage fin, petit appât, travaille un poste et attends une phase.';

  @override
  String get spotTitle => 'Ton spot';

  @override
  String get spotNoWater =>
      'Aucun plan d\'eau près de ce point sur la carte. La météo fonctionne quand même — place un spot pour analyser l\'eau.';

  @override
  String get spotSetOnMap => 'Placer le spot sur la carte';

  @override
  String get spotCheckFailed =>
      'Impossible de consulter la carte pour l\'instant — la météo fonctionne toujours.';

  @override
  String get spotTypeLake => 'Lac';

  @override
  String get spotTypePond => 'Étang';

  @override
  String get spotTypeReservoir => 'Réservoir';

  @override
  String get spotTypeRiver => 'Rivière';

  @override
  String get spotTypeCanal => 'Canal';

  @override
  String get spotTypeWater => 'Plan d\'eau';

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
    return 'Un vent doux pousse la nourriture et l\'eau plus chaude vers la berge sous le vent — les poissons y sont sans doute plus actifs. Berge active : $bank.';
  }

  @override
  String spotTipSheltered(String bank) {
    return 'Le vent est plus froid que l\'eau — les poissons quittent la berge exposée pour l\'eau calme. Berge abritée : $bank.';
  }

  @override
  String get spotTipNoWind =>
      'Presque pas de vent — aucune berge ne se distingue aujourd\'hui ; les poissons se répartissent sur les structures et les profondeurs.';

  @override
  String get spotTipColdWater =>
      'Eau froide — les poissons restent au fond, profonds et apathiques ; le vent les déplace peu pour l\'instant.';

  @override
  String get spotWhereRiver =>
      'Cherche les eaux calmes : fosses, courbes extérieures, en aval des rapides, près des obstacles et des piles de pont.';

  @override
  String get spotWhereCanal =>
      'Un canal est uniforme — traque les anomalies : courbes, ponts, arrivées d\'eau et berges végétalisées.';

  @override
  String get spotWherePondSmall =>
      'Un petit plan d\'eau se réchauffe vite — les poissons tiennent près des roseaux, des obstacles et de la bordure, plus profond par forte chaleur.';

  @override
  String get spotWhereMid =>
      'Un plan d\'eau moyen — travaille les baies, les cassures et les zones végétalisées.';

  @override
  String get spotWhereLarge =>
      'Un grand plan d\'eau — les poissons se déplacent ; vise les pointes, les cassures et suis le vent.';

  @override
  String get spotWhereUnknown =>
      'Eau calme — vise les roseaux, les obstacles, les cassures et les baies.';

  @override
  String get spotStructInflow =>
      'Un ruisseau ou un canal se jette tout près — le courant apporte nourriture et oxygène ; un poste de choix, surtout par forte chaleur.';

  @override
  String get spotStructReeds =>
      'Ici la berge est bordée de roseaux ou de marais — abri et garde-manger pour la carpe.';

  @override
  String get spotStructDam =>
      'Un barrage ou une digue est tout proche — une cassure nette de profondeur et un poste classique.';

  @override
  String spotStructIslands(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Il y a $count îles sur ce plan d\'eau — les poissons tiennent souvent autour : structure, cassures de profondeur et abri.',
      one:
          'Il y a une île sur ce plan d\'eau — les poissons tiennent souvent autour des îles : structure, cassures de profondeur et abri.',
    );
    return '$_temp0';
  }

  @override
  String get spotSourceType => 'pour ce type de plan d\'eau';

  @override
  String get spotEditTitle => 'Position du spot';

  @override
  String get spotEditHint =>
      'Déplace la carte pour poser le repère — mets-le sur la bonne berge si besoin.';

  @override
  String get spotSavePosition => 'Enregistrer la position';

  @override
  String get spotViewOnMap => 'Voir sur la carte';

  @override
  String get spotWindLabel => 'Vent';

  @override
  String spotWindFrom(String dir) {
    return 'Vent $dir';
  }

  @override
  String get spotDirN => 'du nord';

  @override
  String get spotDirNE => 'du nord-est';

  @override
  String get spotDirE => 'd\'est';

  @override
  String get spotDirSE => 'du sud-est';

  @override
  String get spotDirS => 'du sud';

  @override
  String get spotDirSW => 'du sud-ouest';

  @override
  String get spotDirW => 'd\'ouest';

  @override
  String get spotDirNW => 'du nord-ouest';

  @override
  String get spotUserHere =>
      'Ton spot est déjà sur la berge active — tu es au bon endroit.';

  @override
  String get spotUserOpposite =>
      'Ton spot est de l\'autre côté — ça peut mieux mordre sur la berge opposée.';

  @override
  String get spotSourceMap => 'D\'après les données OpenStreetMap';

  @override
  String get spotSourceWind => 'd\'après le vent et la température de l\'eau';

  @override
  String get spotDisclaimer =>
      'Une lecture des conditions d\'après la carte et la météo — nous ne voyons ni la profondeur, ni le fond, ni le stock de poissons.';

  @override
  String get settingsAlertsPrimeTitle => 'Le meilleur jour de la semaine';

  @override
  String get settingsAlertsPrimeSubtitle =>
      'Un signal sur le meilleur jour de touche de la semaine sur tes spots';

  @override
  String get settingsAlertsExcellentTitle => 'Tous les jours excellents';

  @override
  String get settingsAlertsExcellentSubtitle =>
      'Un signal la veille de chaque jour où ça mord parfaitement';

  @override
  String get settingsAlertsForCarp => 'Notifications carpe';

  @override
  String get settingsAlertsForCrucian => 'Notifications carassin';

  @override
  String alertTitlePrime(String fish) {
    return '$fish : le meilleur jour de la semaine';
  }

  @override
  String alertTitleExcellent(String fish) {
    return '$fish : demain ça mord parfaitement';
  }

  @override
  String get alertWindowDawn => 'demain à l\'aube';

  @override
  String get alertWindowDusk => 'demain au crépuscule';

  @override
  String get alertWindowDay => 'demain en journée';

  @override
  String get alertWindowNight => 'demain la nuit';

  @override
  String get alertWindowAny => 'demain';

  @override
  String get alertSpotFallback => 'Ton spot';

  @override
  String get tabTips => 'Astuces';

  @override
  String get tipsNext => 'Autre astuce';

  @override
  String get tipLocationFirstTitle => 'Le poste compte plus que l’appât';

  @override
  String get tipLocationFirstBody =>
      'L’erreur de débutant la plus courante : arriver et lancer « nulle part ». Les carpistes expérimentés sont unanimes — savoir OÙ sont les poissons compte plus que savoir AVEC QUOI pêcher ; au mauvais poste, aucun appât ne sauve. Une heure passée à trouver des poissons qui s’alimentent (sauts, chapelets de bulles, poissons en surface) rapporte plus que dix heures à l’aveugle derrière les détecteurs. Observe l’eau 15–20 minutes d’abord, puis installe-toi.';

  @override
  String get tipLocationFirstProof =>
      'La presse carpiste qualifie la lecture de l’eau du plus grand atout : « au mauvais endroit tu ne prends rien, point ».';

  @override
  String get tipMarginsTitle =>
      'Pêche les bordures — la tactique la plus sous-estimée';

  @override
  String get tipMarginsBody =>
      'La plupart lancent le plus loin possible et ignorent l’eau sous leurs pieds. Or la carpe patrouille la bordure chaque jour et chaque nuit, sur tous les plans d’eau. Cas connu : ceux qui pêchaient en bordure ont pris deux fois plus que ceux qui lançaient au milieu. Bonus — on voit le poisson, on présente l’appât à un sujet précis et on apprend de son comportement. Approche-toi de la berge en silence.';

  @override
  String get tipMarginsProof =>
      'Les guides classent la pêche en bordure parmi les tactiques carpe les plus sous-estimées.';

  @override
  String get tipSharpHooksTitle => 'Un hameçon émoussé, c’est un poisson perdu';

  @override
  String get tipSharpHooksBody =>
      'C’est ce que les débutants négligent le plus. L’écart entre piquant et piquant comme une aiguille est énorme : plus de touches deviennent des départs, plus de départs deviennent des prises solides. L’hameçon s’émousse non seulement sur les pierres et les moules, mais même en restant posé sur le fond. Vérifie la pointe avant CHAQUE lancer (test de l’ongle) et change-la au moindre signe d’usure.';

  @override
  String get tipSharpHooksProof =>
      'Les experts s’accordent : le piquant réduit fortement les décrochages et augmente le taux de ferrage.';

  @override
  String get tipDontOverfeedTitle => 'Ne suramorce pas le poste';

  @override
  String get tipDontOverfeedBody =>
      'La deuxième erreur classique. Trop d’amorce disperse les poissons sur une grande surface et les éloigne de ton montage, et une carpe rassasiée ignore ton esche. Mieux vaut peu mais précis — de petites quantités sur un point serré. Le suramorçage est une cause fréquente de bredouille même quand le poisson est là.';

  @override
  String get tipDontOverfeedProof =>
      'Le suramorçage arrive en tête des listes d’erreurs courantes en pêche de la carpe.';

  @override
  String get tipBaitRegularlyTitle =>
      'Amorcer régulièrement vaut mieux que de grosses doses';

  @override
  String get tipBaitRegularlyBody =>
      'Si tu peux, pré-amorce ton poste à l’avance et souvent. Un kilo chaque jour marche mieux que cinq kilos tous les cinq jours. La régularité apprend à la carpe à revenir chercher un repas gratuit sans crainte — et quand tu pêches enfin, les touches sont franches. Garde un seul appât sur la campagne : les poissons apprennent à le chercher et s’y fixent souvent.';

  @override
  String get tipBaitRegularlyProof =>
      'Fabricants d’appâts et guides d’amorçage sont unanimes : la clé est la régularité, moins mais plus souvent.';

  @override
  String get tipHairRigTitle => 'Le montage « cheveu » — pourquoi il prend';

  @override
  String get tipHairRigBody =>
      'La carpe n’avale pas d’un coup : elle teste l’appât, l’aspire et le recrache. Sur l’hameçon même, elle sent le métal et le recrache avec l’appât. Sur le « cheveu », l’appât est séparé de l’hameçon nu : à l’aspiration, l’hameçon glisse librement dans la bouche et accroche la lèvre inférieure. Depuis les années 1980, ce principe a transformé le taux de ferrage et est devenu la base de la pêche moderne de la carpe.';

  @override
  String get tipHairRigProof =>
      'Classique éprouvé depuis des décennies ; le principe aspirer et tester fonde tout montage carpe moderne.';

  @override
  String get tipSweetcornTitle => 'Le maïs doux — bon marché et redoutable';

  @override
  String get tipSweetcornBody =>
      'Le maïs doux prend des carpes partout dans le monde : vif, sucré, tendre et riche en acides aminés, la carpe l’accepte comme une nourriture naturelle. Et ça coûte trois fois rien : le même poids de bouillettes vaut bien plus cher. Il donne souvent un résultat instantané là où la carpe se nourrit surtout de nourriture naturelle.';

  @override
  String get tipSweetcornProof =>
      'Le maïs est cité parmi les appâts les plus abordables et efficaces ; l’écart de prix avec les bouillettes est de plusieurs dizaines de fois.';

  @override
  String get tipMixedSizesTitle => 'Varie la taille des appâts';

  @override
  String get tipMixedSizesBody =>
      'Mélange les tailles de bouillettes (par ex. 12–15 mm et 18–22 mm) pour que la carpe ne se cale pas sur un calibre et ne devienne pas méfiante — la chance qu’elle prenne ton esche augmente. Petit (12–15 mm) pour l’hiver et les eaux pressionnées, gros (18–22 mm) contre les indésirables et pour les gros sujets.';

  @override
  String get tipMixedSizesProof =>
      'Les tailles mélangées sont une astuce classique pour casser la sélectivité de taille du poisson.';

  @override
  String get tipFallingPressureTitle =>
      'Pression en baisse — une fenêtre d’activité';

  @override
  String get tipFallingPressureBody =>
      'À l’approche d’un front, quand la pression baisse, le poisson se nourrit souvent davantage. La carpe réagit plus doucement que les carnassiers (poisson de fond, moins sensible), mais les pêcheurs notent qu’à basse pression elle mange plus longtemps et plus volontiers. La meilleure fenêtre est 6–12 heures avant le front. Important : il n’y a pas de chiffre magique de pression — c’est la TENDANCE à la baisse qui agit, pas une valeur.';

  @override
  String get tipFallingPressureProof =>
      'Des observations de magazines ont relevé jusqu’à ~40% d’activité en plus à pression descendante ; mais l’étude la plus citée (1983, perche) n’a trouvé qu’une faible corrélation — d’où l’honnêteté de parler de tendance, pas de garantie.';

  @override
  String get tipCrucianShyBitesTitle =>
      'Le carassin est un goûteur timide : noie l’antenne';

  @override
  String get tipCrucianShyBitesBody =>
      'La touche du carassin peut être à peine visible — un quart d’enfoncement d’une fine antenne. Si trop d’antenne dépasse, tu rates les touches délicates. Plombe le flotteur à ras, en ne laissant que le minimum dehors. Le carassin recrache l’appât dès qu’il sent une résistance — tout doit être léger et sensible.';

  @override
  String get tipCrucianShyBitesProof =>
      'Les guides carassin sont unanimes : noie l’antenne ; une antenne fine enregistre les touches timides.';

  @override
  String get tipCrucianFineTackleTitle => 'Carassin : fin et petit';

  @override
  String get tipCrucianFineTackleBody =>
      'Fil épais et gros hameçons sont à proscrire. Prends un hameçon fin mais solide de petite taille : 18–20 pour asticot/caster, 16 pour maïs/pellet. Ne suramorce pas (tanches et brèmes débarquent) : commence par des boules d’amorce de la taille d’une balle de golf et quelques échantillons d’esche, et n’ajoute que si ça mord bien.';

  @override
  String get tipCrucianFineTackleProof =>
      'Conseil standard pour le carassin — matériel fin, petit hameçon, amorçage dosé.';

  @override
  String get tipCrucianSlowFallTitle => 'Le carassin prend l’appât qui descend';

  @override
  String get tipCrucianSlowFallBody =>
      'Il mord souvent pendant que l’appât coule lentement. Répartis les petits plombs régulièrement pour une descente lente, et place le dernier minuscule plomb témoin à seulement 5–7 cm de l’hameçon — il signale vite une touche timide.';

  @override
  String get tipCrucianSlowFallProof =>
      'Une descente lente plus un plomb témoin près de l’hameçon est une tactique typique du carassin.';

  @override
  String get tipWaterTempTitle => 'L’eau compte plus que le calendrier';

  @override
  String get tipWaterTempBody =>
      'La carpe est à sang froid — l’appétit suit la température de l’EAU, pas la date. L’activité maximale se situe vers 18–24 °C ; en dessous de ~10 °C le métabolisme ralentit et l’alimentation s’arrête presque. En pratique : en eau froide, petit appât et pêche dans la chaleur de midi sur les hauts-fonds ; par forte chaleur, la nuit et à l’aube. N’attends pas de frénésie en eau glacée à midi.';

  @override
  String get tipWaterTempProof =>
      'Biologie des cyprinidés : le métabolisme dépend directement de la température de l’eau — d’où la chute du mordant en hiver.';

  @override
  String get tipPvaBagTitle => 'Sac PVA — une bouchée juste près de l’hameçon';

  @override
  String get tipPvaBagBody =>
      'Un sac PVA soluble rempli de pellets ou de miettes, enfilé sur l’hameçon, dépose un petit tas d’appât exactement là où ton esche se pose. Il fond en quelques minutes, laissant une tache attractive et une présentation sans emmêlement au lancer. Il excelle sur la vase et dans les herbiers, où une esche isolée se perd — la carpe trouve une « table » et mange juste au-dessus du montage.';

  @override
  String get tipPvaBagProof =>
      'Le matériel PVA est un standard de la pêche moderne de la carpe pour placer l’amorce précisément à l’hameçon.';

  @override
  String get tipFeatureFindingTitle =>
      'Trouve les structures — la carpe longe les cassures';

  @override
  String get tipFeatureFindingBody =>
      'Les poissons ne sont pas répartis uniformément — ils se tiennent près des structures : cassures, changements de profondeur, fond dur dans la vase, bordures d’herbiers, obstacles. Avant de pêcher, « sonde » le fond avec un plomb : traîne-le et sens comment le sol change, compte la profondeur à la descente. Un lancer sur une structure trouvée bat le lancer au hasard « pour la distance ».';

  @override
  String get tipFeatureFindingProof =>
      'Sonder les structures au marqueur ou au plomb est une compétence de base — la carpe longe les structures, pas le vide ouvert.';

  @override
  String get tipStayQuietTitle =>
      'Silence sur la berge — la carpe est farouche';

  @override
  String get tipStayQuietBody =>
      'La carpe perçoit les vibrations par la ligne latérale et « entend » avec le corps. Des pas lourds, des portes claquées, des coups sur la barque, un lancer lourd à tes pieds — et les poissons quittent les hauts-fonds et les bordures. Approche-toi de l’eau en silence, garde la lumière hors de la surface, installe-toi doucement. C’est crucial en pêchant la bordure et les hauts-fonds.';

  @override
  String get tipStayQuietProof =>
      'La ligne latérale de la carpe capte le moindre mouvement — un bruit fort met réellement le poisson en alerte.';

  @override
  String get tipParticlesTitle => 'Les graines (chènevis) retiennent le banc';

  @override
  String get tipParticlesBody =>
      'Les petites graines comme le chènevis créent une tache qui fait fouiller la carpe et manger sur un point sans se rassasier vite — les poissons s’attardent au-dessus du montage. Note de sécurité : les graines sèches (surtout les noix tigrées et les légumineuses) doivent être trempées ET cuites à point avant usage — mal cuites, elles peuvent nuire au poisson.';

  @override
  String get tipParticlesProof =>
      'Le chènevis est un classique pour retenir un banc ; bien préparer les graines est une règle de sécurité bien connue pour le poisson.';

  @override
  String get tipFishCareTitle => 'Préserve le poisson — il remordra';

  @override
  String get tipFishCareBody =>
      'Une grosse carpe met des décennies à grandir et peut être reprise — si elle est relâchée en bonne santé. Mains mouillées et tapis ou herbe humide, un minimum de temps hors de l’eau, ne pose jamais le poisson sur du sable ou des pierres secs, décroche en douceur (une raison de plus de garder l’hameçon piquant). Photos basses au-dessus du tapis, rapides. Une carpe relâchée en bonne santé est une touche future — pour toi et les autres.';

  @override
  String get tipFishCareProof =>
      'Principes du no-kill chez les carpistes : une manipulation soigneuse préserve le cheptel et tes prises futures.';

  @override
  String get tipCrucianWarmShallowsTitle =>
      'Le carassin aime les hauts-fonds chauds';

  @override
  String get tipCrucianWarmShallowsBody =>
      'Le carassin aime la chaleur et les herbiers. Au printemps et au début de l’été, il vient se nourrir d’abord dans les hauts-fonds réchauffés — petites criques, près des roseaux et des nénuphars, où l’eau est plus chaude de quelques degrés. Cherche des zones calmes, herbeuses, bien réchauffées ; en profondeur il n’y a presque pas de carassin à cette période. Plus l’eau est chaude, plus le carassin est actif.';

  @override
  String get tipCrucianWarmShallowsProof =>
      'Le carassin est un poisson d’herbiers qui aime la chaleur ; le réchauffement précoce des hauts-fonds explique pourquoi il s’y nourrit d’abord.';

  @override
  String get fcAlgoFactsTitle => 'Le saviez-vous sur l’algorithme';

  @override
  String get fcAlgoFactLabel => 'Le fait du jour';

  @override
  String get algoFactWaterModelTitle => 'On calcule avec l’eau, pas avec l’air';

  @override
  String get algoFactWaterModelBody =>
      'La carpe vit dans l’eau, qui se réchauffe avec un décalage. Plutôt que de prendre la température de l’air directement, on modélise celle de l’eau par une équation d’échange thermique — comme une tasse de thé qui refroidit.';

  @override
  String get algoFactThermalInertiaTitle =>
      'Chaque plan d’eau a sa propre inertie thermique';

  @override
  String get algoFactThermalInertiaBody =>
      'Une rivière réagit à la météo en quelques jours, un étang plus lentement, et un grand réservoir met des semaines à bouger. On règle donc la vitesse de réchauffement selon le type et la taille du plan d’eau.';

  @override
  String get algoFactPressureTrendTitle =>
      'C’est la tendance de pression, pas le niveau';

  @override
  String get algoFactPressureTrendBody =>
      'La meilleure touche ne vient pas à une pression ‹ bonne ›, mais lors d’une baisse douce avant un front. Une chute brutale comme une hausse brutale sont pénalisées. On lit la tendance sur 6 et sur 24 heures.';

  @override
  String get algoFactFrontMemoryTitle =>
      'On garde en mémoire un front passé pendant un jour';

  @override
  String get algoFactFrontMemoryBody =>
      'Même une fois la pression revenue, les poissons restent sous le choc après un front froid. On maintient une pénalité propre pendant une journée entière — la carpe met un à deux jours à récupérer.';

  @override
  String get algoFactWeakestLinkTitle => 'Le principe du maillon faible';

  @override
  String get algoFactWeakestLinkBody =>
      'Beaucoup de calculateurs additionnent juste des points, si bien qu’une bonne pression ‹ rattrape › une eau glacée. Chez nous, température, saison et pression agissent comme des fusibles : aucun vent parfait ne sauve une eau morte.';

  @override
  String get algoFactHeatCalmTitle => 'Une pénalité pour chaleur et calme plat';

  @override
  String get algoFactHeatCalmBody =>
      'La baisse ne s’applique que quand chaleur et calme plat coïncident — c’est là que l’eau manque d’oxygène. Pris séparément, une journée chaude ou l’absence de vent sont moins nuisibles.';

  @override
  String get algoFactRealSunTitle => 'Des pics liés au vrai soleil';

  @override
  String get algoFactRealSunBody =>
      'Pas de ‹ touche à 6 h › figée. On prend le lever et le coucher réels du soleil pour ton spot, on renforce l’aube et le crépuscule, et on atténue le midi chaud.';

  @override
  String get algoFactSpawnPhysicsTitle =>
      'La fraie par la physique, pas par le calendrier';

  @override
  String get algoFactSpawnPhysicsBody =>
      'On déduit la phase de fraie de la température de l’eau et de la durée du jour à ta latitude. Et on reste honnête sur la confiance : sur un plan d’eau lent, le signal est flou.';

  @override
  String get algoFactSpeciesModelsTitle =>
      'Carpe et carassin sont deux modèles distincts';

  @override
  String get algoFactSpeciesModelsBody =>
      'Ce n’est pas une formule avec une case à cocher. Le carassin a un optimum de température plus haut, est plus sensible à la pression, aime un léger clapot et ne mord presque pas la nuit — des dizaines de paramètres sont réglés par espèce.';

  @override
  String get algoFactBiteWindowsTitle =>
      'Des fenêtres de touche, pas juste des heures';

  @override
  String get algoFactBiteWindowsBody =>
      'On regroupe les bonnes heures en fenêtres continues, on comble les creux d’une heure et on raccorde correctement les fenêtres qui passent minuit.';

  @override
  String alertBody(String spot, String when, int index) {
    return '$spot: $when, indice de touche $index';
  }
}
