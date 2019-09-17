import 'package:yaml/yaml.dart';

/// Настройки устройства эмулятора
class DeviceSettings {
  /// Тип устройства
  final String type;

  /// Серийный номер устройства
  final String serial;

  /// Ссылка на маршрут
  final String route;

  /// Ссылка на источник данных
  final String datasource;

  /// Конструктор
  DeviceSettings(this.type, this.serial, this.route, this.datasource);

  /// Создаёт из данных yaml
  factory DeviceSettings.fromYaml(YamlMap map) {
    return DeviceSettings(map["type"].toString(), map["serial"].toString(),
        map["route"].toString(), map["datasource"].toString());
  }

  /// Формирует строку из данных
  @override
  String toString() {
    return "{type: $type, serial: $serial, route: $route, datasource: $datasource}";
  }
}
