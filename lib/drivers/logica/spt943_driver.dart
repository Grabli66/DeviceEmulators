import 'package:binary_data/binary_data_lib.dart';
import 'package:device_emulators/channels/transport_channel.dart';
import 'package:device_emulators/channels/transport_channel_client.dart';
import 'package:device_emulators/drivers/driver_exception.dart';
import 'package:device_emulators/drivers/emulator_driver.dart';
import 'package:device_emulators/settings/device_settings.dart';
import 'package:device_protocols/applied_protocols/m4_protocol/data_tags/m4_data_tag.dart';
import 'package:device_protocols/applied_protocols/m4_protocol/data_tags/m4_date_tag.dart';
import 'package:device_protocols/applied_protocols/m4_protocol/data_tags/m4_time_tag.dart';
import 'package:device_protocols/applied_protocols/m4_protocol/requests/extractors/m4_request_extracted_data.dart';
import 'package:device_protocols/applied_protocols/m4_protocol/requests/extractors/m4_request_extractor.dart';
import 'package:device_protocols/applied_protocols/m4_protocol/requests/m4_parameter_read_request.dart';
import 'package:device_protocols/applied_protocols/m4_protocol/requests/m4_session_request.dart';
import 'package:device_protocols/applied_protocols/m4_protocol/responses/m4_parameter_read_response.dart';
import 'package:device_protocols/applied_protocols/m4_protocol/responses/m4_response.dart';
import 'package:device_protocols/applied_protocols/m4_protocol/responses/m4_session_response.dart';
import 'package:device_protocols/channel_protocols/m4_protocol/m4_frame.dart';
import 'package:device_protocols/channel_protocols/m4_protocol/m4_frame_extractor.dart';
import 'package:device_protocols/channel_protocols/m4_protocol/m4_long_frame.dart';
import 'package:device_protocols/channel_protocols/m4_protocol/m4_short_frame.dart';

/// Драйвер
class SPT943Driver extends EmulatorDriver {
  /// Идентификатор устройства в настройках
  static const ID = "SPT943";

  /// Устройства по сетевому номеру
  var _devicesByNetwork = Map<String, DeviceSettings>();

  /// Возвращает устройство по сетевому номеру или кидает исключение
  DeviceSettings _getDeviceByNetwork(int network) {
    final device = _devicesByNetwork[network.toString()];
    if (device == null) {
      throw DriverException("Device not found network: ${network}");
    } else {
      print("Found device ${device}");
    }

    return device;
  }

  /// Отправляет ответ на запрос
  void _sendResponse(TransportChannelClient client, M4Frame requestFrame,
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
    _getDeviceByNetwork(extracted.frame.networkAddress);

    final response = M4SessionResponse(1, 2);
    _sendResponse(client, extracted.frame, response);
    print("SessionRequest processed");
  }

  /// Обрабатывает запрос чтения параметров
  void _processParameterReadRequest(
      TransportChannelClient client, M4RequestExtractedData extracted) {
    final request = extracted.request as M4ParameterReadRequest;

    _getDeviceByNetwork(extracted.frame.networkAddress);

    final responseTags = List<M4DataTag>();

    for (var parameter in request.parameterList) {
      switch (parameter.parameter) {
        // Дата
        case 0x401:
          responseTags.add(M4DateTag(DateTime.now()));
          break;
        // Время
        case 0x400:
          responseTags.add(M4TimeTag(DateTime.now()));
          break;
      }
    }

    _sendResponse(
        client, extracted.frame, M4ParameterReadResponse(responseTags));

    print("ParameterReadRequest processed");
  }

  /// Обрабатывает запрос
  void _processRequest(
      TransportChannelClient client, M4RequestExtractedData extracted) async {
    final functionId = extracted.request.functionId;
    switch (extracted.request.functionId) {
      case M4SessionRequest.FunctionId:
        _processSessionRequest(client, extracted);
        break;
      case M4ParameterReadRequest.FunctionId:
        _processParameterReadRequest(client, extracted);
        break;
      default:
        print("Unsupported packet FunctionId: ${functionId}");
    }
  }

  /// Запускает работу
  @override
  void start(TransportChannel channel, List<DeviceSettings> devices) {
    _devicesByNetwork = Map.fromIterable(devices,
        key: (Object item) => (item as DeviceSettings).network,
        value: (Object item) => item as DeviceSettings);

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
