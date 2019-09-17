import 'package:device_emulators/datasources/data_source.dart';
import 'package:device_emulators/settings/datasource_settings.dart';

/// Источник который выдаёт случайные числа
class RandomDataSource implements DataSource {
  /// Идентификатор источника в настройках
  static const ID = "Random";

  /// Конструктор
  RandomDataSource();

  /// Создаёт из настроек
  factory RandomDataSource.fromSettings(DataSourceSettings settings) {
    return RandomDataSource();
  }
}
