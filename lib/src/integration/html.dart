library quark.src.integration.html;

import 'integration.dart' as common;
import 'metadata.dart';
import 'dart:html';
import 'package:path/path.dart' as path;
export 'integration.dart' hide IntegrationTest;

@integrationIoMetadata
class BrowserIntegrationIo implements common.IntegrationIo {
  final common.IntegrationTest test;

  BrowserIntegrationIo(this.test);

  String getFileContents(String file) {
    final http = new HttpRequest();
    final dir = path.dirname(window.location.toString().replaceFirst(window.location.hash, ''));
    final url = path.normalize(path.join(dir, file));
    http.open('get', url, async: false);
    http.send();
    return http.responseText;
  }
}
