import 'dart:typed_data';

/// Канал по которому устройство будет получать запросы
abstract class TransportChannel {
  /// Название канал
  final String name;

  /// Поток бинарных данных
  Stream<Uint8List> get onPacket;

  /// Конструктор
  TransportChannel(this.name);

  /// Запускает канал
  void start();
}
