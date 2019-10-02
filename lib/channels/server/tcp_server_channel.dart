import 'dart:io';

import 'package:device_emulators/channels/server/tcp_server_client.dart';
import 'package:device_emulators/channels/transport_channel.dart';

/// Канал серверного сокета
class TcpServerChannel extends TransportChannel {
  /// Порт для прослушивания входящих соединений
  final int port;

  /// Конструктор
  TcpServerChannel(String name, this.port) : super(name);

  /// Запускает канал
  @override
  void start() {
    ServerSocket.bind(InternetAddress.anyIPv4, port).then((server) {
      print("TcpServer started PORT: ${port}");
      server.listen(
          (socket) {
            print("Client recieved: ${socket.address.host}");

            final channelClient = TcpServerClient(socket);
            controller.add(channelClient);
          },
          onDone: () {},
          onError: (dynamic e) {
            print(e);
          });
    });
  }
}
