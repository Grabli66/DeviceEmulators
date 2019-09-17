import 'dart:io';

import 'package:device_emulators/settings/datasource_settings.dart';
import 'package:device_emulators/settings/device_settings.dart';
import 'package:device_emulators/settings/route_settings.dart';
import 'package:yaml/yaml.dart';

/// Настройки эмулятора
class EmulatorSettings {
  /// Устройства по которым нужно проводить эмуляцию данных
  final List<DeviceSettings> devices;

  /// Маршруты
  final List<RouteSettings> routes;

  /// Источники данных
  final List<DataSourceSettings> datasources;

  /// Конструктор
  EmulatorSettings(this.devices, this.routes, this.datasources);

  /// Создаёт настройки из файла yaml
  factory EmulatorSettings.fromYaml(String path) {
    final dynamic yamlData = loadYaml(File(path).readAsStringSync());
    final dynamic yamlDevices = yamlData["devices"];
    final dynamic yamlRoutes = yamlData["routes"];
    final dynamic yamlDataSources = yamlData["datasources"];

    final devices = <DeviceSettings>[];
    final routes = <RouteSettings>[];
    final datasources = <DataSourceSettings>[];

    for (var dev in yamlDevices) {
      final device = DeviceSettings.fromYaml(dev as YamlMap);
      devices.add(device);
    }

    for (var rout in yamlRoutes) {
      final route = RouteSettings.fromYaml(rout as YamlMap);
      routes.add(route);
    }

    for (var dat in yamlDataSources) {
      final datasource = DataSourceSettings.fromYaml(dat as YamlMap);
      datasources.add(datasource);
    }

    return EmulatorSettings(devices, routes, datasources);
  }

  /// Формирует строку из данных
  @override
  String toString() {
    return "Devices: $devices \nRoutes: $routes \nDataSources: $datasources";
  }
}
