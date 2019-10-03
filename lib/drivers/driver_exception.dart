/// Исключение драйвера
class DriverException implements Exception {
  /// Сообщение
  final String message;

  /// Конструктор
  DriverException(this.message);

  /// Преобразует в строку
  @override
  String toString() { 
    return message;
  }
}
