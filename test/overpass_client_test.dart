import 'package:app/features/spots/data/overpass_client.dart';
import 'package:app/features/spots/domain/water_body.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

/// Ответ зеркала на relation-мультиполигон: геометрии членов нет, только bbox
/// (так отдаёт `out geom;` для отношений) — парсер должен взять центр бокса.
const _reservoirRelation = '''
{"elements":[{"type":"relation","id":106233,
"bounds":{"minlat":37.80,"minlon":-121.76,"maxlat":37.84,"maxlon":-121.72},
"tags":{"natural":"water","water":"reservoir","name":"Los Vaqueros Reservoir"}}]}
''';

const _empty = '{"elements":[]}';

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
}
