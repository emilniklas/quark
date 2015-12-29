library quark.src.test_double.metadata;

import 'package:reflectable/reflectable.dart';

class TestDoubleMetadata extends Reflectable {
  const TestDoubleMetadata() : super(
      subtypeQuantifyCapability,
      reflectedTypeCapability,
      newInstanceCapability,
      classifyCapability
  );
}

const TestDoubleMetadata testDoubleMetadata = const TestDoubleMetadata();

class Delegatable extends Reflectable {
  const Delegatable() : super(delegateCapability, instanceInvokeCapability);
}

