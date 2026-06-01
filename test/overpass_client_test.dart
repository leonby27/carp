import 'package:app/features/spots/data/overpass_client.dart';
import 'package:app/features/spots/domain/water_body.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// Запасной путь: relation без разрешённой геометрии членов — только bbox.
/// Парсер должен взять центр бокса.
const _reservoirRelation = '''
{"elements":[{"type":"relation","id":106233,
"bounds":{"minlat":37.80,"minlon":-121.76,"maxlat":37.84,"maxlon":-121.72},
"tags":{"natural":"water","water":"reservoir","name":"Los Vaqueros Reservoir"}}]}
''';

/// relation-мультиполигон с геометрией членов (так отдаёт `out geom;`): парсер
/// должен мерить расстояние до реальных рёбер, а не до грубого bbox.
const _reservoirRelationGeom = '''
{"elements":[{"type":"relation","id":28758,
"tags":{"natural":"water","water":"reservoir","name":"Zaslawye Reservoir"},
"members":[{"type":"way","role":"outer","geometry":[
{"lat":54.00,"lon":27.40},{"lat":54.00,"lon":27.45},
{"lat":54.03,"lon":27.45},{"lat":54.03,"lon":27.40},
{"lat":54.00,"lon":27.40}]}]}]}
''';

/// Большое водохранилище: внешняя граница нарезана на ДВЕ открытые дуги (как
/// у настоящих мультиполигонов — десятки member-ways, не замкнутых поодиночке)
/// + остров (inner). Точка-спот стоит НА ВОДЕ, далеко от берега. Парсер должен
/// собрать кольца раздельно, понять, что точка внутри (расстояние 0), и вычесть
/// площадь острова.
const _bigReservoirMultipolygon = '''
{"elements":[{"type":"relation","id":777,
"tags":{"natural":"water","water":"reservoir","name":"Inland Sea"},
"members":[
{"type":"way","role":"outer","geometry":[
{"lat":54.00,"lon":27.40},{"lat":54.00,"lon":27.50},{"lat":54.05,"lon":27.50}]},
{"type":"way","role":"outer","geometry":[
{"lat":54.05,"lon":27.50},{"lat":54.05,"lon":27.40},{"lat":54.00,"lon":27.40}]},
{"type":"way","role":"inner","geometry":[
{"lat":54.020,"lon":27.440},{"lat":54.020,"lon":27.445},
{"lat":54.024,"lon":27.445},{"lat":54.024,"lon":27.440},
{"lat":54.020,"lon":27.440}]}]}]}
''';

const _empty = '{"elements":[]}';

/// Озеро-полигон + переданные структурные элементы рядом. Спот ставим внутри
/// озера (54.010, 27.010) — водоём распознан, а структуры считаются от спота.
String _lakeWith(String extra) => '''
{"elements":[
{"type":"way","id":1,
"tags":{"natural":"water","water":"lake","name":"Test Lake"},
"geometry":[{"lat":54.000,"lon":27.000},{"lat":54.000,"lon":27.020},
{"lat":54.020,"lon":27.020},{"lat":54.020,"lon":27.000},
{"lat":54.000,"lon":27.000}]}${extra.isEmpty ? '' : ',$extra'}
]}
''';

/// Ручей в ~33 м от спота (лон 27.0105 при споте на 27.010).
const _streamNear = '{"type":"way","id":2,"tags":{"waterway":"stream"},'
    '"geometry":[{"lat":54.009,"lon":27.0105},{"lat":54.011,"lon":27.0105}]}';

/// Тростниковое болото, накрывающее спот.
const _reedNear = '{"type":"way","id":3,'
    '"tags":{"natural":"wetland","wetland":"reed"},'
    '"geometry":[{"lat":54.009,"lon":27.009},{"lat":54.009,"lon":27.011},'
    '{"lat":54.011,"lon":27.011},{"lat":54.011,"lon":27.009},'
    '{"lat":54.009,"lon":27.009}]}';

/// Плотина в ~33 м от спота.
const _damNear = '{"type":"way","id":4,"tags":{"waterway":"dam"},'
    '"geometry":[{"lat":54.009,"lon":27.0105},{"lat":54.011,"lon":27.0105}]}';

/// Река-полигон (water=river) + ручей рядом: подсказку «приток» гасим, т.к.
/// сам водоём проточный.
const _riverWithStream = '''
{"elements":[
{"type":"way","id":1,"tags":{"natural":"water","water":"river","name":"Big River"},
"geometry":[{"lat":54.000,"lon":27.000},{"lat":54.000,"lon":27.020},
{"lat":54.005,"lon":27.020},{"lat":54.005,"lon":27.000},{"lat":54.000,"lon":27.000}]},
{"type":"way","id":2,"tags":{"waterway":"stream"},
"geometry":[{"lat":54.001,"lon":27.0105},{"lat":54.003,"lon":27.0105}]}
]}
''';

