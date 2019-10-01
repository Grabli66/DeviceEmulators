import 'package:binary_data/binary_data_lib.dart';
import 'package:device_emulators/devices/emulator_device.dart';
import 'package:device_emulators/settings/device_settings.dart';
import 'package:device_protocols/applied_protocols/m4_protocol/requests/m4_request.dart';
import 'package:device_protocols/applied_protocols/m4_protocol/requests/m4_request_extractor.dart';
import 'package:device_protocols/channel_protocols/m4_protocol/m4_frame_extractor.dart';

/// Эмулирует работу тепловычислителя СПТ943 с новым протоколом M4
class Spt943Device extends EmulatorDevice {
  /// Идентификатор устройства в настройках
  static const ID = "SPT943";

  /// Обрабатывает запрос
  void _processRequest(M4Request request) async {
    
  }

  Spt943Device._();

  /// Создаёт из настроек
  factory Spt943Device.fromSettings(DeviceSettings settings) {
    print(settings);
    return Spt943Device._();
  }

  /// Запускает эмуляцию устройства
  @override
  void start() async {
    final channelExtractor =
        M4FrameExtractor(BinaryStreamReader(channel.onPacket));
    final requestExtractor = M4RequestExtractor(channelExtractor);

    while (true) {
      try {
        final frame = await requestExtractor.read();
        await _processRequest(frame);
      } catch (e) {
        print(e);        
      }
    }
  }
}
