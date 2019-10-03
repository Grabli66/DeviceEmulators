import 'package:device_emulators/channels/server/tcp_server_channel.dart';
import 'package:device_emulators/channels/transport_channel.dart';
import 'package:device_emulators/datasources/data_source.dart';
import 'package:device_emulators/drivers/emulator_driver.dart';
import 'package:device_emulators/settings/device_settings.dart';
import 'package:device_emulators/settings/emulator_settings.dart';
import 'package:device_emulators/settings/tcp_server_route_settings.dart';
import 'package:collection/collection.dart' as collections;

/// Основной класс эмулятора устройств
class Emulator {
  /// Настройки эмулятора
  final EmulatorSettings _settings;

  /// Конструктор
  Emulator(this._settings);

  /// Запускает
  void start() async {
    print(_settings);

    // Создаёт все каналы
    final channels = <String, TransportChannel>{};
    for (final route in _settings.routes) {
      if (route is TcpServerRouteSettings) {
        final channel = TcpServerChannel(route.name, route.port);
        channels[channel.name] = channel;
      }
    }

    final datasources = <String, DataSource>{};
    // Создаёт источники данных
    for (var datSettings in _settings.datasources) {
      final datasource = DataSource.fromSettings(datSettings);
      datasources[datSettings.name] = datasource;
    }

    // Каналы которые нужно открыть
    var deviceChannels = <TransportChannel>[];

    // Группирует устройства по типу
    final devicesByType =
        collections.groupBy(_settings.devices, (DeviceSettings e) => e.type);

    // Создаёт драйвера для устройств
    for (var typePair in devicesByType.entries) {
      final deviceType = typePair.key;
      final driver = EmulatorDriver.fromDeviceType(deviceType);
      if (driver == null) {
        print("Unsupported device type: ${deviceType}");
        continue;
      }

      // Группирует по идентификатору маршрута
      final devicesByRoute =
          collections.groupBy(typePair.value, (DeviceSettings e) => e.route);

      for (var routePair in devicesByRoute.entries) {
        final route = routePair.key;
        final channel = channels[route];
        if (channel == null) {
          print("Channel ${route} not found");
          continue;
        }

        deviceChannels.add(channel);
        driver.start(channel, routePair.value);
      }
    }

    // Запускает каналы
    for (var channel in deviceChannels) {
      channel.start();
    }
  }
}