void main() {
  test('relation с одним bbox → водохранилище, центр бокса, площадь неизвестна',
      () async {
    final client = OverpassClient(
      client: MockClient((_) async => http.Response(_reservoirRelation, 200)),
    );
    final body = await client.nearestWater(37.8166, -121.7304);

    expect(body, isNotNull);
    expect(body!.type, WaterBodyType.reservoir);
    expect(body.name, 'Los Vaqueros Reservoir');
    // Центроид — центр bbox.
    expect(body.centroidLat, closeTo(37.82, 1e-9));
    expect(body.centroidLon, closeTo(-121.74, 1e-9));
    // По одному боксу площадь не оцениваем — честнее null.
    expect(body.areaHa, isNull);
  });

  test('relation с геометрией членов → водохранилище по реальному полигону',
      () async {
    final client = OverpassClient(
      client: MockClient((_) async => http.Response(_reservoirRelationGeom, 200)),
    );
    // Точка внутри полигона членов: расстояние 0, водоём распознан.
    final body = await client.nearestWater(54.015, 27.425);

    expect(body, isNotNull);
    expect(body!.type, WaterBodyType.reservoir);
    expect(body.name, 'Zaslawye Reservoir');
    // Центроид — среднее вершин кольца, а не центр bbox.
    expect(body.centroidLat, closeTo(54.012, 0.01));
    // Площадь оценена по реальному кольцу (не null, как при bbox-пути).
    expect(body.areaHa, isNotNull);
  });

  test('спот НА ВОДЕ внутри мультиполигона → распознан (расстояние 0)',
      () async {
    final client = OverpassClient(
      client: MockClient(
          (_) async => http.Response(_bigReservoirMultipolygon, 200)),
    );
    // Точка в середине водоёма, вне острова и далеко от берега.
    final body = await client.nearestWater(54.035, 27.47);

    expect(body, isNotNull);
    expect(body!.type, WaterBodyType.reservoir);
    expect(body.name, 'Inland Sea');
    // Площадь = внешний контур минус остров, заметно больше 0.
    expect(body.areaHa, isNotNull);
    expect(body.areaHa, greaterThan(100));
    // Один inner-контур = один остров (структурная подсказка).
    expect(body.islandCount, 1);
  });

  test('зеркало ответило 200 с пустым списком → воды рядом нет (null)', () async {
    final client = OverpassClient(
      client: MockClient((_) async => http.Response(_empty, 200)),
    );
    expect(await client.nearestWater(37.0, -121.0), isNull);
  });

  test('все зеркала недоступны → OverpassUnavailable, а не «нет воды»', () async {
    var calls = 0;
    final client = OverpassClient(
      client: MockClient((_) async {
        calls++;
        return http.Response('blocked', 406);
      }),
    );
    expect(
      () => client.nearestWater(37.0, -121.0),
      throwsA(isA<OverpassUnavailable>()),
    );
    // Перебрали оба зеркала, прежде чем сдаться.
    await Future<void>.delayed(Duration.zero);
    expect(calls, greaterThanOrEqualTo(2));
  });

  test('запрос уходит с User-Agent (иначе зеркала режут 403/406)', () async {
    String? sentUa;
    final client = OverpassClient(
      client: MockClient((req) async {
        sentUa = req.headers['user-agent'];
        return http.Response(_empty, 200);
      }),
    );
    await client.nearestWater(37.0, -121.0);
    expect(sentUa, isNotNull);
    expect(sentUa, isNot(contains('dart:io')));
  });

  test('одно зеркало упало (429) → берём валидный ответ другого', () async {
    var calls = 0;
    final client = OverpassClient(
      client: MockClient((_) async {
        calls++;
        // Первое ответившее зеркало — 429, остальные отдают воду.
        return calls == 1
            ? http.Response('rate limited', 429)
            : http.Response(_reservoirRelation, 200);
      }),
    );
    final body = await client.nearestWater(37.8166, -121.7304);
    expect(body?.type, WaterBodyType.reservoir);
    // Зеркала опрашиваются параллельно — запрошено больше одного.
    expect(calls, greaterThanOrEqualTo(2));
  });

  group('структурные подсказки у спота', () {
    test('ручей рядом с озером → inflowNearSpot', () async {
      final client = OverpassClient(
        client: MockClient(
            (_) async => http.Response(_lakeWith(_streamNear), 200)),
      );
      final body = await client.nearestWater(54.010, 27.010);
      expect(body, isNotNull);
      expect(body!.type, WaterBodyType.lake);
      expect(body.inflowNearSpot, isTrue);
      expect(body.reedsNearSpot, isFalse);
      expect(body.damNearSpot, isFalse);
    });

    test('тростник накрывает спот → reedsNearSpot', () async {
      final client = OverpassClient(
        client:
            MockClient((_) async => http.Response(_lakeWith(_reedNear), 200)),
      );
      final body = await client.nearestWater(54.010, 27.010);
      expect(body!.reedsNearSpot, isTrue);
      expect(body.inflowNearSpot, isFalse);
    });

    test('плотина рядом → damNearSpot', () async {
      final client = OverpassClient(
        client:
            MockClient((_) async => http.Response(_lakeWith(_damNear), 200)),
      );
      final body = await client.nearestWater(54.010, 27.010);
      expect(body!.damNearSpot, isTrue);
    });

    test('чистое озеро без структур → все флаги false', () async {
      final client = OverpassClient(
        client: MockClient((_) async => http.Response(_lakeWith(''), 200)),
      );
      final body = await client.nearestWater(54.010, 27.010);
      expect(body!.hasStructureHints, isFalse);
    });

    test('тростник/плотина НЕ становятся «ближайшей водой»', () async {
      // Только структуры, воды нет вовсе → null, а не ложный водоём.
      final onlyStructures = '{"elements":[$_reedNear,$_damNear]}';
      final client = OverpassClient(
        client: MockClient((_) async => http.Response(onlyStructures, 200)),
      );
      expect(await client.nearestWater(54.010, 27.010), isNull);
    });

    test('на реке подсказку «приток» гасим (это сам водоём)', () async {
      final client = OverpassClient(
        client: MockClient((_) async => http.Response(_riverWithStream, 200)),
      );
      final body = await client.nearestWater(54.002, 27.010);
      expect(body!.type, WaterBodyType.river);
      expect(body.inflowNearSpot, isFalse);
    });
  });
}
