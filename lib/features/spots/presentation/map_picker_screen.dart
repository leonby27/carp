import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:latlong2/latlong.dart';

import '../../../l10n/app_localizations.dart';
import '../../forecast/domain/weather_point.dart';
import '../../location/application/location_providers.dart';
import '../../location/domain/geo_point.dart';

/// Полноэкранный выбор спота на OpenStreetMap. Можно: найти место по названию
/// (геокодинг), вернуться к своему GPS, либо просто подвигать карту под
/// неподвижным «прицелом». Координаты центра видны вживую.
class MapPickerScreen extends ConsumerStatefulWidget {
  const MapPickerScreen({
    super.key,
    required this.initialCenter,
    this.viewSpot,
    this.initialName,
    this.windDirDeg,
    this.windSpeedMs,
  });

  final LatLng initialCenter;

  /// Предзаполненное имя для формы создания: используется при правке уже
  /// сохранённого места — открываем ту же форму, что и при добавлении, но с
  /// готовым именем и картой по центру места.
  final String? initialName;

  /// Ветер для компаса на карте: направление (откуда дует, °) и скорость (м/с).
  /// Передаём только когда он реально относится к показанной точке (активный
  /// спот с прогнозом) — иначе компас ветра не рисуем, чтобы не выдумывать.
  final double? windDirDeg;
  final double? windSpeedMs;

  /// Если задан — экран открыт в режиме правки «где этот спот»: бледная метка
  /// на текущем месте спота, подвижный прицел для новой позиции, без поиска и
  /// поля имени. По «Сохранить» возвращает спот с тем же именем и новыми
  /// координатами (или null, если ушли назад без сохранения).
  final GeoPoint? viewSpot;

