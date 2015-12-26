library quark.test.mock_runner;

import 'package:quark/src/test/runner.dart';

class MockRunner implements Runner {
  void group(String description, body()) {
    body();
  }

  void test(String description, body()) {
    body();
  }
}