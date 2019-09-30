import 'package:device_emulators/emulator/emulator.dart';
import 'package:device_emulators/settings/emulator_settings.dart';

/// Запускает эмулятор тепловычислителя Логика СПТ 943 с новым протоколом M4
void main(List<String> args) async {
  final settings = EmulatorSettings.fromYaml("settings/spt943.yaml");
  final emulator = Emulator(settings);
  await emulator.start();
}