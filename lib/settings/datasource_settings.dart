import 'package:yaml/yaml.dart';

/// Настройки источника данных
class DataSourceSettings {
  /// Тип маршрута
  final String type;

  /// Название маршрута
  final String name;

  /// Конструктор
  DataSourceSettings(this.type, this.name);

  /// Создаёт из данных yaml
  factory DataSourceSettings.fromYaml(YamlMap map) {
    return DataSourceSettings(map["type"].toString(), map["name"].toString());
  }

  /// Формирует строку из данных
  @override
  String toString() {
    return "type: $type name: $name";
  }
}
