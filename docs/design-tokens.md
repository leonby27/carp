# Design tokens — BaseApp

Извлечены из BodyMeal (production Flutter-приложение того же автора). Это style guide для всех будущих MVP, собранных из шаблона.

## Скругления (`borderRadius`)

| Элемент | Radius |
|---|---|
| Карточки (option, plan, FAQ, feature, social-proof) | **24** |
| Кнопки CTA | **20** |
| Input fields | **12** |
| Шевроны, мелкие иконки | **8** |
| Pills (back-кнопка, флаги, kebab) | **122** (фактически овал) |
| Header section (только нижние углы) | `BorderRadius.only(bottomLeft/Right: 24)` |

## Высоты и размеры

| Элемент | Размер |
|---|---|
| Основной CTA | **56–60px** |
| Pill back/kebab | **46×36px** |
| Иконка в pill | **24px** (back), 20px (kebab) |
| Progress bar | **height: 12** |
| Loading circular | **100×100, stroke: 6** |
| Plan checkbox | **24×24** |

## Spacing

Система 4/8:
- **Horizontal content padding**: 16 (стандарт), 20–24 (заголовки/карточки)
- **Vertical gaps**: 8 (tight) / 12 (regular) / 16 (section) / 20 (внутри карточки)
- **Inside cards**: `padding: 20`

## Анимации — durations

| Тип | Длительность |
|---|---|
| Fade / opacity | **300ms** (стандарт), 260ms (cross-fade), 240ms (popup) |
| Scale / selection toggle | **180–200ms** |
| Slide между шагами | **300ms forward, 250ms reverse** |
| Collapse / expand (FAQ, sheet) | **200ms** |
| Loading total | **6000ms** (captions меняются каждые 1200ms) |
| Progress bar tween | **300ms** |

## Curves

- `Curves.easeOut` — стандарт для appearance / выезда
- `Curves.easeOutCubic` — агрессивный выезд (step transitions, selection)
- `Curves.easeInCubic` — уезд элементов (reverse phase)
- `Interval(start, end, curve: ...)` — для фазированных stagger-анимаций

## Тени

**`AppColors.baseDrop`** — мягкая 4-слойная тень для white-on-white карточек (онбординг, paywall header). Используется когда нужно поднять элемент над scaffold без жёсткой границы.

**`AppTheme.lightBarShadow`** — для top-bar и bottom-nav.

В **dark mode**: тени обычно убираются (`isDark ? null : AppColors.baseDrop`).

## Цветовые правила

**Когда что использовать:**

| Контекст | Цвет |
|---|---|
| Brand / интерактив (progress, ссылки, иконки) | `AppColors.primary` (`#317BFF`) |
| Главная CTA-кнопка | `AppColors.onboardingCtaBg` (`#0E1220` — почти чёрный) |
| Hover/focus подсветка | `AppColors.primaryLight` (`#EAF2FF`) |
| Фон selected-карточки (light) | `AppColors.onboardingClickableBg` (`#EFF2F6`) |
| Фон unselected-карточки | `AppColors.lightSurface` (белый) |
| Scaffold | `AppColors.lightBack3` (белый) или `lightScaffold` (`#F5F6F8`) для карточечных секций |
| Основной текст | `cs.onSurface` (`#0A1B39`) |
| Secondary текст | `cs.onSurfaceVariant` (`#83899F`) |
| Контрастный muted | `AppColors.lightSecondaryDark` (`#676E85`) |

**Selection states:**
- Selected: бг светло-серый (`onboardingClickableBg`) + 2px primary border
- Unselected: белый + 1px `lightDivider`
- Press feedback: `AnimatedScale(0.97)`

## Типографика

**Title style helper** (`_title_style.dart` в BodyMeal):
- Базовый: Inter 24px / w700
- Для латиницы (en/de/es/fr/pt/pl): Google Fonts "Momo Trust Display" (более marketing-look)
- Для ru/др кириллицы: Inter fallback
- Параметризуется fontSize / weight / color / height / letterSpacing

**Иерархия:**

| Уровень | Размер / вес |
|---|---|
| Hero-заголовок (welcome, paywall) | 24 / w700 (Inter или Momo) |
| Section title (FAQ, plan) | 18 / w600 |
| Card title (plan, benefit) | 16 / w600 |
| Body subtitle | 16 / w500, height 22/16 |
| Small label / caption | 14 / w500 |

**Letter spacing**: 0 (явно сбрасывается через `DefaultTextStyle.merge`, чтобы убрать Material-дефолт 0.25).

## Layout-паттерны

### Sticky CTA
```
Stack:
  SingleChildScrollView (контент)
    padding-bottom: contentBottomPadding (рассчитано чтобы не перекрыть CTA)
  Positioned(bottom: 0)
    Container с CTA
```

### Progress header (онбординг)
- Container с `BorderRadius.only(bottomLeft/Right: 24)`
- Высота: `topInset + 64`
- baseDrop shadow
- Row: [back pill 46×36 | Spacer | progress bar (Expanded) | Spacer | phantom 46×36]
- Phantom spacer справа для центрирования прогресс-бара
- Progress bar: `TweenAnimationBuilder<double>(duration: 300ms, curve: easeInOut)` → `ClipRRect(radius: 12) > LinearProgressIndicator`

### Step transitions (между шагами онбординга)
Направленный slide + fade:
```dart
final slideBegin = isForward
    ? (isIncoming ? 0.25 : -0.15)
    : (isIncoming ? -0.25 : 0.15);
final slide = Tween<Offset>(begin: Offset(slideBegin, 0), end: Offset.zero);
final fade = isIncoming ? Interval(0.0, 0.6, curve: easeOut) : full;
// duration: 300ms forward, 250ms reverse
```

### Selection card animation
```dart
AnimatedScale(scale: isSelected ? 1.0 : 0.97, duration: 180ms, curve: easeOutCubic)
AnimatedContainer(...border, bg color, 180ms, easeOutCubic)
```

### Loading screen
- Центрированный 100×100 circular progress (value: 0–1, stroke: 6)
- В центре — процент текстом
- Под ним — caption через `AnimatedSwitcher` (fade 300ms, ValueKey по индексу), меняется каждые 1200ms
- Master timeline 6 секунд (5 этапов × 1200ms)

### FAQ card
- Container 20px padding, radius 24
- Header tap → `AnimatedRotation(turns: isOpen ? 0.5 : 0)` для шеврона
- Контент через `AnimatedSize(duration: 200ms, curve: easeOutCubic)`
- Закрыт → `SizedBox.shrink()`, открыт → текст ответа

## Что отличает BodyMeal от обычных Material-приложений

1. **Радиусы крупнее обычного** — 24 для карточек вместо стандартных 12-16
2. **Тёмная CTA на белом скаффолде** вместо primary blue (приём против "цветового доминирования")
3. **Pill back-кнопка** в овальной форме вместо квадратной IconButton
4. **letterSpacing: 0** везде — убирает Material дефолт
5. **Phantom spacer** в header'е для true-центрирования прогресс-бара
6. **Направленные slide-переходы** (back vs forward с разной длительностью и направлением)
7. **4-слойная baseDrop тень** вместо одиночной — более естественный effekt
