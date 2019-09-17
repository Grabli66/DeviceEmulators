import 'package:device_emulators/settings/route_settings.dart';
import 'package:yaml/yaml.dart';

/// Настройки маршрута для маршрута TcpServer
class TcpServerRouteSettings extends RouteSettings {
  /// Порт серверного сокета
  final int port;

  /// Конструктор
  TcpServerRouteSettings(String type, String name, this.port)
      : super(type, name);

  /// Создаёт из данных yaml
  factory TcpServerRouteSettings.fromYaml(YamlMap map) {
    return TcpServerRouteSettings(map["type"].toString(),
        map["name"].toString(), int.parse(map["port"].toString()));
  }

  /// Формирует строку из данных
  @override
  String toString() {    
    return super.toString() + ", port: $port";
  }
}
