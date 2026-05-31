# Funnel Schema — спецификация

Один движок рендерит и онбординг, и пейволл из одного JSON-файла. Под новый MVP меняется только JSON, код шаблона не трогается.

## 1. Топ-уровень

```jsonc
{
  "version": 1,
  "id": "default",
  "locale": { "default": "ru", "supported": ["ru", "en"] },
  "steps": [ /* массив шагов в порядке показа */ ],
  "paywall": { /* конфиг главного пейволла */ },
  "exitOffer": { /* опционально: пейволл со скидкой при попытке закрыть */ }
}
```

## 2. Локализованные строки

Любое поле с текстом принимает **либо** обычную строку, **либо** объект с локалями.

```jsonc
"title": "Привет"                                  // одна локаль
"title": { "ru": "Привет", "en": "Hi" }            // несколько локалей
```

Движок выбирает по системной локали, фоллбэк на `locale.default`.

## 3. Шаблоны в текстах

В любом тексте можно подставить значения из хранилища ответов:

```
{{answer.goal}}              значение из квиза по ключу storeAs:"goal"
{{answer.weight | "вес"}}    с дефолтом
{{user.name}}                имя из auth (если есть)
{{plan.target_date}}         вычисляемое значение (рассчитанное приложением)
```

## 4. Условный показ

Любой `step` или `block` можно скрыть на основе ответов:

```jsonc
"showIf": { "key": "answer.gender", "equals": "female" }
```

Операторы: `equals`, `notEquals`, `in`, `notIn`, `greaterThan`, `lessThan`.

## 5. Типы шагов (`step.type`)

Каждый шаг имеет обязательное `id` (уникальный, идёт в аналитику) и `type`.

### `welcome`
```jsonc
{
  "id": "welcome",
  "type": "welcome",
  "hero": { "kind": "lottie", "asset": "assets/anim/welcome.json", "aspectRatio": 1 },
  "title": "Достигни цели быстрее",
  "subtitle": "Персональный план за 60 секунд",
  "cta": { "label": "Начать" },
  "secondary": { "label": "У меня уже есть аккаунт", "action": "login" }
}
```

### `quiz`
Универсальный шаг для всех типов вопросов. Тип ввода — в `input.kind`.

```jsonc
{
  "id": "q_goal",
  "type": "quiz",
  "question": "Какая ваша главная цель?",
  "subtitle": "Влияет на ваш план",
  "input": {
    "kind": "single",                         // single | multi | slider | swipe | text | number
    "options": [
      { "value": "lose", "label": "Сбросить вес", "icon": "scale" },
      { "value": "gain", "label": "Набрать массу", "icon": "barbell" },
      { "value": "tone", "label": "Подтянуть тело", "icon": "yoga" }
    ]
  },
  "storeAs": "goal",                          // ключ в AnswersStore
  "required": true,
  "showProgress": true
}
```

Вариации `input.kind`:
- `single` — radio, `options: [{value, label, icon?}]`
- `multi` — checkbox, `options` + `min`, `max`
- `slider` — `min`, `max`, `step`, `unit`, `default`
- `swipe` — Tinder-карточки, `options` + `actions: ["yes","no","skip"]`
- `text` — `placeholder`, `maxLength`, `validate: "email"|"none"`
- `number` — `placeholder`, `min`, `max`, `unit`

### `socialProof`
```jsonc
{
  "id": "social_proof_1",
  "type": "socialProof",
  "rating": 4.7,
  "reviewCount": 28000,
  "userCountLabel": "5 000 000+ людей доверяют",
  "testimonials": [
    { "author": "Анна, 28", "text": "Сбросила 6 кг за месяц", "avatar": "assets/img/t1.png" }
  ],
  "cta": { "label": "Продолжить" }
}
```

### `goalCommitment`
```jsonc
{
  "id": "commit",
  "type": "goalCommitment",
  "title": "Ваша цель: {{answer.goal}}",
  "subtitle": "Подтвердите — мы построим план под неё",
  "cta": { "label": "Подтверждаю" }
}
```

### `loader`
```jsonc
{
  "id": "loader_plan",
  "type": "loader",
  "title": "Строим ваш план",
  "stages": [
    { "label": "Анализируем ответы", "durationMs": 1500 },
    { "label": "Подбираем план", "durationMs": 2000 },
    { "label": "Персонализируем", "durationMs": 1500 }
  ]
}
```

### `personalizedResult`
```jsonc
{
  "id": "result",
  "type": "personalizedResult",
  "title": "Ваш план готов",
  "highlights": [
    { "icon": "target", "label": "Цель: {{answer.goal}}" },
    { "icon": "calendar", "label": "Срок: {{plan.weeks}} недель" },
    { "icon": "chart", "label": "Ожидаемый результат: {{plan.expected}}" }
  ],
  "cta": { "label": "Получить план" }
}
```

