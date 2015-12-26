library quark.test.runner;

import 'package:test/test.dart' as dart_test;

abstract class Runner {
  void test(String description, body());
  void group(String description, body());
  void setUpAll(body());
  void setUp(body());
  void tearDownAll(body());
  void tearDown(body());
}

class DartTestRunner implements Runner {
  void group(String description, body()) {
    dart_test.group(description, body);
  }

  void test(String description, body()) {
    dart_test.test(description, body);
  }

  void setUp(body()) {
    dart_test.setUp(body);
  }

  void setUpAll(body()) {
    dart_test.setUpAll(body);
  }

  void tearDown(body()) {
    dart_test.tearDown(body);
  }

  void tearDownAll(body()) {
    dart_test.tearDownAll(body);
  }
}
