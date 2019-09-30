import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:device_emulators/channels/transport_channel.dart';

/// Канал серверного сокета
class TcpServerChannel extends TransportChannel {
  /// Контроллер потока
  final StreamController<Uint8List> _controller = StreamController<Uint8List>();

  /// Порт для прослушивания входящих соединений
  final int port;

  /// Поток бинарных данных
  @override
  Stream<Uint8List> get onPacket => _controller.stream;

  /// Конструктор
  TcpServerChannel(String name, this.port) : super(name);

  /// Запускает канал
  @override
  void start() {
    ServerSocket.bind(InternetAddress.anyIPv4, port).then((server) {
      print("TcpServer started PORT: ${port}");
      server.listen(
          (client) {
            print("Client recieved: ${client.address.host}");
            client.listen((data) {
              _controller.add(data);
            }, onDone: () {
              _controller.addError(Exception("Connection closed"));
            }, onError: (Object e) {
              print("Client error: $e");
            });
          },
          onDone: () {},
          onError: (dynamic e) {
            print(e);
          });
    });
  }
}
