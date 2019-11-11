import 'package:device_emulators/emulator/emulator.dart';
import 'package:device_emulators/settings/emulator_settings.dart';

/// Запускает эмулятор EK270
void main(List<String> args) async {
  final settings = EmulatorSettings.fromYaml("bin/settings/ek270.yaml");
  final emulator = Emulator(settings);
  await emulator.start();
}