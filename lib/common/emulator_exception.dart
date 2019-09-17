/// Исключение эмулятора
class EmulatorException implements Exception {
  /// Сообщение
  final String message;

  /// Конструктор
  EmulatorException(this.message);
}