### `permissionPriming`
Кастомный экран ПЕРЕД системным диалогом. На `allow` запускает OS-диалог, на `skip` идёт дальше.
```jsonc
{
  "id": "perm_notif",
  "type": "permissionPriming",
  "permission": "notifications",              // notifications | tracking
  "illustration": "assets/img/notif.png",
  "title": "Не сбейтесь с цели",
  "subtitle": "Напомним в нужное время",
  "allowLabel": "Включить",
  "skipLabel": "Не сейчас"
}
```

### `paywall`
Главный пейволл. Сама структура блоков описана в разделе 6.
```jsonc
{ "id": "paywall_main", "type": "paywall", "ref": "paywall" }
```
Поле `ref` указывает, какой пейволл-конфиг тянуть из топ-уровня (`paywall` или `exitOffer`).

## 6. Анатомия пейволла (`paywall` на топ-уровне)

```jsonc
"paywall": {
  "close": { "delayMs": 3000, "position": "topRight" },

  "hero": { "kind": "lottie", "asset": "assets/anim/hero.json", "aspectRatio": 1.2 },

  "headline": {
    "title": "Начни путь к {{answer.goal}}",
    "subtitle": "Полный доступ ко всем функциям"
  },

  "benefits": {
    "items": [
      { "icon": "check", "text": "Персональный план под ваши цели" },
      { "icon": "infinity", "text": "Безлимитный доступ ко всем функциям" },
      { "icon": "chart", "text": "Прогресс и аналитика" },
      { "icon": "support", "text": "Поддержка 24/7" }
    ]
  },

  "socialProof": {
    "rating": 4.7,
    "reviewCount": 28000,
    "userCountLabel": "5M+ человек уже с нами"
  },

  "pricing": {
    "packages": ["$rc_annual", "$rc_weekly"],   // RevenueCat package IDs
    "default": "$rc_annual",
    "badges": { "$rc_annual": "Save 60%" },
    "showPricePerDay": true,
    "layout": "stacked"                          // stacked | tabs
  },

  "trialTimeline": {
    "enabled": true,
    "days": 7,
    "reminderDay": 5,
    "appliesTo": "$rc_annual"
  },

  "cta": {
    "label": "Начать бесплатно",
    "sublabel": "Без оплаты сейчас. Отмена в любой момент",
    "sticky": true
  },

  "finePrint": {
    "showRestore": true,
    "termsUrl": "https://example.com/terms",
    "privacyUrl": "https://example.com/privacy",
    "autoRenewDisclosure": true
  }
}
```

## 7. Exit Offer (опционально)

Срабатывает, когда пользователь пытается закрыть `paywall`. Структура та же, но обычно с другим тарифом и countdown:

```jsonc
"exitOffer": {
  "trigger": "onPaywallClose",
  "countdownSec": 300,                          // 5 минут до экспирации
  "headline": { "title": "Подождите — есть особое предложение" },
  "hero": { "kind": "image", "asset": "assets/img/gift.png" },
  "pricing": { "packages": ["$rc_weekly_50off"], "default": "$rc_weekly_50off" },
  "cta": { "label": "Забрать -50%" },
  "finePrint": { "showRestore": false, "termsUrl": "...", "privacyUrl": "..." }
}
```

## 8. Аналитика

Движок автоматически эмитит события для каждого шага:
- `funnel_step_view` — `{step_id, type, index}`
- `funnel_step_complete` — `{step_id, time_ms, answer?}`
- `funnel_step_skip` — `{step_id}`
- `paywall_view`, `paywall_close`, `paywall_purchase_start`, `paywall_purchase_success`, `paywall_purchase_failed`, `paywall_restore`
- `exit_offer_view`, `exit_offer_purchase`

Дополнительные имена событий можно переопределить через поле `analyticsName` на любом шаге.

## 9. Где живёт JSON

- По умолчанию: `assets/funnel/funnel.json` — бандлится в приложение
- Опционально: подмена через Remote Config (Supabase / RevenueCat Paywalls) — добавим позже, для MVP не нужно

## 10. AnswersStore

- Хранится в `SharedPreferences` под ключом `funnel_answers_<funnel_id>`
- Очищается на `restart` или после успешной покупки
- Доступ через `ref.read(answersProvider)` в коде, и через `{{answer.<key>}}` в текстах

## 11. Что НЕ покрывает MVP-схема (намеренно)

- Branching на разветвлённые ветки (только линейный поток с `showIf`)
- Видео-hero с inline-плеером (только static + Lottie)
- Inline-комментарии "продолжай прокрутку"
- A/B-тестирование на уровне JSON (делается через подмену JSON по варианту в Remote Config)
- Web-fallback (только нативные iOS+Android)
