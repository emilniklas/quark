library quark.src.integration;

import 'package:quark/src/test/test.dart';

abstract class IntegrationTest extends Test {
  List get tests => [];
}

class Feature {
  final String value;

  const Feature(this.value);
}
