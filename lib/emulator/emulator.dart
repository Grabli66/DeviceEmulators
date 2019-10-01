import 'package:device_emulators/channels/binary_transport_channel.dart';
import 'package:device_emulators/channels/tcp_server_channel.dart';
import 'package:device_emulators/datasources/data_source.dart';
import 'package:device_emulators/devices/emulator_device.dart';
import 'package:device_emulators/settings/emulator_settings.dart';
import 'package:device_emulators/settings/tcp_server_route_settings.dart';

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
    final channels = <String, BinaryTransportChannel>{};
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
    var deviceChannels = <BinaryTransportChannel>[];

    // Создаёт все драйвера устройств с указанными каналами и источниками данных
    for (var devSettings in _settings.devices) {
      final device = EmulatorDevice.fromSettings(devSettings);
      if (device == null) {
        print('Device type: ${devSettings.type} not supported');
        continue;
      }

      final channel = channels[devSettings.route];
      final datasource = datasources[devSettings.datasource];
      device.init(channel, datasource);
      // TODO: обработать возможную ошибку работы
      device.start();
      deviceChannels.add(channel);
    }

    // Запускает каналы
    for (var channel in deviceChannels) {
      channel.start();
    }
  }
}
