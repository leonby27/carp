// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get welcomeTitle => 'Прогноз клёва карпа';

  @override
  String get welcomeSubtitle => 'Быстрая настройка — меньше минуты';

  @override
  String get welcomeCta => 'Начать';

  @override
  String get languageSheetTitle => 'Язык';

  @override
  String get languageSheetSubtitle => 'Выберите язык приложения';

  @override
  String get themeSheetSubtitle => 'Выберите внешний вид';

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
  String get commonContinue => 'Продолжить';

  @override
  String get quizQ1Question => 'Кого ловишь?';

  @override
  String get quizQ1Subtitle => 'Настроим прогноз под твою рыбу';

  @override
  String get quizQ1OptLearn => 'Карпа';

  @override
  String get quizQ1OptHabit => 'Карася';

  @override
  String get quizQ1OptSolve => 'И карпа, и карася';

  @override
  String get quizQ2Question => 'Приезжал, а клёва нет?';

  @override
  String get quizQ2Subtitle => 'Честно — так поможем точнее';

  @override
  String get quizQ2OptDaily => 'Да, и не раз';

  @override
  String get quizQ2OptWeekly => 'Иногда бывает';

  @override
  String get quizQ2OptRarely => 'Почти всегда клюёт';

  @override
  String get quizQ3Question => 'Как планируешь выезд?';

  @override
  String get quizQ3Subtitle => 'От этого зависит, что покажем первым';

  @override
  String get quizQ3OptSimple => 'Планирую заранее';

  @override
  String get quizQ3OptResult => 'Еду спонтанно';

  @override
  String get quizQ3OptFlexible => 'Когда как';

  @override
  String get quizQ4Question => 'Как часто рыбачишь?';

  @override
  String get quizQ4Subtitle => 'Подскажем лучшие дни, чтобы не пропустить';

  @override
  String get quizQ4OptWeekly => 'Каждую неделю';

  @override
  String get quizQ4OptMonthly => 'Пару раз в месяц';

  @override
  String get quizQ4OptRarely => 'Изредка';

  @override
  String get onbAnalyzingTitle => 'Анализируем условия';

  @override
  String get onbAnalyzingSubtitle => 'Считаем клёв по погоде, давлению и луне…';

  @override
  String get onbResultTitle => 'Твой прогноз клёва готов';

  @override
  String get onbResultSubtitle =>
      'Клёв на сегодня — бесплатно. Прогноз на 7 дней вперёд открывается в подписке.';

  @override
  String get onbResultTodayBadge => 'Сегодня · бесплатно';

  @override
  String get onbResultLockedLabel => 'Прогноз на 7 дней';

  @override
  String get onbResultCta => 'Смотреть прогноз';

  @override
  String get paywallSkipToday => 'Сначала посмотреть сегодня бесплатно';

  @override
  String get paywallTitle => 'Откройте полный прогноз клёва';

  @override
  String get planYearly => '12 месяцев';

  @override
  String get planWeekly => 'Неделя';

  @override
  String trialBadgeFreeDays(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дней бесплатно',
      many: '$days дней бесплатно',
      few: '$days дня бесплатно',
      one: '$days день бесплатно',
    );
    return '$_temp0';
  }

  @override
  String trialDayLabel(int n) {
    return 'День $n';
  }

  @override
  String get trialDay1Desc => 'Доступ открыт';

  @override
  String get trialDayMidDesc => 'Напомним за день';

  @override
  String get trialDayEndDesc => 'Списание';

  @override
  String get featureUnlimited => 'Прогноз для всех ваших мест';

  @override
  String get featureUpdates => 'Часы клёва обновляются каждый день';

  @override
  String get featurePrivacy => 'Работает везде, данные приватны';

  @override
  String get featureSupport => 'Приоритетная поддержка';

  @override
  String get faqTitle => 'Часто спрашивают';

  @override
  String get faqCancelQ => 'Можно ли отменить?';

  @override
  String get faqCancelA =>
      'Да, в любой момент через настройки App Store или Google Play. Если отмените до конца пробного периода — оплаты не будет.';

  @override
  String get faqChargeQ => 'Когда произойдёт списание?';

  @override
  String get faqChargeA =>
      'Если выбран пробный период — после его окончания. Мы напомним заранее, чтобы вы могли решить.';

  @override
  String get faqIncludesQ => 'Что входит в подписку?';

  @override
  String get faqIncludesA =>
      'Полный прогноз клёва для всех ваших мест, часы клёва по часам, регулярные обновления и приоритетная поддержка.';

  @override
  String get paywallNoPaymentNow => 'Без оплаты сейчас';

  @override
  String get paywallCtaStartFree => 'Начать бесплатно';

  @override
  String get paywallCtaSubscribe => 'Оформить подписку';

  @override
  String get paywallDisclaimer =>
      'Продлевается автоматически. Отмена в любой момент';

  @override
  String get menuRestore => 'Восстановить покупки';

  @override
  String get menuTerms => 'Условия использования';

  @override
  String get menuPrivacy => 'Политика конфиденциальности';

  @override
  String get menuPromo => 'Есть код?';

  @override
  String get menuRestart => 'Начать сначала';

  @override
  String get promoTitle => 'Введите промо-код';

  @override
  String get promoSubtitle =>
      'Если у вас есть код активации — введите его ниже';

  @override
  String get promoCtaActivate => 'Активировать';

  @override
  String get promoErrorInvalid => 'Неверный код';

  @override
  String promoSuccess(int days) {
    String _temp0 = intl.Intl.pluralLogic(
      days,
      locale: localeName,
      other: '$days дней',
      many: '$days дней',
      few: '$days дня',
      one: '$days день',
    );
    return 'Подписка активирована на $_temp0';
  }

  @override
  String get homeTitle => 'Главный экран';

  @override
  String get homeSubNotActive => 'Подписка не активна';

  @override
  String get homeOnboardingNotDone => 'Онбординг не пройден';

  @override
  String get homeAnswersLabel => 'Ваши ответы:';

  @override
  String get homeBtnReplayOnboarding => 'Онбординг заново';

  @override
  String get homeBtnToPaywall => 'К пейволлу';

  @override
  String get homeBtnResetSub => 'Сбросить подписку';

  @override
  String homePremiumBadge(String remaining) {
    return 'Premium активна · ещё $remaining';
  }

  @override
  String remainingDays(int n) {
    String _temp0 = intl.Intl.pluralLogic(
      n,
      locale: localeName,
      other: '$n дней',
      many: '$n дней',
      few: '$n дня',
      one: '$n день',
    );
    return '$_temp0';
  }

  @override
  String remainingHours(int n) {
    return '$n ч.';
  }

  @override
  String remainingMinutes(int n) {
    return '$n мин.';
  }

  @override
  String get tabHome => 'Главная';

  @override
  String get tabAnalytics => 'Аналитика';

  @override
  String get tabSettings => 'Настройки';

  @override
  String get homeTabEmpty => 'Вкладка «Главная» пока пуста';

  @override
  String get analyticsTabEmpty => 'Вкладка «Аналитика» пока пуста';

  @override
  String get settingsSubscriptionTitle => 'Подписка';

  @override
  String get settingsSubActive => 'Premium активна';

  @override
  String get settingsSubInactive => 'Подписка не активна';

  @override
  String settingsSubExpiresLeft(String remaining) {
    return 'ещё $remaining';
  }

  @override
  String get settingsSubBtnGoPaywall => 'Подключить подписку';

  @override
  String get settingsSubBtnManage => 'Управлять подпиской';

  @override
  String get settingsRestartOnboarding => 'Пройти онбординг заново';

  @override
  String get restartConfirmTitle => 'Пройти онбординг заново?';

  @override
  String get restartConfirmMessage =>
      'Ваши ответы будут стёрты, вы вернётесь на приветственный экран.';

  @override
  String get commonCancel => 'Отмена';

  @override
  String get commonConfirm => 'Начать заново';

  @override
  String get commonUndo => 'Отменить';

  @override
  String get commonDelete => 'Удалить';

  @override
  String get tabNotes => 'Заметки';

  @override
  String get noteNew => 'Заметка';

  @override
  String get notesEmptyTitle => 'Заметок пока нет';

  @override
  String get notesEmptySubtitle =>
      'Записывайте наблюдения с рыбалки: клёв, насадку, погоду.';

  @override
  String get noteNewTitle => 'Новая заметка';

  @override
  String get noteEditTitle => 'Заметка';

  @override
  String get noteTextHint => 'Что заметили? Клёв, насадка, погода…';

  @override
  String get noteLocationLabel => 'Место';

  @override
  String get noteLocationNone => 'Без места';

  @override
  String get notePhotosLabel => 'Фото';

  @override
  String get notePhotoCamera => 'Камера';

  @override
  String get notePhotoGallery => 'Галерея';

  @override
  String get noteConditionsTitle => 'Условия в момент заметки';

  @override
  String get noteSave => 'Сохранить заметку';

  @override
  String get noteDeleteConfirm => 'Удалить заметку?';

  @override
  String get noteDeleted => 'Заметка удалена';

  @override
  String get noteEmptyError => 'Добавьте текст или фото';

  @override
  String get noteDiscardTitle => 'Отменить изменения?';

  @override
  String get noteDiscard => 'Отменить';

  @override
  String get settingsNotificationsTitle => 'Уведомления';

  @override
  String get settingsNotifMaster => 'Все уведомления';

  @override
  String get settingsNotifReminders => 'Напоминания';

  @override
  String get settingsNotifNews => 'Новости и обновления';

  @override
  String get settingsAboutTitle => 'О приложении';

  @override
  String get settingsRateApp => 'Оценить приложение';

  @override
  String get settingsShareApp => 'Поделиться с друзьями';

  @override
  String get settingsContactSupport => 'Связаться с поддержкой';

  @override
  String shareMessage(String appName, String appLink) {
    return 'Попробуй $appName — $appLink';
  }

  @override
  String supportEmailSubject(String appName) {
    return 'Помощь с $appName';
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
  String get settingsAppearanceTitle => 'Внешний вид';

  @override
  String get settingsLanguage => 'Язык';

  @override
  String get settingsUnitsTitle => 'Единицы измерения';

  @override
  String get unitTemperature => 'Температура';

  @override
  String get unitWind => 'Ветер';

  @override
  String get unitPressure => 'Давление';

  @override
  String get settingsMoreTitle => 'Ещё';

  @override
  String get settingsSubInactiveSubtitle => 'Откройте все функции';

  @override
  String get settingsThemeTitle => 'Тема';

  @override
  String get themeSystem => 'Системная';

  @override
  String get themeLight => 'Светлая';

  @override
  String get themeDark => 'Тёмная';

  @override
  String mockPurchase(String plan) {
    return 'Mock-покупка: $plan';
  }

  @override
  String get mockRestore => 'Mock: покупки восстановлены';

  @override
  String get tabForecast => 'Прогноз';

  @override
  String get locCurrent => 'Моё место';

  @override
  String get locDefault => 'Место по умолчанию';

  @override
  String get locationSheetTitle => 'Локация';

  @override
  String get locFallbackBanner =>
      'Геолокация выключена — показываем точку по умолчанию. Прогноз может не совпадать с вашим местом.';

  @override
  String get locFallbackAction => 'Выбрать';

  @override
  String get fcLoading => 'Загружаем прогноз…';

  @override
  String get fcError => 'Не удалось загрузить прогноз';

  @override
  String get fcErrorSubtitle => 'Проверьте соединение и попробуйте снова';

  @override
  String get fcRetry => 'Повторить';

  @override
  String get fcRefresh => 'Обновить прогноз на неделю';

  @override
  String get fcRefreshing => 'Обновляем прогноз…';

  @override
  String get fcRefreshStep1 => 'Запрашиваем погоду…';

  @override
  String get fcRefreshStep2 => 'Считаем давление и ветер…';

  @override
  String get fcRefreshStep3 => 'Смотрим фазу луны…';

  @override
  String get fcRefreshStep4 => 'Подбираем окна клёва…';

  @override
  String get fcRefreshStep5 => 'Пересчитываем индекс…';

  @override
  String fcUpdatedAt(String time) {
    return 'обновлено в $time';
  }

  @override
  String get fcUpdatedJustNow => 'обновлено только что';

  @override
  String fcUpdatedMinAgo(int minutes) {
    return 'обновлено $minutes мин назад';
  }

  @override
  String fcUpdatedHoursAgo(int hours) {
    return 'обновлено $hours ч назад';
  }

  @override
  String fcUpdatedDate(String date) {
    return 'обновлено $date';
  }

  @override
  String fcOfflineUpdated(String age) {
    return 'нет сети · $age';
  }

  @override
  String get fcFactorGood => 'хорошо';

  @override
  String get fcFactorNeutral => 'нейтрально';

  @override
  String get fcFactorWeak => 'слабо';

  @override
  String get tabSpots => 'Места';

  @override
  String get spotsActiveTitle => 'Активная точка';

  @override
  String get spotsSavedTitle => 'Сохранённые места';

  @override
  String get spotsUseCurrent => 'Текущее местоположение';

  @override
  String get spotsEmpty =>
      'Пока нет сохранённых мест.\nДобавьте точку на карте.';

  @override
  String get spotsAddOnMap => 'Добавить на карте';

  @override
  String get spotPickerTitle => 'Выберите точку';

  @override
  String get spotNameHint => 'Название места (необязательно)';

  @override
  String get spotSaveBtn => 'Сохранить место';

  @override
  String get spotSaveActive => 'Сохранить';

  @override
  String get spotNameDialogTitle => 'Название места';

  @override
  String get spotEdit => 'Изменить';

  @override
  String spotDefaultName(int n) {
    return 'Место $n';
  }

  @override
  String get spotDeleted => 'Место удалено';

  @override
  String get spotDeleteConfirm => 'Удалить место?';

  @override
  String get spotSearchHint => 'Найти место';

  @override
  String get spotNothingFound => 'Ничего не найдено';

  @override
  String get spotLocationUnavailable => 'Не удалось определить местоположение';

  @override
  String get fcToday => 'Сегодня';

  @override
  String get fcTomorrow => 'Завтра';

  @override
  String get fcIndexCaption => 'Индекс клёва';

  @override
  String get fcBestWindow => 'Лучшее окно';

  @override
  String get fcBestWindowEmpty => 'Слабая активность весь день';

  @override
  String get fcHourlyTitle => 'По часам';

  @override
  String get fcWeekTitle => 'На 7 дней';

  @override
  String get fcUpcomingDays => 'Ближайшие дни';

  @override
  String get fcSeeWeek => 'Смотреть неделю';

  @override
  String get fcWhyTitle => 'Почему такой прогноз';

  @override
  String get fcHowItWorksBtn => 'Как работает прогноз';

  @override
  String get fcHowItWorksTitle => 'Как работает прогноз';

  @override
  String get fcHowItWorksP1Title => 'Умный алгоритм, а не рандом';

  @override
  String get fcHowItWorksP1Body =>
      'За каждым баллом — расчётная модель, которая ежедневно сводит воедино десятки погодных факторов: атмосферное давление и его перепады, силу и направление ветра, температуру воздуха и воды, облачность, осадки, фазу луны и сезон. Мы взвешиваем каждый и превращаем в один понятный балл клёва.';

  @override
  String get fcHowItWorksP2Title => 'Подстраиваемся под водоём';

  @override
  String get fcHowItWorksP2Body =>
      'Озеро, река, пруд и водохранилище живут по своим правилам. Алгоритм учитывает тип воды и её особенности, чтобы точнее подсказать, где и когда рыба вероятнее активна именно на вашем месте.';

  @override
  String get fcHowItWorksP3Title => 'Опираемся на поведение рыбы';

  @override
  String get fcHowItWorksP3Body =>
      'Рыба реагирует на погоду предсказуемо — ищет комфортную температуру, кислород и корм. Мы закладываем эти закономерности и превращаем их в конкретные рекомендации: где встать, на какой глубине искать и в какие часы ждать выхода.';

  @override
  String get fcHowItWorksP4Title => 'Лучшее время и место';

  @override
  String get fcHowItWorksP4Body =>
      'Мы считаем не только сегодня, но и дни вперёд и подсвечиваем лучшие окна клёва — чтобы вы планировали рыбалку на самый перспективный день и час, а не угадывали.';

  @override
  String get fcHowItWorksDisclaimer =>
      'Это вероятность, а не гарантия. На водоёме всегда смотрите по месту и экспериментируйте — точка, насадка, время.';

  @override
  String get storyTitle => 'Анатомия клёва';

  @override
  String get storySubtitle => 'Почему это не гадание на кофейной гуще';

  @override
  String get storyHookTitle => 'Клёв — не лотерея';

  @override
  String get storyHookBody =>
      'Рыба холоднокровна: у неё нет «настроения», есть реакция на воду и небо. Падает давление, теплеет вода, задул ветер — меняется аппетит. Мы научились читать эти сигналы и сводить в один балл. Вот из чего он складывается.';

  @override
  String get storyPressureTitle => 'Барометр и термометр';

  @override
  String get storyPressureBody =>
      'У рыбы есть встроенный барометр — плавательный пузырь. Резкий скачок давления её «оглушает», а плавное падение перед ненастьем, наоборот, включает жор. И всё это — на фоне температуры воды: она тащится за воздухом с задержкой (пруд оживает за пару дней, большое озеро — за недели), поэтому мы считаем не воздух, а инерцию воды под размер твоего водоёма. Холодно — рыба вялая у дна; прогрелось — пошла кормиться.';

  @override
  String get storyWindTitle => 'Ветер и час';

  @override
  String get storyWindBody =>
      'Ветер — друг рыболова: гонит тёплую воду и корм к подветренному берегу и насыщает кислородом — там и собирается рыба. А у каждого свой час: карп любит сумерки и тёплую ночь, карась — утреннюю зорьку, в жаркий полдень клёв проваливается. Луна добавляет чуть-чуть. Поэтому балл меняется не только по дням, но и по часам.';

  @override
  String get storyTypeTitle => 'У каждой воды свой характер';

  @override
  String get storyTypeBody =>
      'Озеро, река, пруд, канал и водохранилище живут по-своему. На большой воде рыба ходит за ветром, на реке держится поворотов, ям и тиховодья ниже перекатов, в маленьком пруду жмётся к камышу и коряжнику. Мы определяем твой водоём по карте OpenStreetMap — его тип и размер — и под это подстраиваем и прогрев воды, и подсказки, где искать рыбу именно у тебя.';

  @override
  String get storyFishTitle => 'Карп ≠ карась';

  @override
  String get storyFishBody =>
      'Один движок — два характера, и путать их нельзя. Карп — осторожный гурман: любит тёплую воду, плавное падение давления перед ненастьем и кормится даже ночью. Карась капризнее к перепадам, просыпается позже и быстро наедается, зато живуч до невозможного — душная тёплая лужа, где карпу тяжело, ему только в радость. Поэтому пороги температуры, реакцию на давление и время выхода мы считаем каждому по своему профилю.';

  @override
  String get storyTacticsTitle => 'Не только когда, но и как';

  @override
  String get storyTacticsBody =>
      'Мало знать, что сегодня клюёт — важно как. Подсказываем по реальной погоде дня: «барометр наживки» (в холод — мелкое и яркое: опарыш, кукуруза; в тепло — посытнее: бойлы, тигровый орех), какую оснастку поставить, где сесть и в какие часы ждать выхода. На прогреве кормим щедрее, на похолодании и в жару — скупее. Всё подстроено под воду и небо этого дня, а не «по старинке».';

  @override
  String get storyHonestTitle => 'Вероятность, а не гарантия';

  @override
  String get storyHonestBody =>
      'Будем честны: это оценка шансов, а не обещание улова. Глубину, рельеф дна, коряги и сколько рыбы реально стоит под тобой — со спутника не видно, и никакая модель этого не знает. Прогноз помогает выбрать удачный день, место и время — снять с рыбалки элемент лотереи. А дальше всё решаешь ты: пробуй точки, меняй насадки и горизонт, экспериментируй. В этом и весь кайф.';

  @override
  String get fcWhyHelps => 'Помогает';

  @override
  String get fcWhyHurts => 'Мешает';

  @override
  String get fcWhyNoCons => 'ограничений нет';

  @override
  String get fcWhyAnd => 'и';

  @override
  String fcWhyHelpsOne(Object factors) {
    return '$factors способствует клёву.';
  }

  @override
  String fcWhyHelpsMany(Object factors) {
    return '$factors способствуют клёву.';
  }

  @override
  String fcWhyHurtsOne(Object factors) {
    return '$factors снижает активность рыбы.';
  }

  @override
  String fcWhyHurtsMany(Object factors) {
    return '$factors снижают активность рыбы.';
  }

  @override
  String get fcWhyBalanced =>
      'Факторы сбалансированы — резких изменений клёва не ожидается.';

  @override
  String get fcPhrasePressurePos =>
      'стабильное давление держит рыбу у дна на кормёжке';

  @override
  String get fcPhrasePressureNeg => 'скачки давления сбивают рыбу с кормёжки';

  @override
  String get fcPhraseTemperaturePos =>
      'вода прогрелась до комфортной — у рыбы аппетит';

  @override
  String get fcPhraseTemperatureNeg =>
      'холодная вода замедляет рыбу, кормится она редко';

  @override
  String get fcPhraseWindPos => 'лёгкая рябь от ветра сбивает корм к берегу';

  @override
  String get fcPhraseWindNeg =>
      'сильный ветер гонит волну, рыба уходит на глубину';

  @override
  String get fcPhraseCloudPos =>
      'облачность приглушает свет, рыба смелее кормится';

  @override
  String get fcPhraseCloudNeg =>
      'яркое солнце настораживает рыбу, она прячется';

  @override
  String get fcPhrasePrecipPos =>
      'сухая ровная погода — рыба ведёт себя предсказуемо';

  @override
  String get fcPhrasePrecipNeg => 'осадки мутят воду и сбивают давление';

  @override
  String get fcPhraseSeasonPos => 'сезонный пик — рыба усиленно нагуливает вес';

  @override
  String get fcPhraseSeasonNeg =>
      'сезонный спад — обмен веществ у рыбы замедлен';

  @override
  String get fcPhraseMoonPos =>
      'активная фаза луны — пик клёва по лунному циклу';

  @override
  String get fcPhraseMoonNeg =>
      'слабая фаза луны — спад клёва по лунному циклу';

  @override
  String get fcConfidenceHigh => 'Высокая уверенность';

  @override
  String get fcConfidenceMedium => 'Средняя уверенность';

  @override
  String get fcConfidenceLow => 'Низкая уверенность';

  @override
  String get fcDayConditions => 'Погода днём';

  @override
  String get fcPeriodNight => 'Ночь';

  @override
  String get fcPeriodMorning => 'Утро';

  @override
  String get fcPeriodDay => 'День';

  @override
  String get fcPeriodEvening => 'Вечер';

  @override
  String get fcRateWeak => 'Слабо';

  @override
  String get fcRateMid => 'Средне';

  @override
  String get fcRateGood => 'Хорошо';

  @override
  String get fcRateGreat => 'Отлично';

  @override
  String get fcPeriodWhyTitle => 'Почему такая оценка';

  @override
  String get fcPeriodTimeEffect => 'Время суток';

  @override
  String get fcPeriodBaseTitle => 'Базовая обстановка';

  @override
  String get fcPeriodWater => 'Вода';

  @override
  String get fcTodAdjCaption => 'Поправка за время суток';

  @override
  String fcTodDawn(String sunrise) {
    return 'Рассвет около $sunrise — суточный пик кормёжки, поэтому период поднят над дневной базой.';
  }

  @override
  String fcTodDusk(String sunset) {
    return 'Закат около $sunset — перед темнотой рыба активно кормится, поэтому оценка поднята.';
  }

  @override
  String fcTodWarmNight(String water, String warm) {
    return 'Вода $water — на уровне тёплой ночи ($warm) или выше, рыба продолжает кормиться в темноте, поэтому ночная оценка держится у дневного уровня.';
  }

  @override
  String fcTodMidNight(String water, String cold, String warm) {
    return 'Вода $water — между холодным порогом ($cold) и тёплой ночью ($warm): ночью рыба кормится вполсилы, и чем теплее вода, тем активнее ночь.';
  }

  @override
  String fcTodColdNight(String water, String cold) {
    return 'Вода $water — ниже холодного порога ($cold): в холодной воде ночью рыба почти не двигается, поэтому оценка заметно ниже дневной.';
  }

  @override
  String fcTodMiddayHot(String temp, String heat) {
    return 'В полдень жарко ($temp, выше $heat) — рыба уходит в тень и на глубину, поэтому клёв проседает.';
  }

  @override
  String fcTodColdDay(String water, String cold) {
    return 'Вода холодная ($water, не выше $cold); дневной прогрев делает день относительно лучшим временем.';
  }

  @override
  String get fcTodDayNeutral =>
      'Дневные часы между зорьками — спокойная средняя активность.';

  @override
  String get spawnTitle => 'Нерестовое окно';

  @override
  String spawnPreSpawn(String water) {
    return 'Вода $water и растёт к нерестовой полосе — похоже на преднерестовое окно.';
  }

  @override
  String spawnSpawning(String water) {
    return 'Вода $water — в нерестовой полосе вида. Похоже на нерест.';
  }

  @override
  String spawnPostSpawn(String water) {
    return 'Вода $water прошла нерестовую полосу вверх — нерест, похоже, позади.';
  }

  @override
  String get spawnImpactPreSpawn =>
      'Перед нерестом часто жор — клёв высокий (≈70–90 из 100). Лови, пока окно открыто.';

  @override
  String get spawnImpactSpawning =>
      'Индекс выше нерест не учитывает. Если он действительно идёт, реальный клёв куда ниже — обычно ≈10–20 из 100, и так несколько дней.';

  @override
  String get spawnImpactPostSpawn =>
      'После нереста — жор: клёв снова высокий (≈70–90 из 100).';

  @override
  String get spawnCaveatEstimated =>
      'Это прогноз окна, а не точная дата — нерест на каждом водоёме идёт по-своему и волнами, а воду мы оцениваем по воздуху.';

  @override
  String get spawnCaveatRough =>
      'Это грубый прогноз: водоём крупный и инертный, нерест везде свой, а воду мы оцениваем по воздуху — сроки могут заметно плавать.';

  @override
  String get moonNew => 'Новолуние';

  @override
  String get moonWaxing => 'Растущая';

  @override
  String get moonFull => 'Полнолуние';

  @override
  String get moonWaning => 'Убывающая';

  @override
  String get fcHowToFish => 'Как ловить сегодня';

  @override
  String get fcHowToFishTomorrow => 'Как ловить завтра';

  @override
  String fcHowToFishOn(String date) {
    return 'Как ловить $date';
  }

  @override
  String get fcWhenTitle => 'Когда';

  @override
  String get fcWindowsLabel => 'Окна клёва';

  @override
  String get fcWindowDawn => 'утренняя зорька';

  @override
  String get fcWindowDusk => 'вечерняя зорька';

  @override
  String get fcWindowNight => 'ночной клёв';

  @override
  String get fcWindowMorning => 'утро';

  @override
  String get fcWindowEvening => 'вечер';

  @override
  String get fcWindowDay => 'днём';

  @override
  String get fcWindowsWhyDawn =>
      'Карп активнее всего на зорьке — рассвете и закате.';

  @override
  String get fcWindowsWhyNight => 'В тёплой воде карп активно кормится ночью.';

  @override
  String get fcWindowsWhyDay => 'Днём активность держит мягкая погода.';

  @override
  String get fcVerdictVeryLow => 'День слабый — клёв вялый, лучше переждать.';

  @override
  String get fcVerdictLow => 'Клёв слабый. Если ехать — точечно и терпеливо.';

  @override
  String get fcVerdictMedium => 'Средний день — без гарантий, но шанс есть.';

  @override
  String fcVerdictMediumWindow(String from, String to) {
    return 'Шанс есть — пробуй в окно $from–$to.';
  }

  @override
  String get fcVerdictGood => 'Хороший день — держи насадку в воде.';

  @override
  String fcVerdictGoodWindow(String from, String to) {
    return 'Стоит ехать. Лучшее время — $from–$to.';
  }

  @override
  String get fcVerdictExcellent => 'Отличный день — клёв активный!';

  @override
  String fcVerdictExcellentWindow(String from, String to) {
    return 'Отличный день! Не упусти окно $from–$to.';
  }

  @override
  String get fcLevelVeryLow => 'Очень слабый';

  @override
  String get fcLevelLow => 'Слабый';

  @override
  String get fcLevelMedium => 'Средний';

  @override
  String get fcLevelGood => 'Хороший';

  @override
  String get fcLevelExcellent => 'Отличный';

  @override
  String get fcFactorPressure => 'Давление';

  @override
  String get fcFactorTemperature => 'Температура воды';

  @override
  String get fcFactorWind => 'Ветер';

  @override
  String get fcFactorCloud => 'Облачность';

  @override
  String get fcFactorPrecipitation => 'Осадки';

  @override
  String get fcFactorSeason => 'Сезон';

  @override
  String get fcFactorMoon => 'Луна';

  @override
  String get fcCondClear => 'Ясно';

  @override
  String get fcCondPartly => 'Переменная облачность';

  @override
  String get fcCondCloudy => 'Пасмурно';

  @override
  String get fcCondRain => 'Дождь';

  @override
  String get fcCondStorm => 'Гроза';

  @override
  String get fcChipPressure => 'Давление';

  @override
  String get fcChipWind => 'Ветер';

  @override
  String get fcChipWater => 'Вода';

  @override
  String get fcChipTemp => 'Температура';

  @override
  String get fcChipMoon => 'Луна';

  @override
  String get fishCarp => 'Карп';

  @override
  String get fishCrucian => 'Карась';

  @override
  String get fishSheetTitle => 'Рыба';

  @override
  String get fcUnitHpaSuffix => 'гПа';

  @override
  String get fcUnitMmHgSuffix => 'мм рт. ст.';

  @override
  String get fcUnitMsSuffix => 'м/с';

  @override
  String get fcUnitKmhSuffix => 'км/ч';

  @override
  String get fcWindCalm => 'Штиль';

  @override
  String get fcWindN => 'С';

  @override
  String get fcWindNE => 'СВ';

  @override
  String get fcWindE => 'В';

  @override
  String get fcWindSE => 'ЮВ';

  @override
  String get fcWindS => 'Ю';

  @override
  String get fcWindSW => 'ЮЗ';

  @override
  String get fcWindW => 'З';

  @override
  String get fcWindNW => 'СЗ';

  @override
  String get tabAdvice => 'Тактика';

  @override
  String get adviceHeadline => 'Рекомендуемая тактика';

  @override
  String get adviceDisclaimer =>
      'Ориентир по прогнозу погоды, а не по конкретному водоёму.';

  @override
  String get adviceKindBait => 'Насадка';

  @override
  String get adviceKindFeeding => 'Прикормка';

  @override
  String get adviceKindDepth => 'Глубина';

  @override
  String get adviceKindLocation => 'Место';

  @override
  String get adviceKindTiming => 'Когда';

  @override
  String adviceWhyWater(String value) {
    return 'вода $value';
  }

  @override
  String get adviceWhyWaterRising => 'вода теплеет день ото дня';

  @override
  String get adviceWhyWaterFalling => 'вода остывает день ото дня';

  @override
  String adviceWhyAirHot(String value) {
    return 'жарко — воздух $value';
  }

  @override
  String adviceWhyWind(String value) {
    return 'ветер $value';
  }

  @override
  String get adviceWhyWindLight => 'слабый ветер';

  @override
  String get adviceWhyPressureFalling => 'давление падает';

  @override
  String get adviceWhyRain => 'днём дождь';

  @override
  String get adviceWhyBottomHabit => 'умеренная вода — рыба у дна';

  @override
  String get adviceWhyBiteHigh => 'высокий индекс клёва';

  @override
  String get adviceWhyBiteMid => 'средний индекс клёва';

  @override
  String get adviceWhyBiteLow => 'низкий индекс клёва';

  @override
  String get adviceWhyBestHours => 'в это время индекс максимальный';

  @override
  String get windFullN => 'северный';

  @override
  String get windFullNE => 'северо-восточный';

  @override
  String get windFullE => 'восточный';

  @override
  String get windFullSE => 'юго-восточный';

  @override
  String get windFullS => 'южный';

  @override
  String get windFullSW => 'юго-западный';

  @override
  String get windFullW => 'западный';

  @override
  String get windFullNW => 'северо-западный';

  @override
  String get adviceBaitColdBrightTitle => 'Яркая мелкая насадка';

  @override
  String get adviceBaitColdBrightBody =>
      'Холодная вода — кукуруза, опарыш, мелкий пеллет. Карп ест мало и осторожно.';

  @override
  String get adviceBaitMidBoiliesTitle => 'Бойлы и пеллетс';

  @override
  String get adviceBaitMidBoiliesBody =>
      'Вода прогревается — бойлы 10–16 мм и пеллетс. Карп активнее.';

  @override
  String get adviceBaitWarmFishmealTitle => 'Фишмил-бойлы';

  @override
  String get adviceBaitWarmFishmealBody =>
      'Тёплая вода, пик аппетита — насыщенные fishmeal-бойлы, тигровый орех, кукуруза.';

  @override
  String get adviceBaitHotSurfaceTitle => 'Плавающие насадки';

  @override
  String get adviceBaitHotSurfaceBody =>
      'Жара поднимает карпа вверх — поп-апы, плавающий пеллет, немного хлеба.';

  @override
  String get adviceBaitWarmingTitle => 'Крупнее и ароматнее';

  @override
  String get adviceBaitWarmingBody =>
      'Тёплый тренд — карп активизируется. Бойлы, тигровый орех, ароматика.';

  @override
  String get adviceBaitCoolingTitle => 'Мельче и ярче';

  @override
  String get adviceBaitCoolingBody =>
      'Вода падает — рыба осторожничает. Мелкий пеллет, кукуруза, опарыш.';

  @override
  String get adviceFeedMinimalTitle => 'Корми скупо';

  @override
  String get adviceFeedMinimalBody =>
      'Пара горстей точечно — не перекармливай пассивную рыбу.';

  @override
  String get adviceFeedModerateTitle => 'Умеренный закорм';

  @override
  String get adviceFeedModerateBody =>
      'Средний объём; докармливай регулярно небольшими порциями.';

  @override
  String get adviceFeedHeavyTitle => 'Обильный закорм';

  @override
  String get adviceFeedHeavyBody =>
      'Карп жадно кормится — стартовый закорм и частые докормы оправданы.';

  @override
  String get adviceRigBottomTitle => 'Лови со дна';

  @override
  String get adviceRigBottomBody =>
      'Донный монтаж у дна или на бровке — классическая карповая оснастка.';

  @override
  String get adviceRigZigTitle => 'Попробуй зиг-риг';

  @override
  String get adviceRigZigBody =>
      'Рыба стоит в толще — зиг в 1–2 м от дна выручит.';

  @override
  String get adviceRigSurfaceTitle => 'Лови с поверхности';

  @override
  String get adviceRigSurfaceBody =>
      'Карп греется у поверхности — поверхностная снасть и плавающая насадка.';

  @override
  String get adviceSwimWindwardTitle => 'Лови «в ветер»';

  @override
  String adviceSwimWindwardBody(String dir) {
    return 'Ветер $dir — тёплую воду и корм несёт к дальнему берегу, рыба кормится там.';
  }

  @override
  String get adviceSwimCalmFeaturesTitle => 'Ищи укрытия';

  @override
  String get adviceSwimCalmFeaturesBody =>
      'Слабый ветер — облавливай бровки, коряги, камыш и перепады глубин.';

  @override
  String get adviceSwimShelteredTitle => 'Уходи на глубину или в тень';

  @override
  String get adviceSwimShelteredBody =>
      'В жару ищи прохладные глубокие участки и затенённые зоны.';

  @override
  String get adviceTimePressureDropTitle => 'Окно перед фронтом';

  @override
  String get adviceTimePressureDropBody =>
      'Давление падает — впереди всплеск активности. Не упусти ближайшие часы.';

  @override
  String get adviceTimeBestWindowTitle => 'Лучшее окно сегодня';

  @override
  String adviceTimeBestWindowBody(String from, String to) {
    return 'Пик активности примерно $from–$to. Будь на точке заранее.';
  }

  @override
  String get adviceTimeDawnDuskTitle => 'Рассвет и закат';

  @override
  String get adviceTimeDawnDuskBody =>
      'Ставка на раннее утро и поздний вечер — самый стабильный клёв.';

  @override
  String get adviceTimeAllDayTitle => 'Активно весь день';

  @override
  String get adviceTimeAllDayBody =>
      'Высокий индекс — карп кормится в течение дня, держи насадку в воде.';

  @override
  String get adviceTimeSlowPatientTitle => 'Лови терпеливо';

  @override
  String get adviceTimeSlowPatientBody =>
      'Рыба пассивна — точечная подача, тонкие оснастки, жди выхода.';

  @override
  String get crucianBaitColdAnimalTitle => 'Животная насадка';

  @override
  String get crucianBaitColdAnimalBody =>
      'Холодная вода — мелкий мотыль и опарыш. Подавай по одной-две личинки, карась ест вяло.';

  @override
  String get crucianBaitWarmingTitle => 'Червь и опарыш';

  @override
  String get crucianBaitWarmingBody =>
      'Вода теплеет — карась активизируется. Навозный червь, пучок опарыша, мотыль.';

  @override
  String get crucianBaitCoolingTitle => 'Мельче и мягче';

  @override
  String get crucianBaitCoolingBody =>
      'Похолодание — карась капризничает. Мелкий мотыль или бутерброд, насадка помягче.';

  @override
  String get crucianBaitSandwichTitle => 'Бутерброд';

  @override
  String get crucianBaitSandwichBody =>
      'Переходная вода — бутерброд: опарыш с перловкой или кукурузой. Карась перебирает.';

  @override
  String get crucianBaitWarmPlantTitle => 'Растительная насадка';

  @override
  String get crucianBaitWarmPlantBody =>
      'Тёплая вода — перловка, манная болтушка, кукуруза, тесто. Карась переходит на растительное.';

  @override
  String get crucianBaitHotDoughTitle => 'Мягкое тесто';

  @override
  String get crucianBaitHotDoughBody =>
      'Жара — мягкое тесто, манная болтушка, мякиш. Лёгкая сладкая насадка у поверхности.';

  @override
  String get crucianFeedTinyTitle => 'Корми точечно';

  @override
  String get crucianFeedTinyBody =>
      'Карась пуглив и легко наедается — несколько щепоток мелкой сладкой прикормки, не больше.';

  @override
  String get crucianFeedSweetTitle => 'Сладкая прикормка';

  @override
  String get crucianFeedSweetBody =>
      'Мелкая фракция с ароматом чеснока или ванили; докармливай по чуть-чуть, не перекорми.';

  @override
  String get crucianFeedActiveTitle => 'Активный закорм';

  @override
  String get crucianFeedActiveBody =>
      'Карась кормится охотно — корми чаще, но малыми порциями, держи стаю на точке.';

  @override
  String get crucianRigFloatBottomTitle => 'Поплавок у дна';

  @override
  String get crucianRigFloatBottomBody =>
      'Классика по карасю — поплавочная снасть, насадка лежит или чуть касается дна.';

  @override
  String get crucianRigDropperTitle => 'Подпасок и спуск';

  @override
  String get crucianRigDropperBody =>
      'Карась поднялся в полводы — медленно тонущая насадка, разнеси грузила, лови вполводы.';

  @override
  String get crucianRigShallowTitle => 'Мелководье у поверхности';

  @override
  String get crucianRigShallowBody =>
      'В жару карась греется на мели — лёгкая оснастка, насадка в верхнем слое тёплой воды.';

  @override
  String get crucianSwimReedsTitle => 'Кромка камыша';

  @override
  String get crucianSwimReedsBody =>
      'Облавливай окна в траве, кромку камыша и заросшие участки — там карась кормится.';

  @override
  String get crucianSwimWarmShallowsTitle => 'Прогретое мелководье';

  @override
  String get crucianSwimWarmShallowsBody =>
      'Вода холодная — ищи самые тёплые мелководья и заливы, прогретые солнцем.';

  @override
  String get crucianSwimDeepEdgeTitle => 'Приямки и тень';

  @override
  String get crucianSwimDeepEdgeBody =>
      'В зной карась уходит с мели — облавливай приямки, бровки и затенённые зоны.';

  @override
  String get crucianTimePressureDropTitle => 'Лови терпеливо';

  @override
  String get crucianTimePressureDropBody =>
      'Давление падает — карась капризничает и пассивен. Мелкие мягкие насадки, жди коротких выходов.';

  @override
  String get crucianTimeBestWindowTitle => 'Лучшее окно сегодня';

  @override
  String crucianTimeBestWindowBody(String from, String to) {
    return 'Пик активности примерно $from–$to. Будь на точке заранее.';
  }

  @override
  String get crucianTimeMorningTitle => 'Утренняя зорька';

  @override
  String get crucianTimeMorningBody =>
      'Ставка на раннее утро — классический карасёвый выход, до жары.';

  @override
  String get crucianTimeStableWarmTitle => 'Активен и днём';

  @override
  String get crucianTimeStableWarmBody =>
      'Стабильное тепло — карась кормится в течение дня, держи насадку в воде.';

  @override
  String get crucianTimePatientTitle => 'Точечно и терпеливо';

  @override
  String get crucianTimePatientBody =>
      'Карась пассивен — тонкая оснастка, мелкая насадка, облавливай точку и жди выхода.';

  @override
  String get spotTitle => 'Твоё место';

  @override
  String get spotNoWater =>
      'Рядом с этой точкой не вижу водоёма на карте. Прогноз по погоде работает и так — задай место, чтобы разобрать водоём.';

  @override
  String get spotSetOnMap => 'Задать место на карте';

  @override
  String get spotCheckFailed =>
      'Не удалось проверить карту — прогноз по погоде работает.';

  @override
  String get spotTypeLake => 'Озеро';

  @override
  String get spotTypePond => 'Пруд';

  @override
  String get spotTypeReservoir => 'Водохранилище';

  @override
  String get spotTypeRiver => 'Река';

  @override
  String get spotTypeCanal => 'Канал';

  @override
  String get spotTypeWater => 'Водоём';

  @override
  String spotSizeHa(String value) {
    return '~$value га';
  }

  @override
  String spotSizeKm2(String value) {
    return '~$value км²';
  }

  @override
  String spotTipWindward(String bank) {
    return 'Тёплый ветер гонит корм и тёплую воду к подветренному берегу — рыба, вероятно, активнее там. Активный берег: $bank.';
  }

  @override
  String spotTipSheltered(String bank) {
    return 'Ветер холоднее воды — рыба уходит с продуваемого берега в затишье. Защищённый берег: $bank.';
  }

  @override
  String get spotTipNoWind =>
      'Ветра почти нет — выраженного берега сегодня нет; рыба распределена по структурам и глубинам.';

  @override
  String get spotTipColdWater =>
      'Вода холодная — рыба у дна и в ямах, пассивна; ветер сейчас почти не двигает её.';

  @override
  String get spotWhereRiver =>
      'Ищи тиховодье: омуты, внешние повороты, ниже перекатов, у коряг и опор мостов.';

  @override
  String get spotWhereCanal =>
      'Канал ровный — ищи аномалии: повороты, мосты, впадения и заросший берег.';

  @override
  String get spotWherePondSmall =>
      'Небольшой водоём греется быстро — рыба у камыша, коряг и уреза, в жару уходит глубже.';

  @override
  String get spotWhereMid =>
      'Средний водоём — облавливай заливы, свалы в глубину и заросшие участки.';

  @override
  String get spotWhereLarge =>
      'Крупный водоём — рыба подвижна; ищи мысы, свалы и работай по ветру.';

  @override
  String get spotWhereUnknown =>
      'Стоячая вода — ищи камыш, коряги, свалы и заливы.';

  @override
  String get spotSourceType => 'по типу водоёма';

  @override
  String get spotEditTitle => 'Положение места';

  @override
  String get spotEditHint =>
      'Двигайте карту, чтобы поставить метку — при необходимости перенесите её на нужный берег.';

  @override
  String get spotSavePosition => 'Сохранить положение';

  @override
  String get spotViewOnMap => 'Посмотреть на карте';

  @override
  String get spotWindLabel => 'Ветер дует';

  @override
  String spotWindFrom(String dir) {
    return 'Ветер дует $dir';
  }

  @override
  String get spotDirN => 'с севера';

  @override
  String get spotDirNE => 'с северо-востока';

  @override
  String get spotDirE => 'с востока';

  @override
  String get spotDirSE => 'с юго-востока';

  @override
  String get spotDirS => 'с юга';

  @override
  String get spotDirSW => 'с юго-запада';

  @override
  String get spotDirW => 'с запада';

  @override
  String get spotDirNW => 'с северо-запада';

  @override
  String get spotUserHere =>
      'Твоё место уже на активном берегу — ты в правильном месте.';

  @override
  String get spotUserOpposite =>
      'Твоё место на другой стороне — возможно, активнее у противоположного берега.';

  @override
  String get spotSourceMap => 'По данным карты OpenStreetMap';

  @override
  String get spotSourceWind => 'по ветру и температуре воды';

  @override
  String get spotDisclaimer =>
      'Это оценка обстановки по карте и погоде — глубину, дно и запас рыбы мы не видим.';

  @override
  String get settingsAlertsPrimeTitle => 'Лучший день недели';

  @override
  String get settingsAlertsPrimeSubtitle =>
      'Один пуш о самом клёвом дне недели по твоим местам';

  @override
  String get settingsAlertsExcellentTitle => 'Все отличные дни';

  @override
  String get settingsAlertsExcellentSubtitle =>
      'Пуш вечером накануне каждого дня с отличным клёвом';

  @override
  String get settingsAlertsForCarp => 'Уведомления по карпу';

  @override
  String get settingsAlertsForCrucian => 'Уведомления по карасю';

  @override
  String alertTitlePrime(String fish) {
    return '$fish: лучший день недели';
  }

  @override
  String alertTitleExcellent(String fish) {
    return '$fish: завтра отличный клёв';
  }

  @override
  String get alertWindowDawn => 'завтра на зорьке';

  @override
  String get alertWindowDusk => 'завтра на вечерней зорьке';

  @override
  String get alertWindowDay => 'завтра днём';

  @override
  String get alertWindowNight => 'завтра ночью';

  @override
  String get alertWindowAny => 'завтра';

  @override
  String get alertSpotFallback => 'Твоё место';

  @override
  String alertBody(String spot, String when, int index) {
    return '$spot: $when, индекс клёва $index';
  }
}
