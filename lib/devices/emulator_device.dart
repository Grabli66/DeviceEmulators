import 'package:device_emulators/channels/transport_channel.dart';
import 'package:device_emulators/datasources/data_source.dart';
import 'package:device_emulators/devices/elster/ek270_device.dart';
import 'package:device_emulators/devices/logica/spt943_device.dart';
import 'package:device_emulators/settings/device_settings.dart';
import 'package:meta/meta.dart';

/// Организует обработку запросов и выдачу ответов
abstract class EmulatorDevice {
  /// Канал передачи пакетов
  @protected
  TransportChannel channel;

  /// Источник данных
  @protected
  DataSource dataSource;

  /// Конструктор
  @protected
  EmulatorDevice();

  /// Создаёт из настроек
  factory EmulatorDevice.fromSettings(DeviceSettings settings) {
    switch (settings.type) {
      case EK270Device.ID:
        return EK270Device.fromSettings(settings);
      case Spt943Device.ID:
        return Spt943Device.fromSettings(settings);
    }

    return null;
  }

  /// Инициализирует каналом приёма сообщений и источником данных
  void init(TransportChannel channel, DataSource dataSource) {
    this.channel = channel;
    this.dataSource = dataSource;
  }

  /// Реализуется конкретным устройством
  /// Начинает работу эмуляции устройства
  void start();
}
