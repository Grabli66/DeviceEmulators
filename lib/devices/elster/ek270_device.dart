import 'package:device_emulators/devices/emulator_device.dart';
import 'package:device_emulators/settings/device_settings.dart';

/// Эмулирует работу газового корректора EK270
class EK270Device extends EmulatorDevice {
  /// Идентификатор устройства в настройках
  static const ID = "EK270";

  EK270Device();

  /// Создаёт из настроек
  factory EK270Device.fromSettings(DeviceSettings settings) {
    return null;
  }

  /// Запускает эмуляцию устройства
  @override
  void start() {
  }
}