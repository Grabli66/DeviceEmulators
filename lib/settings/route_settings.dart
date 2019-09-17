import 'package:device_emulators/common/emulator_exception.dart';
import 'package:device_emulators/settings/tcp_server_route_settings.dart';
import 'package:yaml/yaml.dart';

/// Настройки маршрута
class RouteSettings {
  /// Тип маршрута
  final String type;

  /// Название маршрута
  final String name;

  /// Конструктор
  RouteSettings(this.type, this.name);

  /// Создаёт из данных yaml
  factory RouteSettings.fromYaml(YamlMap map) {
    final type = map["type"].toString();
    switch (type) {
      case "TcpServer":
        return TcpServerRouteSettings.fromYaml(map);
    }

    throw EmulatorException("Unknown route type");
  }

  /// Формирует строку из данных
  @override
  String toString() {    
    return "type: $type, name: $name";
  }
}
