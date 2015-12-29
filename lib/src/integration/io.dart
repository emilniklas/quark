library quark.src.integration.io;

import 'integration.dart' as common;
import 'dart:io';
import 'dart:mirrors';
import 'package:path/path.dart' as path;
import 'metadata.dart';
export 'integration.dart' hide IntegrationTest;

@integrationIoMetadata
class VmIntegrationIo implements common.IntegrationIo {
  final common.IntegrationTest test;

  VmIntegrationIo(this.test);

  String getFileContents(String file) {
    final testDirectory = new File.fromUri(reflect(test).type.location.sourceUri).parent.path;
    final featureLocation = path.normalize(path.join(testDirectory, file));

    return new File(featureLocation).readAsStringSync();
  }
}
