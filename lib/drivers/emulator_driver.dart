import 'package:device_emulators/channels/transport_channel.dart';
import 'package:device_emulators/drivers/elster/ek270_driver.dart';
import 'package:device_emulators/drivers/logica/spt943_driver.dart';
import 'package:device_emulators/settings/device_settings.dart';

/// Драйвер устройства, обрабатывающий запросы к устройствам
abstract class EmulatorDriver {
  /// Конструктор
  EmulatorDriver();

  /// Создаёт для типа устройства
  factory EmulatorDriver.fromDeviceType(String deviceType) {
    switch (deviceType) {
      case SPT943Driver.ID:
        return SPT943Driver();
      case EK270Driver.ID:
        return EK270Driver();
    }

    return null;
  }

  /// Запускает работу и передаёт список устройств
  void start(TransportChannel channel, List<DeviceSettings> devices);
}
