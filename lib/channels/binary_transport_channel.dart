import 'dart:typed_data';

/// Канал по которому устройство будет получать запросы
abstract class BinaryTransportChannel {
  /// Название канал
  final String name;

  /// Поток бинарных данных
  Stream<Uint8List> get onPacket;

  /// Добавляет байт в выходной поток
  void add(int byte);

  /// Конструктор
  BinaryTransportChannel(this.name);

  /// Запускает канал
  void start();
}
