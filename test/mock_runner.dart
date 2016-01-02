library quark.test.mock_runner;

import 'package:quark/src/test/runner.dart';
import 'dart:async';

class MockRunner implements Runner {
  final List<String> history = <String>[];
  final List<Function> _toBeRun = <Function>[];
  var _setUp;
  var _tearDown;
  var _setUpAll;
  var _tearDownAll;
  List<Function> _toBeRunTarget;

  MockRunner() {
    _toBeRunTarget = _toBeRun;
  }

  String _descriptionAccumulator = '';

  void group(String description, body()) {
    final List<Function> target = <Function>[];
    final oldTarget = _toBeRunTarget;
    final oldAcc = _descriptionAccumulator;
    _toBeRunTarget = target;
    _descriptionAccumulator += '$description>';
    body();
    _descriptionAccumulator = oldAcc;
    _toBeRunTarget = oldTarget;
    oldTarget.add(() async {
      for (final t in target)
        await t();
    });
  }

  void test(String description, body()) {
    final id = '$_descriptionAccumulator$description';
    _toBeRunTarget.add(() async {
      await _setUp?.call();
      history.add(id);
      await body();
      await _tearDown?.call();
    });
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

  Future run() async {
    await _setUpAll?.call();
    for (final t in _toBeRun)
      await t();
    await _tearDownAll?.call();
  }
}