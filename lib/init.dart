library quark.init;

import 'src/test/test.dart';
import 'src/test/runner.dart';
import 'package:reflectable/mirrors.dart';
import 'src/test/metadata.dart';

main() async {
  final testRunner = new DartTestRunner();
  final classes = testMetadata.libraries.values
      .expand((l) => l.declarations.values)
      .where((ClassMirror m) => m is ClassMirror && !m.isAbstract);
  for (final mirror in classes) {
    final instance = mirror.newInstance('', []);
    if (instance is! Test) continue;
    await instance.register(testRunner);
  }
}