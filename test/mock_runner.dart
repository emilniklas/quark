library quark.test.mock_runner;

import 'package:quark/src/test/runner.dart';

class MockRunner implements Runner {
  final List<String> history = [];
  var _setUp;
  var _tearDown;
  var _setUpAll;
  var _tearDownAll;

  String _descriptionAccumulator = '';

  void group(String description, body()) {
    final oldAcc = _descriptionAccumulator;
    _descriptionAccumulator += '$description>';
    body();
    _descriptionAccumulator = oldAcc;
  }

  void test(String description, body()) {
    _setUp?.call();
    history.add('$_descriptionAccumulator$description');
    body();
    _tearDown?.call();
  }

  void setUp(body()) {
    _setUp = body;
  }

  void setUpAll(body()) {
    _setUpAll = body;
  }

  void tearDown(body()) {
    _tearDown = body;
  }

  void tearDownAll(body()) {
    _tearDownAll = body;
  }

  void runSetUpAll() {
    _setUpAll?.call();
  }

  void runTearDownAll() {
    _tearDownAll?.call();
  }
}