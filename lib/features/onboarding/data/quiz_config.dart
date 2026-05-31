import '../../../l10n/app_localizations.dart';

// Карповый онбординг-квиз: короткий функциональный (вид рыбы → боль → стиль
// планирования → частота). Вид рыбы прокидывается в selectedFishProvider при
// завершении; планирование/боль праймят ценность 7-дневного прогноза (premium).
// Геттер-функции от AppLocalizations поддерживают i18n.

typedef L10nGetter = String Function(AppLocalizations);

class QuizOption {
  const QuizOption({required this.value, required this.label});

  final String value;
  final L10nGetter label;
}

class QuizStep {
  const QuizStep({
    required this.id,
    required this.storeAs,
    required this.question,
    required this.subtitle,
    required this.options,
    this.image,
  });

  final String id;
  final String storeAs;
  final L10nGetter question;
  final L10nGetter subtitle;
  final List<QuizOption> options;

  /// Иллюстрация над вопросом (asset path), опционально.
  final String? image;
}

// Ключ ответа на вопрос о виде рыбы — читается при завершении онбординга.
const kSpeciesAnswerKey = 'species';
const kSpeciesCarp = 'carp';
const kSpeciesCrucian = 'crucian';
const kSpeciesBoth = 'both';

final kQuizSteps = <QuizStep>[
  QuizStep(
    id: 'q_species',
    storeAs: kSpeciesAnswerKey,
    image: 'assets/images/onboarding/q1.png',
    question: (l) => l.quizQ1Question,
    subtitle: (l) => l.quizQ1Subtitle,
    options: [
      QuizOption(value: kSpeciesCarp, label: (l) => l.quizQ1OptLearn),
      QuizOption(value: kSpeciesCrucian, label: (l) => l.quizQ1OptHabit),
      QuizOption(value: kSpeciesBoth, label: (l) => l.quizQ1OptSolve),
    ],
  ),
  QuizStep(
    id: 'q_pain',
    storeAs: 'pain',
    image: 'assets/images/onboarding/q2.png',
    question: (l) => l.quizQ2Question,
    subtitle: (l) => l.quizQ2Subtitle,
    options: [
      QuizOption(value: 'often', label: (l) => l.quizQ2OptDaily),
      QuizOption(value: 'sometimes', label: (l) => l.quizQ2OptWeekly),
      QuizOption(value: 'rarely', label: (l) => l.quizQ2OptRarely),
    ],
  ),
  QuizStep(
    id: 'q_planning',
    storeAs: 'planning',
    image: 'assets/images/onboarding/q3.png',
    question: (l) => l.quizQ3Question,
    subtitle: (l) => l.quizQ3Subtitle,
    options: [
      QuizOption(value: 'ahead', label: (l) => l.quizQ3OptSimple),
      QuizOption(value: 'spontaneous', label: (l) => l.quizQ3OptResult),
      QuizOption(value: 'varies', label: (l) => l.quizQ3OptFlexible),
    ],
  ),
  QuizStep(
    id: 'q_frequency',
    storeAs: 'frequency',
    image: 'assets/images/onboarding/q4.png',
    question: (l) => l.quizQ4Question,
    subtitle: (l) => l.quizQ4Subtitle,
    options: [
      QuizOption(value: 'weekly', label: (l) => l.quizQ4OptWeekly),
      QuizOption(value: 'monthly', label: (l) => l.quizQ4OptMonthly),
      QuizOption(value: 'rarely', label: (l) => l.quizQ4OptRarely),
    ],
  ),
];
