import 'package:device_emulators/channels/transport_channel.dart';
import 'package:device_emulators/channels/transport_channel_client.dart';
import 'package:device_emulators/drivers/emulator_driver.dart';
import 'package:device_emulators/settings/device_settings.dart';
import 'package:device_protocols/channel_protocols/iec1107_protocol/handlers/iec1107_server_channel_protocol_handler.dart';
import 'package:device_protocols/channel_protocols/iec1107_protocol/iec1107_command_type.dart';
import 'package:device_protocols/channel_protocols/iec1107_protocol/iec1107_speed.dart';
import 'package:device_protocols/channel_protocols/iec1107_protocol/requests/iec1107_program_request.dart';

/// Драйвер
class EK270Driver extends EmulatorDriver {
  /// Идентификатор устройства в настройках
  static const ID = "EK270";

  /// Трёх буквенный код производителя
  static const Manufacturer = "Els";

  /// Фиктивный ключ пароля
  static const PasswordKey = "12345678";

  /// Устройства по сетевому номеру
  var _devicesByNetwork = Map<String, DeviceSettings>();

  /// Обрабатывает клиента
  void _processClient(TransportChannelClient client) async {
    final handler = IEC1107ServerChannelProtocolHandler(client);
    // Читает пакет начала сессии
    final network = await handler.readStartSession();

    DeviceSettings device;

    if (network.isEmpty) {
      device = _devicesByNetwork.values.first;
    } else {
      device = _devicesByNetwork[network];
    }

    if (device == null) {
      return;
    }

    // Отправляет пакет идентификации
    handler.sendIdent(Manufacturer, IEC1107SpeedC.Custom6, ID);
    // Читает режим работы
    final mode = await handler.readMode();
    // Отправляет ключ пароля
    handler.sendPasswordKey(PasswordKey);

    /// Читает запросы в режиме программирования пока не истечёт таймаут
    IEC1107ProgramRequest request;
    do {
      request = await handler.readProgrammRequest();
      _processRequest(handler, request);
    } while ((request != null));
  }

  /// Обрабатывает команды R1
  void _processR1Command(
      IEC1107ServerChannelProtocolHandler handler, String data) {}

  /// Обрабатывает запрос
  void _processRequest(IEC1107ServerChannelProtocolHandler handler,
      IEC1107ProgramRequest request) {
    switch (request.command) {
      case IEC1107CommandType.R1:
        _processR1Command(handler, request.data);
        break;
      case IEC1107CommandType.W1:
        break;
    }
  }

  /// Запускает исполнение
  @override
  void start(TransportChannel channel, List<DeviceSettings> devices) {
    _devicesByNetwork = Map.fromIterable(devices,
        key: (Object item) => (item as DeviceSettings).network,
        value: (Object item) => item as DeviceSettings);

    channel.onClient.listen(_processClient,
        onError: (Object e, StackTrace stack) {
      print(e);
    });
  }
}