  @override
  ConsumerState<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends ConsumerState<MapPickerScreen> {
  final _mapController = MapController();
  final _nameController = TextEditingController();
  final _searchController = TextEditingController();
  late final ValueNotifier<LatLng> _center =
      ValueNotifier<LatLng>(widget.initialCenter);

  List<GeoPoint> _results = const [];
  bool _searching = false;

  // Подсказка имени: пока пользователь возит карту, в фоне определяем ближайший
  // населённый пункт и подставляем его в поле имени. Так на «Сохранить» спот уже
  // назван как надо — без ожидания после нажатия.
  Timer? _resolveTimer;
  bool _resolvingName = false;
  bool _nameTouched = false;

  bool get _editMode => widget.viewSpot != null;

  bool get _prefilled =>
      widget.initialName != null && widget.initialName!.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    if (_editMode) return; // правка позиции — имя спота не трогаем
    if (_prefilled) {
      // Правка сохранённого места: имя уже задано — не перетираем автоподстановкой.
      _nameController.text = widget.initialName!;
      _nameTouched = true;
      return;
    }
    // Подсказка для стартового центра (после первого кадра — нужен context).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduleResolve(widget.initialCenter);
    });
  }

  @override
  void dispose() {
    _resolveTimer?.cancel();
    _nameController.dispose();
    _searchController.dispose();
    _center.dispose();
    super.dispose();
  }

  /// Перезапускаемый дебаунс: имя определяем через паузу после остановки карты,
  /// а не на каждый кадр перетаскивания.
  void _scheduleResolve(LatLng center) {
    if (_nameTouched) return; // пользователь сам ввёл имя — не перетираем
    _resolveTimer?.cancel();
    _resolveTimer = Timer(
      const Duration(milliseconds: 700),
      () => _resolveSettlement(center),
    );
  }

  Future<void> _resolveSettlement(LatLng center) async {
    if (!mounted || _nameTouched) return;
    final lang = Localizations.localeOf(context).languageCode;
    setState(() => _resolvingName = true);
    final name = await ref.read(reverseGeocodingClientProvider).nearestSettlement(
          center.latitude,
          center.longitude,
          language: lang,
        );
    if (!mounted) return;
    setState(() => _resolvingName = false);
    if (name != null && name.isNotEmpty && !_nameTouched) {
      _nameController.text = name;
    }
  }

  void _save() {
    final center = _mapController.camera.center;
    Navigator.of(context).pop(
      GeoPoint(
        name: _nameController.text.trim(),
        latitude: center.latitude,
        longitude: center.longitude,
      ),
    );
  }

  // Правка существующего спота: имя сохраняем, меняем только координаты на центр.
  void _saveEdited() {
    final c = _mapController.camera.center;
    Navigator.of(context).pop(
      widget.viewSpot!.copyWith(latitude: c.latitude, longitude: c.longitude),
    );
  }

  Future<void> _search() async {
    final q = _searchController.text.trim();
    if (q.isEmpty) return;
    FocusScope.of(context).unfocus();
    setState(() => _searching = true);
    final code = Localizations.localeOf(context).languageCode;
    final results =
        await ref.read(geocodingClientProvider).search(q, language: code);
    if (!mounted) return;
    setState(() {
      _results = results;
      _searching = false;
    });
    if (results.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).spotNothingFound)),
      );
    }
  }

  void _pickResult(GeoPoint g) {
    _mapController.move(LatLng(g.latitude, g.longitude), 12);
    _nameController.text = g.name;
    _nameTouched = true; // выбранное из поиска имя — явное, не перетираем
    _resolveTimer?.cancel();
    setState(() => _results = const []);
  }

  Future<void> _goToDeviceLocation() async {
    final result = await ref.read(geolocationServiceProvider).currentLocation();
    if (!mounted) return;
    final p = result.point;
    if (p != null) {
      _mapController.move(LatLng(p.latitude, p.longitude), 13);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).spotLocationUnavailable),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final viewSpot = widget.viewSpot;
    final title = viewSpot != null
        ? (viewSpot.isUnnamed ? l10n.spotEditTitle : viewSpot.name)
        : (_prefilled ? widget.initialName! : l10n.spotPickerTitle);
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: widget.initialCenter,
              initialZoom: _editMode || _prefilled ? 15 : 11,
              minZoom: 3,
              maxZoom: 18,
              // Север всегда вверх — иначе компас и стрелка ветра врут.
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
              onPositionChanged: (camera, _) {
                _center.value = camera.center;
                if (!_editMode) _scheduleResolve(camera.center);
              },
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.baseapp.app',
              ),
              // В правке — бледная метка на исходном месте спота: видно, откуда
              // двигаем (особенно когда советуем перейти на другой берег).
              if (_editMode)
                MarkerLayer(
                  markers: [
                    Marker(
                      point: widget.initialCenter,
                      width: 36,
                      height: 36,
                      alignment: Alignment.topCenter,
                      child: Icon(Icons.location_on,
                          size: 36,
                          color: theme.colorScheme.primary
                              .withValues(alpha: 0.35)),
                    ),
                  ],
                ),
            ],
          ),
          // Подвижный прицел: остриё иконки указывает в центр камеры (новая
          // позиция метки — и при выборе нового спота, и при правке).
          IgnorePointer(
            child: Center(
              child: Transform.translate(
                offset: const Offset(0, -20),
                child: Icon(Icons.location_on,
                    size: 44, color: theme.colorScheme.primary),
              ),
            ),
          ),
          // Блок ветра — помогает поставить метку на нужный берег (совет по
          // клёву привязан к стороне света). Рисуем, только если ветер реально
          // передан для этой точки.
          if (widget.windDirDeg != null)
            _WindCompass(
              windDirDeg: widget.windDirDeg!,
              windSpeedMs: widget.windSpeedMs ?? 0,
            ),
          if (!_editMode)
            _SearchBar(
              controller: _searchController,
              searching: _searching,
              results: _results,
              onSubmit: _search,
              onPick: _pickResult,
            ),
          if (!_editMode)
            Positioned(
              right: 16,
              bottom: 188,
              child: FloatingActionButton.small(
                heroTag: 'myloc',
                onPressed: _goToDeviceLocation,
                child: const Icon(Icons.my_location),
              ),
            ),
          if (viewSpot != null)
            _EditPositionCard(
              spot: viewSpot,
              center: _center,
              onSave: _saveEdited,
            )
          else
          Positioned(
            left: 16,
            right: 16,
            bottom: 16,
            child: SafeArea(
              top: false,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x1A1B364A),
                        blurRadius: 20,
                        offset: Offset(0, 6)),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.gps_fixed,
                            size: 14, color: theme.colorScheme.onSurfaceVariant),
                        const SizedBox(width: 6),
                        ValueListenableBuilder<LatLng>(
                          valueListenable: _center,
                          builder: (_, c, _) => Text(
                            '${c.latitude.toStringAsFixed(4)}, ${c.longitude.toStringAsFixed(4)}',
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _nameController,
                      textInputAction: TextInputAction.done,
                      onChanged: (_) {
                        // Ручной ввод отменяет автоподстановку ближайшего пункта.
                        _nameTouched = true;
                        _resolveTimer?.cancel();
                      },
                      onSubmitted: (_) => _save(),
                      decoration: InputDecoration(
                        hintText: l10n.spotNameHint,
                        prefixIcon: _resolvingName
                            ? const Padding(
                                padding: EdgeInsets.all(12),
                                child: SizedBox(
                                  width: 18,
                                  height: 18,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2.2),
                                ),
                              )
                            : const Icon(Icons.label_outline),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton(
                        onPressed: _save,
                        child: Text(l10n.spotSaveBtn),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Нижняя плашка режима правки: имя спота, подсказка «двигайте карту», живые
/// координаты центра и кнопка сохранения новой позиции.
class _EditPositionCard extends StatelessWidget {
  const _EditPositionCard({
    required this.spot,
    required this.center,
    required this.onSave,
  });

  final GeoPoint spot;
  final ValueListenable<LatLng> center;
  final VoidCallback onSave;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    return Positioned(
      left: 16,
      right: 16,
      bottom: 16,
      child: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: cs.surface,
            borderRadius: BorderRadius.circular(20),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x1A1B364A),
                  blurRadius: 20,
                  offset: Offset(0, 6)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.location_on, size: 20, color: cs.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      spot.isUnnamed ? l10n.spotEditTitle : spot.name,
                      style: theme.textTheme.titleSmall
                          ?.copyWith(fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                l10n.spotEditHint,
                style: theme.textTheme.bodySmall
                    ?.copyWith(color: cs.onSurfaceVariant, height: 1.3),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.gps_fixed, size: 14, color: cs.onSurfaceVariant),
                  const SizedBox(width: 6),
                  ValueListenableBuilder<LatLng>(
                    valueListenable: center,
                    builder: (_, c, _) => Text(
                      '${c.latitude.toStringAsFixed(4)}, ${c.longitude.toStringAsFixed(4)}',
                      style: theme.textTheme.labelMedium
                          ?.copyWith(color: cs.onSurfaceVariant),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onSave,
                  child: Text(l10n.spotSavePosition),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Компас ветра в углу карты: роза с буквами С/В/Ю/З (север подсвечен и
/// закреплён вверху карты), стрелка-глиф в направлении потока и подпись словами
/// «Ветер дует с севера · 2 м/с». Текст снизу снимает путаницу со стрелкой.
class _WindCompass extends StatelessWidget {
  const _WindCompass({required this.windDirDeg, required this.windSpeedMs});

  final double windDirDeg;
  final double windSpeedMs;

  String _dirWord(AppLocalizations l10n, WindCardinal c) => switch (c) {
        WindCardinal.n => l10n.spotDirN,
        WindCardinal.ne => l10n.spotDirNE,
        WindCardinal.e => l10n.spotDirE,
        WindCardinal.se => l10n.spotDirSE,
        WindCardinal.s => l10n.spotDirS,
        WindCardinal.sw => l10n.spotDirSW,
        WindCardinal.w => l10n.spotDirW,
        WindCardinal.nw => l10n.spotDirNW,
      };

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final calm = windSpeedMs < 1.0;
    final flowDeg = (windDirDeg + 180) % 360; // направление, куда дует

    Widget cardinal(String t, Alignment a, {bool north = false}) => Align(
          alignment: a,
          child: Text(
            t,
            style: theme.textTheme.labelSmall?.copyWith(
              fontSize: 10,
              height: 1,
              fontWeight: north ? FontWeight.w800 : FontWeight.w600,
              color: north ? cs.primary : cs.onSurfaceVariant,
            ),
          ),
        );

    return Positioned(
      top: 12,
      right: 16,
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            color: cs.surface.withValues(alpha: 0.94),
            borderRadius: BorderRadius.circular(16),
            boxShadow: const [
              BoxShadow(
                  color: Color(0x1A1B364A), blurRadius: 14, offset: Offset(0, 4)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 60,
                height: 60,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: cs.outlineVariant),
                      ),
                    ),
                    cardinal(l10n.fcWindN, Alignment.topCenter, north: true),
                    cardinal(l10n.fcWindE, Alignment.centerRight),
                    cardinal(l10n.fcWindS, Alignment.bottomCenter),
                    cardinal(l10n.fcWindW, Alignment.centerLeft),
                    if (calm)
                      Icon(Icons.circle, size: 7, color: cs.onSurfaceVariant)
                    else
                      Transform.rotate(
                        angle: flowDeg * math.pi / 180,
                        child:
                            Icon(Icons.navigation, size: 24, color: cs.primary),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              if (calm)
                Text(
                  l10n.fcWindCalm,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.2,
                  ),
                )
              else ...[
                Text(
                  l10n.spotWindLabel,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.2,
                  ),
                ),
                Text(
                  '${_dirWord(l10n, cardinalFromDeg(windDirDeg))} · ${windSpeedMs.round()} ${l10n.fcUnitMsSuffix}',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: cs.onSurfaceVariant,
                    height: 1.2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({
    required this.controller,
    required this.searching,
    required this.results,
    required this.onSubmit,
    required this.onPick,
  });

  final TextEditingController controller;
  final bool searching;
  final List<GeoPoint> results;
  final VoidCallback onSubmit;
  final ValueChanged<GeoPoint> onPick;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    return Positioned(
      left: 16,
      right: 16,
      top: 12,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(14),
              shadowColor: Colors.black26,
              child: TextField(
                controller: controller,
                textInputAction: TextInputAction.search,
                onSubmitted: (_) => onSubmit(),
                decoration: InputDecoration(
                  hintText: l10n.spotSearchHint,
                  filled: true,
                  fillColor: theme.colorScheme.surface,
                  prefixIcon: searching
                      ? const Padding(
                          padding: EdgeInsets.all(12),
                          child: SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2.2),
                          ),
                        )
                      : IconButton(
                          icon: const Icon(Icons.search),
                          onPressed: onSubmit,
                        ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            if (results.isNotEmpty)
              Container(
                margin: const EdgeInsets.only(top: 6),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(14),
                  boxShadow: const [
                    BoxShadow(
                        color: Color(0x1A1B364A),
                        blurRadius: 16,
                        offset: Offset(0, 4)),
                  ],
                ),
                clipBehavior: Clip.antiAlias,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (final r in results)
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.place_outlined, size: 20),
                        title: Text(r.name,
                            maxLines: 1, overflow: TextOverflow.ellipsis),
                        onTap: () => onPick(r),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
