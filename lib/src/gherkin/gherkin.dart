library quark.src.gherkin;

import 'tokens.dart';
import 'package:tuple/tuple.dart';

part 'tokenizer.dart';
part 'parser.dart';

Gherkin parse(String feature) {
  return const Gherkin();
}

class Gherkin {
  final String feature;
  final String description;

  const Gherkin({
    this.feature: '<anonymous feature>',
    this.description
  });

  String toString() {
    final featurePart = 'Feature: $feature';
    final descriptionPart = description == null ? '' : '\n$description';
    return '$featurePart$descriptionPart';
  }
}
