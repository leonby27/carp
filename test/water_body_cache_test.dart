import 'dart:convert';

import 'package:app/core/persistence/prefs_service.dart' as prefs_service;
import 'package:app/features/spots/application/spots_providers.dart';
import 'package:app/features/spots/data/overpass_client.dart';
import 'package:app/features/spots/domain/water_body.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// relation-полигон с геометрией членов — точка внутри, водоём распознан.
const _reservoir = '''
{"elements":[{"type":"relation","id":28758,
"tags":{"natural":"water","water":"reservoir","name":"Zaslawye Reservoir"},
"members":[{"type":"way","role":"outer","geometry":[
{"lat":54.00,"lon":27.40},{"lat":54.00,"lon":27.45},
{"lat":54.03,"lon":27.45},{"lat":54.03,"lon":27.40},
{"lat":54.00,"lon":27.40}]}]}]}
''';

const _empty = '{"elements":[]}';

/// Точка-спот внутри полигона выше.
const _lat = 54.015;
const _lon = 27.425;

/// Поднять контейнер с заданным http-клиентом (через него считаем сетевые
/// запросы — кэш должен их обнулять). Активная локация берётся из prefs.
ProviderContainer _container(MockClient http) {
  return ProviderContainer(overrides: [
    overpassClientProvider.overrideWithValue(OverpassClient(client: http)),
  ]);
}

/// Догнать провайдер до устойчивого состояния (данные/ошибка), не дёргая
/// `.future`: на ошибке-Exception `await provider.future` в тестовой зоне
/// зависает, а наблюдение AsyncValue — нет. В рабочем UI ошибку наблюдает
/// `.when(error:)`, поэтому там зависания нет.
Future<AsyncValue<WaterBody?>> _settle(ProviderContainer c) async {
  c.read(waterBodyProvider);
  for (var i = 0; i < 5; i++) {
    await Future<void>.delayed(Duration.zero);
  }
  return c.read(waterBodyProvider);
}

void main() {
  // sharedPrefs — late final: инициализируем один раз, между тестами чистим.
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
    await prefs_service.initPrefs();
  });

  setUp(() async {
    await prefs_service.sharedPrefs.clear();
    // Активная локация — спот на воде, без фонового геокодинга (есть имя).
    await prefs_service.sharedPrefs.setString(
      'active_location',
      jsonEncode({'name': 'Spot', 'lat': _lat, 'lon': _lon}),
    );
  });

  test('повторное чтение тех же координат берётся из prefs-кэша, без сети',
      () async {
    var calls = 0;
    final c1 = _container(MockClient((_) async {
      calls++;
      return http.Response(_reservoir, 200);
    }));
    final first = await c1.read(waterBodyProvider.future);
    expect(first?.name, 'Zaslawye Reservoir');
    expect(calls, greaterThan(0));
    c1.dispose();

    // Новая «сессия» с тем же prefs: клиент кидает при любом запросе.
    // Если кэш работает — до сети дело не дойдёт.
    final c2 = _container(MockClient((_) async {
      fail('сеть не должна вызываться при попадании в кэш');
    }));
    final second = await c2.read(waterBodyProvider.future);
    expect(second?.name, 'Zaslawye Reservoir');
    expect(second?.type, WaterBodyType.reservoir);
    c2.dispose();
  });

  test('подтверждённое «нет воды» (null) кэшируется — пустой ответ не дёргает сеть повторно',
      () async {
    final c1 = _container(MockClient((_) async => http.Response(_empty, 200)));
    expect(await c1.read(waterBodyProvider.future), isNull);
    c1.dispose();

    final c2 = _container(MockClient((_) async {
      fail('сеть не должна вызываться: «нет воды» уже в кэше');
    }));
    expect(await c2.read(waterBodyProvider.future), isNull);
    c2.dispose();
  });

  test('сбой (все зеркала недоступны) НЕ кэшируется — следующая попытка идёт в сеть',
      () async {
    final c1 = _container(MockClient((_) async => http.Response('blocked', 406)));
    final errored = await _settle(c1);
    expect(errored.hasError, isTrue);
    expect(errored.error, isA<OverpassUnavailable>());
    c1.dispose();

    // Сбой не должен залипнуть как «нет воды»: новый клиент находит воду.
    var calls = 0;
    final c2 = _container(MockClient((_) async {
      calls++;
      return http.Response(_reservoir, 200);
    }));
    final body = await c2.read(waterBodyProvider.future);
    expect(body?.name, 'Zaslawye Reservoir');
    expect(calls, greaterThan(0));
    c2.dispose();
  });

  test('clearWaterCache сбрасывает запись — повтор уходит в сеть', () async {
    final c1 = _container(MockClient((_) async => http.Response(_reservoir, 200)));
    await c1.read(waterBodyProvider.future);
    c1.dispose();

    clearWaterCache(_lat, _lon);

    var calls = 0;
    final c2 = _container(MockClient((_) async {
      calls++;
      return http.Response(_reservoir, 200);
    }));
    await c2.read(waterBodyProvider.future);
    expect(calls, greaterThan(0), reason: 'кэш очищен — должна быть сеть');
    c2.dispose();
  });
}
