// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get welcomeTitle => 'Bienvenido';

  @override
  String get welcomeSubtitle => 'Configuración rápida — menos de un minuto';

  @override
  String get welcomeCta => 'Empezar';

  @override
  String get languageSheetTitle => 'Idioma';

  @override
  String get languageSheetSubtitle => 'Elige tu idioma';

  @override
  String get themeSheetSubtitle => 'Elige cómo se ve la app';

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
  String get commonContinue => 'Continuar';

  @override
  String get quizQ1Question => '¿Qué pez buscas?';

  @override
  String get quizQ1Subtitle => 'Ajustaremos el pronóstico a tu pez';

  @override
  String get quizQ1OptLearn => 'Carpa';

  @override
  String get quizQ1OptHabit => 'Carpín';

  @override
  String get quizQ1OptSolve => 'Ambos';

  @override
  String get quizQ2Question => '¿Fuiste y sin picar?';

  @override
  String get quizQ2Subtitle => 'Sé sincero — así te ayudamos mejor';

  @override
  String get quizQ2OptDaily => 'Sí, más de una vez';

  @override
  String get quizQ2OptWeekly => 'A veces';

  @override
  String get quizQ2OptRarely => 'Casi siempre pico';

  @override
  String get quizQ3Question => '¿Cómo planeas salir?';

  @override
  String get quizQ3Subtitle => 'Define qué te mostramos primero';

  @override
  String get quizQ3OptSimple => 'Lo planifico';

  @override
  String get quizQ3OptResult => 'Voy de forma espontánea';

  @override
  String get quizQ3OptFlexible => 'Depende';

  @override
  String get quizQ4Question => '¿Con qué frecuencia?';

  @override
  String get quizQ4Subtitle => 'Te avisaremos de los mejores días';

  @override
  String get quizQ4OptWeekly => 'Cada semana';

  @override
  String get quizQ4OptMonthly => 'Un par de veces al mes';

  @override
  String get quizQ4OptRarely => 'De vez en cuando';

  @override
  String get onbAnalyzingTitle => 'Analizando condiciones';

  @override
  String get onbAnalyzingSubtitle => 'Calculando clima, presión y luna…';

  @override
  String get onbResultTitle => 'Tu pronóstico de picada está listo';

  @override
  String get onbResultSubtitle =>
      'La picada de hoy es gratis. El pronóstico de 7 días se desbloquea con la suscripción.';

  @override
  String get onbResultTodayBadge => 'Hoy · gratis';

  @override
  String get onbResultLockedLabel => 'Pronóstico de 7 días';

  @override
  String get onbResultCta => 'Ver mi pronóstico';

  @override
  String get paywallSkipToday => 'Primero ver hoy gratis';

  @override
  String get paywallTitle => 'Desbloquea el acceso total';

  @override
  String get planYearly => '12 meses';

  @override
  String get planWeekly => 'Semana';

  @override
  String trialBadgeFreeDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días gratis',
      one: '$days día gratis',
    );
    return '$_temp0';
  }

  @override
  String trialDayLabel(int n) {
    return 'Día $n';
  }

  @override
  String get trialDay1Desc => 'Acceso desbloqueado';

  @override
  String get trialDayMidDesc => 'Te avisaremos un día antes';

  @override
  String get trialDayEndDesc => 'Comienza la suscripción';

  @override
  String get featureUnlimited => 'Todas las funciones sin límites';

  @override
  String get featureUpdates => 'Actualizaciones regulares';

  @override
  String get featurePrivacy => 'Seguro y privado';

  @override
  String get featureSupport => 'Soporte prioritario';

  @override
  String get faqTitle => 'Preguntas frecuentes';

  @override
  String get faqCancelQ => '¿Puedo cancelar?';

  @override
  String get faqCancelA =>
      'Sí, en cualquier momento desde los ajustes de App Store o Google Play. Si cancelas antes del fin de la prueba, no se cobrará nada.';

  @override
  String get faqChargeQ => '¿Cuándo se cobrará?';

  @override
  String get faqChargeA =>
      'Si elegiste un periodo de prueba — al finalizar. Te avisamos antes para que decidas.';

  @override
  String get faqIncludesQ => '¿Qué incluye la suscripción?';

  @override
  String get faqIncludesA =>
      'Todas las funciones sin límites, actualizaciones regulares y soporte prioritario.';

  @override
  String get paywallNoPaymentNow => 'Sin pago ahora';

  @override
  String get paywallCtaStartFree => 'Empezar gratis';

  @override
  String get paywallCtaSubscribe => 'Suscribirse';

  @override
  String get paywallDisclaimer =>
      'Se renueva automáticamente. Cancela cuando quieras';

  @override
  String get menuRestore => 'Restaurar compras';

  @override
  String get menuTerms => 'Condiciones de uso';

  @override
  String get menuPrivacy => 'Política de privacidad';

  @override
  String get menuPromo => '¿Tienes un código?';

  @override
  String get menuRestart => 'Empezar de nuevo';

  @override
  String get promoTitle => 'Introduce el código promocional';

  @override
  String get promoSubtitle =>
      'Si tienes un código de activación — introdúcelo abajo';

  @override
  String get promoCtaActivate => 'Activar';

  @override
  String get promoErrorInvalid => 'Código inválido';

  @override
  String promoSuccess(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days días',
      one: '$days día',
    );
    return 'Suscripción activada por $_temp0';
  }

  @override
  String get homeTitle => 'Inicio';

  @override
  String get homeSubNotActive => 'Suscripción no activa';

  @override
  String get homeOnboardingNotDone => 'Onboarding no completado';

  @override
  String get homeAnswersLabel => 'Tus respuestas:';

  @override
  String get homeBtnReplayOnboarding => 'Reiniciar onboarding';

  @override
  String get homeBtnToPaywall => 'Al paywall';

  @override
  String get homeBtnResetSub => 'Restablecer suscripción';

  @override
  String homePremiumBadge(String remaining) {
    return 'Premium activa · quedan $remaining';
  }

  @override
  String remainingDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n días',
      one: '$n día',
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
  String get tabHome => 'Inicio';

  @override
  String get tabAnalytics => 'Analítica';

  @override
  String get tabSettings => 'Ajustes';

  @override
  String get homeTabEmpty => 'La pestaña Inicio está vacía por ahora';

  @override
  String get analyticsTabEmpty => 'La pestaña Analítica está vacía por ahora';

  @override
  String get settingsSubscriptionTitle => 'Suscripción';

  @override
  String get settingsSubActive => 'Premium activa';

  @override
  String get settingsSubInactive => 'Suscripción no activa';

  @override
  String settingsSubExpiresLeft(String remaining) {
    return 'quedan $remaining';
  }

  @override
  String get settingsSubBtnGoPaywall => 'Activar suscripción';

  @override
  String get settingsSubBtnManage => 'Gestionar suscripción';

  @override
  String get settingsRestartOnboarding => 'Reiniciar onboarding';

  @override
  String get restartConfirmTitle => '¿Reiniciar onboarding?';

  @override
  String get restartConfirmMessage =>
      'Tus respuestas se borrarán y volverás a la pantalla de bienvenida.';

  @override
  String get commonCancel => 'Cancelar';

  @override
  String get commonConfirm => 'Reiniciar';

  @override
  String get commonUndo => 'Deshacer';

  @override
  String get commonDelete => 'Eliminar';

  @override
  String get tabNotes => 'Notas';

  @override
  String get noteNew => 'Nota';

  @override
  String get notesEmptyTitle => 'Aún no hay notas';

  @override
  String get notesEmptySubtitle =>
      'Apunta tus observaciones: picado, cebo, clima.';

  @override
  String get noteNewTitle => 'Nueva nota';

  @override
  String get noteEditTitle => 'Nota';

  @override
  String get noteTextHint => '¿Qué notaste? Picado, cebo, clima…';

  @override
  String get noteLocationLabel => 'Ubicación';

  @override
  String get noteLocationNone => 'Sin ubicación';

  @override
  String get notePhotosLabel => 'Fotos';

  @override
  String get notePhotoCamera => 'Cámara';

  @override
  String get notePhotoGallery => 'Galería';

  @override
  String get noteConditionsTitle => 'Condiciones al anotar';

  @override
  String get noteSave => 'Guardar nota';

  @override
  String get noteDeleteConfirm => '¿Eliminar nota?';

  @override
  String get noteDeleted => 'Nota eliminada';

  @override
  String get noteEmptyError => 'Añade texto o una foto';

  @override
  String get noteDiscardTitle => '¿Descartar cambios?';

  @override
  String get noteDiscard => 'Descartar';

  @override
  String get settingsNotificationsTitle => 'Notificaciones';

  @override
  String get settingsNotifMaster => 'Todas las notificaciones';

  @override
  String get settingsNotifReminders => 'Recordatorios';

  @override
  String get settingsNotifNews => 'Noticias y novedades';

  @override
  String get settingsAboutTitle => 'Acerca de';

  @override
  String get settingsRateApp => 'Valorar la app';

  @override
  String get settingsShareApp => 'Compartir con amigos';

  @override
  String get settingsContactSupport => 'Contactar soporte';

  @override
  String shareMessage(String appName, String appLink) {
    return 'Prueba $appName — $appLink';
  }

  @override
  String supportEmailSubject(String appName) {
    return 'Ayuda con $appName';
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
  String get settingsAppearanceTitle => 'Apariencia';

  @override
  String get settingsLanguage => 'Idioma';

  @override
  String get settingsUnitsTitle => 'Unidades';

  @override
  String get unitTemperature => 'Temperatura';

  @override
  String get unitWind => 'Viento';

  @override
  String get unitPressure => 'Presión';

  @override
  String get settingsMoreTitle => 'Más';

  @override
  String get settingsSubInactiveSubtitle => 'Desbloquea todas las funciones';

  @override
  String get settingsThemeTitle => 'Tema';

  @override
  String get themeSystem => 'Sistema';

  @override
  String get themeLight => 'Claro';

  @override
  String get themeDark => 'Oscuro';

  @override
  String mockPurchase(String plan) {
    return 'Compra simulada: $plan';
  }

  @override
  String get mockRestore => 'Simulado: compras restauradas';

  @override
  String get tabForecast => 'Pronóstico';

  @override
  String get locCurrent => 'Mi ubicación';

  @override
  String get locDefault => 'Ubicación por defecto';

  @override
  String get locationSheetTitle => 'Ubicación';

  @override
  String get locFallbackBanner =>
      'La ubicación está desactivada — se muestra el spot por defecto. El pronóstico puede no coincidir con tu zona.';

  @override
  String get locFallbackAction => 'Elegir';

  @override
  String get fcLoading => 'Cargando pronóstico…';

  @override
  String get fcError => 'No se pudo cargar el pronóstico';

  @override
  String get fcErrorSubtitle => 'Revisa tu conexión e inténtalo de nuevo';

  @override
  String get fcRetry => 'Reintentar';

  @override
  String get fcRefresh => 'Actualizar pronóstico semanal';

  @override
  String get fcRefreshing => 'Actualizando pronóstico…';

  @override
  String get fcRefreshStep1 => 'Obteniendo el tiempo…';

  @override
  String get fcRefreshStep2 => 'Leyendo presión y viento…';

  @override
  String get fcRefreshStep3 => 'Comprobando la fase lunar…';

  @override
  String get fcRefreshStep4 => 'Buscando las ventanas de picado…';

  @override
  String get fcRefreshStep5 => 'Recalculando el índice…';

  @override
  String fcUpdatedAt(String time) {
    return 'actualizado a las $time';
  }

  @override
  String get fcUpdatedJustNow => 'actualizado ahora mismo';

  @override
  String fcUpdatedMinAgo(int minutes) {
    return 'actualizado hace $minutes min';
  }

  @override
  String fcUpdatedHoursAgo(int hours) {
    return 'actualizado hace $hours h';
  }

  @override
  String fcUpdatedDate(String date) {
    return 'actualizado $date';
  }

  @override
  String fcOfflineUpdated(String age) {
    return 'sin conexión · $age';
  }

  @override
  String get fcFactorGood => 'bueno';

  @override
  String get fcFactorNeutral => 'neutro';

  @override
  String get fcFactorWeak => 'débil';

  @override
  String get tabSpots => 'Spots';

  @override
  String get spotsActiveTitle => 'Spot activo';

  @override
  String get spotsSavedTitle => 'Spots guardados';

  @override
  String get spotsUseCurrent => 'Usar ubicación actual';

  @override
  String get spotsEmpty => 'Aún no hay spots guardados.\nAñade uno en el mapa.';

  @override
  String get spotsAddOnMap => 'Añadir en el mapa';

  @override
  String get spotPickerTitle => 'Elegir spot';

  @override
  String get spotNameHint => 'Nombre del spot (opcional)';

  @override
  String get spotSaveBtn => 'Guardar spot';

  @override
  String get spotSaveActive => 'Guardar';

  @override
  String get spotNameDialogTitle => 'Nombre del spot';

  @override
  String get spotEdit => 'Editar';

  @override
  String spotDefaultName(int n) {
    return 'Spot $n';
  }

  @override
  String get spotDeleted => 'Spot eliminado';

  @override
  String get spotDeleteConfirm => '¿Eliminar spot?';

  @override
  String get spotSearchHint => 'Buscar un lugar';

  @override
  String get spotNothingFound => 'No se encontró nada';

  @override
  String get spotLocationUnavailable => 'No se pudo obtener tu ubicación';

  @override
  String get fcToday => 'Hoy';

  @override
  String get fcTomorrow => 'Mañana';

  @override
  String get fcIndexCaption => 'Índice de picado';

  @override
  String get fcBestWindow => 'Mejor ventana';

  @override
  String get fcBestWindowEmpty => 'Actividad débil todo el día';

  @override
  String get fcHourlyTitle => 'Por horas';

  @override
  String get fcWeekTitle => 'Pronóstico a 7 días';

  @override
  String get fcUpcomingDays => 'Próximos días';

  @override
  String get fcSeeWeek => 'Ver semana';

  @override
  String get fcWhyTitle => 'Por qué esta puntuación';

  @override
  String get fcHowItWorksBtn => 'Cómo funciona el pronóstico';

  @override
  String get fcHowItWorksTitle => 'Cómo funciona el pronóstico';

  @override
  String get fcHowItWorksP1Title => 'Un modelo inteligente, no cara o cruz';

  @override
  String get fcHowItWorksP1Body =>
      'Detrás de cada puntuación hay un modelo que reúne cada día decenas de factores del tiempo: presión atmosférica y sus cambios, fuerza y dirección del viento, temperatura del aire y del agua, nubosidad, precipitación, fase lunar y estación. Pesamos cada uno y lo convertimos en una única puntuación de picado clara.';

  @override
  String get fcHowItWorksP2Title => 'Ajustado a tu agua';

  @override
  String get fcHowItWorksP2Body =>
      'Un lago, un río, un estanque y un embalse viven según sus propias reglas. El algoritmo tiene en cuenta el tipo de agua y sus rasgos para señalar dónde y cuándo es más probable que el pez esté activo en tu spot.';

  @override
  String get fcHowItWorksP3Title => 'Basado en el comportamiento del pez';

  @override
  String get fcHowItWorksP3Body =>
      'El pez reacciona al tiempo de forma predecible: busca temperatura cómoda, oxígeno y alimento. Integramos esos patrones y los traducimos en consejos concretos: dónde colocarte, a qué profundidad pescar y qué horas esperar.';

  @override
  String get fcHowItWorksP4Title => 'El mejor momento y lugar';

  @override
  String get fcHowItWorksP4Body =>
      'Calculamos no solo hoy, sino también los días venideros y resaltamos las mejores ventanas de picado, para que planifiques tu sesión en el día y la hora más prometedores en vez de adivinar.';

  @override
  String get fcHowItWorksDisclaimer =>
      'Es una probabilidad, no una promesa. En el agua, lee siempre el sitio y experimenta: lugar, cebo, momento.';

  @override
  String get storyTitle => 'Anatomía del picado';

  @override
  String get storySubtitle => 'Por qué no es leer el poso del café';

  @override
  String get storyHookTitle => 'Picar no es una lotería';

  @override
  String get storyHookBody =>
      'Los peces son de sangre fría: no tienen «humor», solo una reacción al agua y al cielo. Baja la presión, se calienta el agua, sopla el viento — cambia el apetito. Aprendimos a leer esas señales y a reunirlas en una sola puntuación. De ahí sale.';

  @override
  String get storyPressureTitle => 'Barómetro y termómetro';

  @override
  String get storyPressureBody =>
      'El pez tiene un barómetro incorporado: su vejiga natatoria. Un salto brusco de presión lo aturde; una caída lenta antes del mal tiempo enciende el apetito. Y todo sobre el fondo de la temperatura del agua, que va por detrás del aire — un estanque pequeño despierta en días, un lago grande tarda semanas — por eso modelamos la inercia del agua y la ajustamos a tu agua. Agua fría: aletargado en el fondo. Templada: comiendo.';

  @override
  String get storyWindTitle => 'Viento y hora';

  @override
  String get storyWindBody =>
      'El viento es amigo del pescador: empuja el agua templada y el alimento hacia la orilla de sotavento y aporta oxígeno — allí se reúne el pez. Y cada uno tiene su hora: la carpa ama el crepúsculo y la noche cálida, el carpín la mañana, mientras que un mediodía caluroso corta el picado. La luna influye un poco. Así la puntuación cambia no solo de día a día, sino de hora a hora.';

  @override
  String get storyTypeTitle => 'Cada agua tiene su carácter';

  @override
  String get storyTypeBody =>
      'Un lago, un río, un estanque, un canal y un embalse viven cada uno a su manera. En agua grande el pez sigue al viento; en un río se queda en curvas, pozas y la calma tras los rápidos; en un estanque pequeño se pega a los juncos y troncos. Identificamos tu agua con el mapa de OpenStreetMap — su tipo y tamaño — y ajustamos tanto el modelo de calentamiento del agua como los consejos de dónde buscar.';

  @override
  String get storyFishTitle => 'Carpa ≠ carpín';

  @override
  String get storyFishBody =>
      'Un motor, dos caracteres — y no hay que confundirlos. La carpa es un gourmet prudente: ama el agua templada, una caída lenta de presión antes del mal tiempo, y come incluso de noche. El carpín es más caprichoso con los cambios, despierta más tarde y se llena rápido, pero es increíblemente resistente — un charco cálido y cargado que agobia a la carpa a él le va de maravilla. Por eso puntuamos a cada uno por su perfil: umbrales de temperatura, respuesta a la presión, horas de alimentación.';

  @override
  String get storyTacticsTitle => 'No solo cuándo, sino cómo';

  @override
  String get storyTacticsBody =>
      'Saber que hoy pica no basta — importa el cómo. Con el tiempo real del día sugerimos: el «termómetro del cebo» (frío — pequeño y vistoso: gusanos, maíz; cálido — más sustancioso: boilies, chufas), qué montaje usar, dónde sentarte y qué horas esperar. Con agua que se calienta cebamos generosamente; con frío y calor extremo, con moderación. Todo ajustado al agua y al cielo de este día, no por costumbre.';

  @override
  String get storyHonestTitle => 'Probabilidad, no garantía';

  @override
  String get storyHonestBody =>
      'Seamos honestos: es una estimación de las opciones, no una promesa de captura. La profundidad, el relieve del fondo, los troncos y cuántos peces hay realmente bajo ti — eso no lo ve un satélite, y ningún modelo lo sabe. El pronóstico te ayuda a elegir un buen día, lugar y hora — le quita la lotería a la pesca. El resto depende de ti: prueba puntos, cambia cebos y profundidades, experimenta. En eso está toda la gracia.';

  @override
  String get fcWhyHelps => 'Ayuda';

  @override
  String get fcWhyHurts => 'Frena';

  @override
  String get fcWhyNoCons => 'sin factores limitantes';

  @override
  String get fcWhyAnd => 'y';

  @override
  String fcWhyHelpsOne(Object factors) {
    return '$factors favorece el picado.';
  }

  @override
  String fcWhyHelpsMany(Object factors) {
    return '$factors favorecen el picado.';
  }

  @override
  String fcWhyHurtsOne(Object factors) {
    return '$factors reduce la actividad del pez.';
  }

  @override
  String fcWhyHurtsMany(Object factors) {
    return '$factors reducen la actividad del pez.';
  }

  @override
  String get fcWhyBalanced =>
      'Los factores están equilibrados — no se esperan cambios bruscos de actividad.';

  @override
  String get fcPhrasePressurePos =>
      'la presión estable mantiene a los peces comiendo cerca del fondo';

  @override
  String get fcPhrasePressureNeg =>
      'los cambios de presión les quitan el apetito a los peces';

  @override
  String get fcPhraseTemperaturePos =>
      'el agua se ha calentado a una temperatura cómoda para comer';

  @override
  String get fcPhraseTemperatureNeg =>
      'el agua fría ralentiza a los peces y apenas comen';

  @override
  String get fcPhraseWindPos =>
      'el ligero oleaje arrastra el alimento hacia la orilla';

  @override
  String get fcPhraseWindNeg =>
      'el viento fuerte levanta olas y los peces se van al fondo';

  @override
  String get fcPhraseCloudPos =>
      'las nubes atenúan la luz y los peces comen con más confianza';

  @override
  String get fcPhraseCloudNeg =>
      'el sol intenso vuelve recelosos a los peces y se esconden';

  @override
  String get fcPhrasePrecipPos =>
      'el tiempo seco y estable hace predecibles a los peces';

  @override
  String get fcPhrasePrecipNeg =>
      'la lluvia enturbia el agua y altera la presión';

  @override
  String get fcPhraseSeasonPos =>
      'pico de temporada — los peces se alimentan a fondo';

  @override
  String get fcPhraseSeasonNeg =>
      'bajón de temporada — el metabolismo de los peces se ralentiza';

  @override
  String get fcPhraseMoonPos =>
      'fase lunar activa — un pico de alimentación solunar';

  @override
  String get fcPhraseMoonNeg => 'fase lunar débil — una calma solunar';

  @override
  String get fcConfidenceHigh => 'Confianza alta';

  @override
  String get fcConfidenceMedium => 'Confianza media';

  @override
  String get fcConfidenceLow => 'Confianza baja';

  @override
  String get fcDayConditions => 'Tiempo diurno';

  @override
  String get fcPeriodNight => 'Noche';

  @override
  String get fcPeriodMorning => 'Mañana';

  @override
  String get fcPeriodDay => 'Día';

  @override
  String get fcPeriodEvening => 'Tarde';

  @override
  String get fcRateWeak => 'Débil';

  @override
  String get fcRateMid => 'Regular';

  @override
  String get fcRateGood => 'Bueno';

  @override
  String get fcRateGreat => 'Excelente';

  @override
  String get fcPeriodWhyTitle => 'Por qué esta valoración';

  @override
  String get fcPeriodTimeEffect => 'Momento del día';

  @override
  String get fcPeriodBaseTitle => 'Condiciones de base';

  @override
  String get fcPeriodWater => 'Agua';

  @override
  String get fcTodAdjCaption => 'Ajuste por momento del día';

  @override
  String fcTodDawn(String sunrise) {
    return 'El amanecer hacia las $sunrise es el pico diario de alimentación, así que este periodo se eleva por encima del nivel diurno.';
  }

  @override
  String fcTodDusk(String sunset) {
    return 'El atardecer hacia las $sunset: los peces comen con ganas antes de la noche, así que la valoración sube.';
  }

  @override
  String fcTodWarmNight(String water, String warm) {
    return 'El agua $water está en o por encima del umbral de noche cálida ($warm); los peces siguen comiendo de noche y la valoración nocturna se mantiene cerca de la diurna.';
  }

  @override
  String fcTodMidNight(String water, String cold, String warm) {
    return 'El agua $water está entre el umbral frío ($cold) y el de noche cálida ($warm): de noche comen a medias, y cuanto más cálida el agua, más activa la noche.';
  }

  @override
  String fcTodColdNight(String water, String cold) {
    return 'El agua $water está por debajo del umbral frío ($cold): en agua fría los peces apenas se mueven de noche, así que la valoración cae muy por debajo de la diurna.';
  }

  @override
  String fcTodMiddayHot(String temp, String heat) {
    return 'Al mediodía hace calor ($temp, por encima de $heat): los peces se retiran a la sombra y a aguas profundas, así que la actividad baja.';
  }

  @override
  String fcTodColdDay(String water, String cold) {
    return 'El agua está fría ($water, como máximo $cold); el calentamiento diurno hace del mediodía el mejor momento relativo.';
  }

  @override
  String get fcTodDayNeutral =>
      'Horas centrales del día, entre los picos del amanecer y el atardecer: actividad tranquila y media.';

  @override
  String get spawnTitle => 'Ventana de desove';

  @override
  String spawnPreSpawn(String water) {
    return 'El agua está a $water y sube hacia el rango de desove: parece la antesala del desove.';
  }

  @override
  String spawnSpawning(String water) {
    return 'El agua está a $water, dentro del rango de desove de la especie: parece desove.';
  }

  @override
  String spawnPostSpawn(String water) {
    return 'El agua a $water ya superó el rango de desove: el desove parece haber terminado.';
  }

  @override
  String get spawnImpactPreSpawn =>
      'Antes del desove suele haber un arranque de alimentación: el picado suele ser alto (≈70–90 de 100). Pesca mientras la ventana esté abierta.';

  @override
  String get spawnImpactSpawning =>
      'El índice de arriba no tiene en cuenta el desove. Si de verdad está en marcha, el picado real es mucho menor — normalmente ≈10–20 de 100, durante varios días.';

  @override
  String get spawnImpactPostSpawn =>
      'Tras el desove suele venir un arranque de alimentación: el picado vuelve a ser alto (≈70–90 de 100).';

  @override
  String get spawnCaveatEstimated =>
      'Esto pronostica la ventana, no una fecha exacta: el desove ocurre distinto y en oleadas en cada masa de agua, y el agua la estimamos a partir del aire.';

  @override
  String get spawnCaveatRough =>
      'Un pronóstico aproximado: masa de agua grande y lenta, el desove es distinto en todas partes y el agua la estimamos a partir del aire — las fechas pueden variar bastante.';

  @override
  String get moonNew => 'Luna nueva';

  @override
  String get moonWaxing => 'Creciente';

  @override
  String get moonFull => 'Luna llena';

  @override
  String get moonWaning => 'Menguante';

  @override
  String get fcHowToFish => 'Cómo pescar hoy';

  @override
  String get fcHowToFishTomorrow => 'Cómo pescar mañana';

  @override
  String fcHowToFishOn(String date) {
    return 'Cómo pescar el $date';
  }

  @override
  String get fcWhenTitle => 'Cuándo';

  @override
  String get fcWindowsLabel => 'Ventanas de picado';

  @override
  String get fcWindowDawn => 'picado matinal (amanecer)';

  @override
  String get fcWindowDusk => 'picado vespertino (atardecer)';

  @override
  String get fcWindowNight => 'picado nocturno';

  @override
  String get fcWindowMorning => 'mañana';

  @override
  String get fcWindowEvening => 'tarde';

  @override
  String get fcWindowDay => 'mediodía';

  @override
  String get fcWindowsWhyDawn => 'La carpa come más al alba y al anochecer.';

  @override
  String get fcWindowsWhyNight =>
      'En agua templada la carpa come activamente de noche.';

  @override
  String get fcWindowsWhyDay =>
      'El tiempo suave del día mantiene activos a los peces.';

  @override
  String get fcVerdictVeryLow =>
      'Día difícil — el picado va flojo, quizá mejor dejarlo.';

  @override
  String get fcVerdictLow =>
      'Picado débil. Si vas — pesca preciso y con paciencia.';

  @override
  String get fcVerdictMedium =>
      'Un día normal — sin garantías, pero hay opción.';

  @override
  String fcVerdictMediumWindow(String from, String to) {
    return 'Hay opción — prueba la ventana $from–$to.';
  }

  @override
  String get fcVerdictGood => 'Buen día — mantén un cebo en el agua.';

  @override
  String fcVerdictGoodWindow(String from, String to) {
    return 'Vale la pena ir. Mejor hora — $from–$to.';
  }

  @override
  String get fcVerdictExcellent => '¡Día excelente — el picado está activo!';

  @override
  String fcVerdictExcellentWindow(String from, String to) {
    return '¡Día excelente! No te pierdas la ventana $from–$to.';
  }

  @override
  String get fcLevelVeryLow => 'Muy bajo';

  @override
  String get fcLevelLow => 'Bajo';

  @override
  String get fcLevelMedium => 'Moderado';

  @override
  String get fcLevelGood => 'Bueno';

  @override
  String get fcLevelExcellent => 'Excelente';

  @override
  String get fcFactorPressure => 'Presión';

  @override
  String get fcFactorTemperature => 'Temp. agua';

  @override
  String get fcFactorWind => 'Viento';

  @override
  String get fcFactorCloud => 'Nubosidad';

  @override
  String get fcFactorPrecipitation => 'Precipitación';

  @override
  String get fcFactorSeason => 'Estación';

  @override
  String get fcFactorMoon => 'Luna';

  @override
  String get fcCondClear => 'Despejado';

  @override
  String get fcCondPartly => 'Parcialmente nublado';

  @override
  String get fcCondCloudy => 'Nublado';

  @override
  String get fcCondRain => 'Lluvia';

  @override
  String get fcCondStorm => 'Tormenta';

  @override
  String get fcChipPressure => 'Presión';

  @override
  String get fcChipWind => 'Viento';

  @override
  String get fcChipWater => 'Agua';

  @override
  String get fcChipTemp => 'Temperatura';

  @override
  String get fcChipMoon => 'Luna';

  @override
  String get fishCarp => 'Carpa';

  @override
  String get fishCrucian => 'Carpín';

  @override
  String get fishSheetTitle => 'Pez';

  @override
  String get fcUnitHpaSuffix => 'hPa';

  @override
  String get fcUnitMmHgSuffix => 'mmHg';

  @override
  String get fcUnitMsSuffix => 'm/s';

  @override
  String get fcUnitKmhSuffix => 'km/h';

  @override
  String get fcWindCalm => 'En calma';

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
  String get tabAdvice => 'Tácticas';

  @override
  String get adviceHeadline => 'Tácticas sugeridas';

  @override
  String get adviceDisclaimer =>
      'Orientación según el pronóstico del tiempo, no para un agua concreta.';

  @override
  String get adviceKindBait => 'Cebo';

  @override
  String get adviceKindFeeding => 'Engodo';

  @override
  String get adviceKindDepth => 'Profundidad';

  @override
  String get adviceKindLocation => 'Sitio';

  @override
  String get adviceKindTiming => 'Momento';

  @override
  String adviceWhyWater(String value) {
    return 'agua $value';
  }

  @override
  String get adviceWhyWaterRising => 'el agua se calienta día a día';

  @override
  String get adviceWhyWaterFalling => 'el agua se enfría día a día';

  @override
  String adviceWhyAirHot(String value) {
    return 'calor — aire $value';
  }

  @override
  String adviceWhyWind(String value) {
    return 'viento $value';
  }

  @override
  String get adviceWhyWindLight => 'viento flojo';

  @override
  String get adviceWhyPressureFalling => 'la presión baja';

  @override
  String get adviceWhyRain => 'lluvia durante el día';

  @override
  String get adviceWhyBottomHabit =>
      'agua templada — la carpa se mantiene cerca del fondo';

  @override
  String get adviceWhyBiteHigh => 'índice de picado alto';

  @override
  String get adviceWhyBiteMid => 'índice de picado moderado';

  @override
  String get adviceWhyBiteLow => 'índice de picado bajo';

  @override
  String get adviceWhyBestHours => 'el índice alcanza su máximo a esta hora';

  @override
  String get windFullN => 'del norte';

  @override
  String get windFullNE => 'del noreste';

  @override
  String get windFullE => 'del este';

  @override
  String get windFullSE => 'del sureste';

  @override
  String get windFullS => 'del sur';

  @override
  String get windFullSW => 'del suroeste';

  @override
  String get windFullW => 'del oeste';

  @override
  String get windFullNW => 'del noroeste';

  @override
  String get adviceBaitColdBrightTitle => 'Cebos pequeños y vistosos';

  @override
  String get adviceBaitColdBrightBody =>
      'Agua fría — maíz, gusanos, pellets pequeños. La carpa come poco y con cautela.';

  @override
  String get adviceBaitMidBoiliesTitle => 'Boilies y pellets';

  @override
  String get adviceBaitMidBoiliesBody =>
      'El agua se calienta — boilies de 10–16 mm y pellets. La carpa está más activa.';

  @override
  String get adviceBaitWarmFishmealTitle => 'Boilies de harina de pescado';

  @override
  String get adviceBaitWarmFishmealBody =>
      'Agua templada, máximo apetito — boilies ricos de harina de pescado, chufas, maíz.';

  @override
  String get adviceBaitHotSurfaceTitle => 'Cebos flotantes';

  @override
  String get adviceBaitHotSurfaceBody =>
      'El calor sube a la carpa — pop-ups, pellet flotante, un poco de pan.';

  @override
  String get adviceBaitWarmingTitle => 'Más grande y aromático';

  @override
  String get adviceBaitWarmingBody =>
      'Tendencia al alza — la carpa se activa. Boilies, chufas, cebos aromatizados.';

  @override
  String get adviceBaitCoolingTitle => 'Más pequeño y vistoso';

  @override
  String get adviceBaitCoolingBody =>
      'El agua baja — el pez se vuelve cauto. Pellets pequeños, maíz, gusanos.';

  @override
  String get adviceFeedMinimalTitle => 'Ceba con moderación';

  @override
  String get adviceFeedMinimalBody =>
      'Solo un par de puñados, juntos — no sobrealimentes al pez inactivo.';

  @override
  String get adviceFeedModerateTitle => 'Ceba moderado';

  @override
  String get adviceFeedModerateBody =>
      'Volumen medio; repón con regularidad en pequeñas cantidades.';

  @override
  String get adviceFeedHeavyTitle => 'Ceba abundante';

  @override
  String get adviceFeedHeavyBody =>
      'La carpa come con ganas — una cama inicial mayor y reposiciones frecuentes valen la pena.';

  @override
  String get adviceRigBottomTitle => 'Pesca al fondo';

  @override
  String get adviceRigBottomBody =>
      'Montaje de fondo, sobre el lecho o junto a estructuras — el clásico para carpa.';

  @override
  String get adviceRigZigTitle => 'Prueba un zig rig';

  @override
  String get adviceRigZigBody =>
      'El pez está a media agua — un zig a 1–2 m del fondo puede funcionar.';

  @override
  String get adviceRigSurfaceTitle => 'Pesca en superficie';

  @override
  String get adviceRigSurfaceBody =>
      'La carpa se asolea cerca de la superficie — aparejo de superficie y cebo flotante.';

  @override
  String get adviceSwimWindwardTitle => 'Pesca a favor del viento';

  @override
  String adviceSwimWindwardBody(String dir) {
    return 'Un viento $dir empuja el agua templada de superficie y el alimento hacia la orilla opuesta; allí come la carpa.';
  }

  @override
  String get adviceSwimCalmFeaturesTitle => 'Busca estructuras';

  @override
  String get adviceSwimCalmFeaturesBody =>
      'Viento flojo — trabaja desniveles, troncos, juncos y cambios de profundidad.';

  @override
  String get adviceSwimShelteredTitle => 'A lo hondo o a la sombra';

  @override
  String get adviceSwimShelteredBody =>
      'Con calor, busca agua profunda más fresca y zonas sombreadas.';

  @override
  String get adviceTimePressureDropTitle => 'Ventana antes del frente';

  @override
  String get adviceTimePressureDropBody =>
      'La presión baja — es probable una racha de comida. No te pierdas las próximas horas.';

  @override
  String get adviceTimeBestWindowTitle => 'Mejor ventana de hoy';

  @override
  String adviceTimeBestWindowBody(String from, String to) {
    return 'Actividad máxima sobre las $from–$to. Llega a tu sitio un poco antes.';
  }

  @override
  String get adviceTimeDawnDuskTitle => 'Amanecer y atardecer';

  @override
  String get adviceTimeDawnDuskBody =>
      'Apuesta por la mañana temprano y el final de la tarde — el picado más fiable.';

  @override
  String get adviceTimeAllDayTitle => 'Activa todo el día';

  @override
  String get adviceTimeAllDayBody =>
      'Índice alto — la carpa come durante el día; mantén un cebo en el agua.';

  @override
  String get adviceTimeSlowPatientTitle => 'Ten paciencia';

  @override
  String get adviceTimeSlowPatientBody =>
      'El pez está flojo — presentación precisa, aparejos más finos, espera una ventana.';

  @override
  String get crucianBaitColdAnimalTitle => 'Cebo animal';

  @override
  String get crucianBaitColdAnimalBody =>
      'Agua fría — larva roja pequeña y gusanos. Una o dos larvas por vez; el carpín come despacio.';

  @override
  String get crucianBaitWarmingTitle => 'Lombriz y gusano';

  @override
  String get crucianBaitWarmingBody =>
      'El agua se calienta — el carpín se activa. Lombriz dendrobena, un manojo de gusanos, larva roja.';

  @override
  String get crucianBaitCoolingTitle => 'Más pequeño y blando';

  @override
  String get crucianBaitCoolingBody =>
      'Enfriamiento — el carpín se vuelve caprichoso. Larva roja pequeña o un sándwich, cebo más blando.';

  @override
  String get crucianBaitSandwichTitle => 'Cebo sándwich';

  @override
  String get crucianBaitSandwichBody =>
      'Agua de transición — un sándwich: gusano con cebada perlada o maíz. El carpín es selectivo.';

  @override
  String get crucianBaitWarmPlantTitle => 'Cebo vegetal';

  @override
  String get crucianBaitWarmPlantBody =>
      'Agua templada — cebada perlada, masa de sémola, maíz, masa. El carpín pasa a cebos vegetales.';

  @override
  String get crucianBaitHotDoughTitle => 'Masa blanda';

  @override
  String get crucianBaitHotDoughBody =>
      'Calor — masa blanda, masa de sémola, miga de pan. Un cebo dulce y ligero arriba en el agua.';

  @override
  String get crucianFeedTinyTitle => 'Ceba justo';

  @override
  String get crucianFeedTinyBody =>
      'El carpín es tímido y se llena rápido — unas pizcas de engodo fino y dulce, no más.';

  @override
  String get crucianFeedSweetTitle => 'Engodo dulce';

  @override
  String get crucianFeedSweetBody =>
      'Mezcla fina con aroma de ajo o vainilla; repón poco y a menudo, sin sobrealimentar.';

  @override
  String get crucianFeedActiveTitle => 'Ceba activo';

  @override
  String get crucianFeedActiveBody =>
      'El carpín come bien — repón más a menudo pero en poca cantidad para retener al cardumen.';

  @override
  String get crucianRigFloatBottomTitle => 'Flotador al fondo';

  @override
  String get crucianRigFloatBottomBody =>
      'El aparejo clásico de carpín — pesca a flote, cebo apoyado o rozando el fondo.';

  @override
  String get crucianRigDropperTitle => 'Plomo de caída';

  @override
  String get crucianRigDropperBody =>
      'El carpín ha subido a media agua — cebo de caída lenta, reparte los plomos, pesca al descenso.';

  @override
  String get crucianRigShallowTitle => 'Somero cerca de arriba';

  @override
  String get crucianRigShallowBody =>
      'Con calor el carpín se asolea en lo somero — aparejo ligero, cebo en la capa cálida superior.';

  @override
  String get crucianSwimReedsTitle => 'Borde de juncos';

  @override
  String get crucianSwimReedsBody =>
      'Trabaja los claros entre la vegetación, los bordes de juncos y zonas con maleza — ahí come el carpín.';

  @override
  String get crucianSwimWarmShallowsTitle => 'Bajíos cálidos';

  @override
  String get crucianSwimWarmShallowsBody =>
      'El agua está fría — busca los bajíos más cálidos y las ensenadas calentadas por el sol.';

  @override
  String get crucianSwimDeepEdgeTitle => 'Desnivel hondo y sombra';

  @override
  String get crucianSwimDeepEdgeBody =>
      'Con calor el carpín deja lo somero — pesca pozas, desniveles y zonas sombreadas.';

  @override
  String get crucianTimePressureDropTitle => 'Ten paciencia';

  @override
  String get crucianTimePressureDropBody =>
      'La presión baja — el carpín se vuelve caprichoso y pasivo. Cebos pequeños y blandos, espera rachas cortas.';

  @override
  String get crucianTimeBestWindowTitle => 'Mejor ventana de hoy';

  @override
  String crucianTimeBestWindowBody(String from, String to) {
    return 'Actividad máxima sobre las $from–$to. Llega a tu sitio un poco antes.';
  }

  @override
  String get crucianTimeMorningTitle => 'Picado matinal';

  @override
  String get crucianTimeMorningBody =>
      'Apuesta por la mañana temprano — la racha clásica del carpín, antes del calor.';

  @override
  String get crucianTimeStableWarmTitle => 'Activo también de día';

  @override
  String get crucianTimeStableWarmBody =>
      'Calor estable — el carpín come durante el día; mantén un cebo en el agua.';

  @override
  String get crucianTimePatientTitle => 'Justo y paciente';

  @override
  String get crucianTimePatientBody =>
      'El carpín está pasivo — aparejo fino, cebo pequeño, trabaja un punto y espera una racha.';

  @override
  String get spotTitle => 'Tu spot';

  @override
  String get spotNoWater =>
      'No veo ninguna masa de agua cerca de este punto en el mapa. El pronóstico del tiempo funciona igual — marca un spot para analizar el agua.';

  @override
  String get spotSetOnMap => 'Marcar spot en el mapa';

  @override
  String get spotCheckFailed =>
      'No se pudo consultar el mapa ahora — el pronóstico del tiempo sigue funcionando.';

  @override
  String get spotTypeLake => 'Lago';

  @override
  String get spotTypePond => 'Estanque';

  @override
  String get spotTypeReservoir => 'Embalse';

  @override
  String get spotTypeRiver => 'Río';

  @override
  String get spotTypeCanal => 'Canal';

  @override
  String get spotTypeWater => 'Agua';

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
    return 'El viento cálido empuja el alimento y el agua templada hacia la orilla de sotavento — los peces estarán más activos allí. Orilla activa: $bank.';
  }

  @override
  String spotTipSheltered(String bank) {
    return 'El viento es más frío que el agua — los peces se retiran de la orilla expuesta hacia aguas tranquilas. Orilla protegida: $bank.';
  }

  @override
  String get spotTipNoWind =>
      'Apenas hay viento — hoy ninguna orilla destaca; los peces se reparten por la estructura y las profundidades.';

  @override
  String get spotTipColdWater =>
      'Agua fría — los peces están profundos y apáticos en el fondo; el viento apenas los mueve ahora.';

  @override
  String get spotWhereRiver =>
      'Busca agua mansa: pozas, curvas exteriores, tras los rápidos, junto a troncos y pilares de puentes.';

  @override
  String get spotWhereCanal =>
      'Un canal es uniforme — busca anomalías: curvas, puentes, entradas de agua y orillas con vegetación.';

  @override
  String get spotWherePondSmall =>
      'Un agua pequeña se calienta rápido — los peces se sitúan junto a juncos, troncos y la orilla, y bajan con el calor.';

  @override
  String get spotWhereMid =>
      'Un agua mediana — trabaja las ensenadas, los desniveles y las zonas con vegetación.';

  @override
  String get spotWhereLarge =>
      'Un agua grande — los peces se desplazan; fíjate en puntas, desniveles y sigue el viento.';

  @override
  String get spotWhereUnknown =>
      'Agua quieta — fíjate en juncos, troncos, desniveles y ensenadas.';

  @override
  String get spotSourceType => 'para este tipo de agua';

  @override
  String get spotEditTitle => 'Posición del spot';

  @override
  String get spotEditHint =>
      'Arrastra el mapa para colocar la marca — muévela a la orilla adecuada si hace falta.';

  @override
  String get spotSavePosition => 'Guardar posición';

  @override
  String get spotViewOnMap => 'Ver en el mapa';

  @override
  String get spotWindLabel => 'Viento';

  @override
  String spotWindFrom(String dir) {
    return 'Viento $dir';
  }

  @override
  String get spotDirN => 'del norte';

  @override
  String get spotDirNE => 'del noreste';

  @override
  String get spotDirE => 'del este';

  @override
  String get spotDirSE => 'del sureste';

  @override
  String get spotDirS => 'del sur';

  @override
  String get spotDirSW => 'del suroeste';

  @override
  String get spotDirW => 'del oeste';

  @override
  String get spotDirNW => 'del noroeste';

  @override
  String get spotUserHere =>
      'Tu spot ya está en la orilla activa — estás en el lugar correcto.';

  @override
  String get spotUserOpposite =>
      'Tu spot está en el otro lado — puede picar mejor en la orilla opuesta.';

  @override
  String get spotSourceMap => 'Según datos de OpenStreetMap';

  @override
  String get spotSourceWind => 'según el viento y la temperatura del agua';

  @override
  String get spotDisclaimer =>
      'Una lectura de las condiciones según el mapa y el clima — no vemos la profundidad, el fondo ni la cantidad de peces.';

  @override
  String get settingsAlertsPrimeTitle => 'El mejor día de la semana';

  @override
  String get settingsAlertsPrimeSubtitle =>
      'Un aviso sobre el mejor día de picada de la semana en tus spots';

  @override
  String get settingsAlertsExcellentTitle => 'Todos los días excelentes';

  @override
  String get settingsAlertsExcellentSubtitle =>
      'Un aviso la víspera de cada día con picada excelente';

  @override
  String get settingsAlertsForCarp => 'Notificaciones de carpa';

  @override
  String get settingsAlertsForCrucian => 'Notificaciones de carpín';

  @override
  String alertTitlePrime(String fish) {
    return '$fish: el mejor día de la semana';
  }

  @override
  String alertTitleExcellent(String fish) {
    return '$fish: mañana pica excelente';
  }

  @override
  String get alertWindowDawn => 'mañana al amanecer';

  @override
  String get alertWindowDusk => 'mañana al atardecer';

  @override
  String get alertWindowDay => 'mañana de día';

  @override
  String get alertWindowNight => 'mañana de noche';

  @override
  String get alertWindowAny => 'mañana';

  @override
  String get alertSpotFallback => 'Tu spot';

  @override
  String alertBody(String spot, String when, int index) {
    return '$spot: $when, índice de picada $index';
  }
}
