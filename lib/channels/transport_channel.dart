import 'dart:async';

import 'package:device_emulators/channels/transport_channel_client.dart';
import 'package:meta/meta.dart';

/// Базовый транспортный канал
abstract class TransportChannel {
  /// Название канал
  final String name;

  /// Контроллер потока входящих пользователей
  @protected
  final StreamController<TransportChannelClient> controller =
      StreamController<TransportChannelClient>();

  /// Поток входящих подключений пользователя
  Stream<TransportChannelClient> get onClient => controller.stream;

  /// Конструктор
  TransportChannel(this.name);

  /// Запускает работу канала
  void start();
}
