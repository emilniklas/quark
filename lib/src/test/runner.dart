library quark.test.runner;

import 'package:test/test.dart' as dart_test;

abstract class Runner {
  void test(String description, body());
  void group(String description, body());
}

class DartTestRunner implements Runner {
  void group(String description, body()) {
    dart_test.group(description, body);
  }

  void test(String description, body()) {
    dart_test.test(description, body);
  }
}
