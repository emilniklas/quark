library quark.src.integration;

import 'package:quark/src/test/test.dart';

class _StepMetadata {
  final String pattern;

  const _StepMetadata(this.pattern);
}

class Given extends _StepMetadata {
  const Given(String pattern) : super(pattern);
}

class When extends _StepMetadata {
  const When(String pattern) : super(pattern);
}

class Then extends _StepMetadata {
  const Then(String pattern) : super(pattern);
}

abstract class IntegrationTest extends Test {
  List get tests => [];
}

class Feature {
  final String value;

  const Feature(this.value);
}
