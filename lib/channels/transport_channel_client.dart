import 'dart:async';
import 'dart:typed_data';

/// Канал с установкой связи к серверу
abstract class TransportChannelClient {
  /// Контроллирует поток бинарных данных
  StreamController<Uint8List> controller = StreamController<Uint8List>();

  /// Поток бинарных данных
  Stream<Uint8List> get onPacket => controller.stream;

  /// Отправляет байт в канал
  void add(int byte);

  /// Отправляет набор байт в канал
  void addList(Uint8List data);
}
