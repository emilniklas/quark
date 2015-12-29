library quark.test.metadata;

import 'package:reflectable/reflectable.dart';

class TestMetadata extends Reflectable {
  const TestMetadata() : super(
      newInstanceCapability,
      libraryCapability,
      declarationsCapability,
      subtypeQuantifyCapability,
      instanceInvokeCapability,
      metadataCapability,
      reflectedTypeCapability
  );
}

const TestMetadata testMetadata = const TestMetadata();