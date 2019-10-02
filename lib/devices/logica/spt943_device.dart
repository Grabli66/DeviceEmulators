import 'package:binary_data/binary_data_lib.dart';
import 'package:device_emulators/channels/transport_channel_client.dart';
import 'package:device_emulators/devices/emulator_device.dart';
import 'package:device_emulators/settings/device_settings.dart';
import 'package:device_protocols/applied_protocols/m4_protocol/requests/extractors/m4_request_extracted_data.dart';
import 'package:device_protocols/applied_protocols/m4_protocol/requests/extractors/m4_request_extractor.dart';
import 'package:device_protocols/applied_protocols/m4_protocol/requests/m4_session_request.dart';
import 'package:device_protocols/applied_protocols/m4_protocol/responses/m4_response.dart';
import 'package:device_protocols/applied_protocols/m4_protocol/responses/m4_session_response.dart';
import 'package:device_protocols/channel_protocols/m4_protocol/m4_frame.dart';
import 'package:device_protocols/channel_protocols/m4_protocol/m4_frame_extractor.dart';
import 'package:device_protocols/channel_protocols/m4_protocol/m4_long_frame.dart';
import 'package:device_protocols/channel_protocols/m4_protocol/m4_short_frame.dart';

/// Эмулирует работу тепловычислителя СПТ943 с новым протоколом M4
class Spt943Device extends EmulatorDevice {
  /// Идентификатор устройства в настройках
  static const ID = "SPT943";

  /// Отправляет ответ на запрос
  void sendResponse(TransportChannelClient client, M4Frame requestFrame,
      M4Response response) {
    M4Frame frame;
    if (requestFrame is M4LongFrame) {
      frame = M4LongFrame(requestFrame.networkAddress, requestFrame.packetId,
          response.toBytes().getList());
    } else if (requestFrame is M4ShortFrame) {
      frame = M4ShortFrame(
          requestFrame.networkAddress, response.toBytes().getList());
    }

    client.addList(frame.toBytes().getList());
  }

  /// Обрабатывает запрос сессии
  void _processSessionRequest(
      TransportChannelClient client, M4RequestExtractedData extracted) {
    final response = M4SessionResponse(1, 2);
    sendResponse(client, extracted.frame, response);
  }

  /// Обрабатывает запрос
  void _processRequest(
      TransportChannelClient client, M4RequestExtractedData extracted) async {
    switch (extracted.request.functionId) {
      case M4SessionRequest.FunctionId:
        _processSessionRequest(client, extracted);
        break;
      default:
        print("Unsupported packet");
    }
  }

  Spt943Device._();

  /// Создаёт из настроек
  factory Spt943Device.fromSettings(DeviceSettings settings) {
    print(settings);
    return Spt943Device._();
  }

  /// Запускает эмуляцию устройства
  @override
  void start() {
    channel.onClient.listen((client) async {
      final channelExtractor =
          M4FrameExtractor(BinaryStreamReader(client.onPacket));
      final requestExtractor = M4RequestExtractor(channelExtractor);
      // Запускает бесконечный цикл, игнорируя все ошибки
      while (true) {
        try {
          final frame = await requestExtractor.read();
          await _processRequest(client, frame);
        } catch (e) {
          print(e);
        }
      }
    });
  }
}
