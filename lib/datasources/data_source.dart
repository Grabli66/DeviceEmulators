import 'package:device_emulators/datasources/random_data_source.dart';
import 'package:device_emulators/settings/datasource_settings.dart';

/// Базовый источник данных для устройства
abstract class DataSource {
  /// Создаёт из настроек
  factory DataSource.fromSettings(DataSourceSettings settings) {
    switch (settings.type) {
      case RandomDataSource.ID:
        return RandomDataSource.fromSettings(settings);
    }

    return null;
  }
}
