library quark.test.metadata;

import 'package:reflectable/reflectable.dart';
import '../timeline_hook_metadata.dart';

class TestMetadata extends Reflectable {
  const TestMetadata() : super(
      newInstanceCapability,
      libraryCapability,
      declarationsCapability,
      subtypeQuantifyCapability,
      const InstanceInvokeMetaCapability(TestCaseMetadata),
      const InstanceInvokeMetaCapability(TimelineHookMetadata),
      metadataCapability
  );
}

class TestCaseMetadata {
  const TestCaseMetadata();
}

const TestCaseMetadata test = const TestCaseMetadata();
const TestMetadata testMetadata = const TestMetadata();
