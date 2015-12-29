library quark.src.integration.metadata;

import 'package:reflectable/reflectable.dart';

class FeatureMetadata extends Reflectable {
  const FeatureMetadata() : super(
      subtypeQuantifyCapability,
      typeCapability,
      metadataCapability,
      declarationsCapability,
      const InvokingMetaCapability(StepMetadata)
  );
}

class IntegrationIoMetadata extends Reflectable {
  const IntegrationIoMetadata() : super(newInstanceCapability);
}

class StepMetadata {
  final String pattern;

  const StepMetadata(this.pattern);

  String toString() => '$runtimeType $pattern';
}

const integrationIoMetadata = const IntegrationIoMetadata();
const featureMetadata = const FeatureMetadata();