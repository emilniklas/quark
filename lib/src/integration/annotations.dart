part of quark.integration;

class _GherkinAnnotation {
  final String pattern;

  const _GherkinAnnotation(this.pattern);
}

class When extends _GherkinAnnotation {
  const When(String pattern) : super(pattern);
}

class Then extends _GherkinAnnotation {
  const Then(String pattern) : super(pattern);
}

class Feature {
  final String file;

  const Feature({this.file});
}
