library quark.src.gherkin;

import 'tokens.dart';
import 'package:tuple/tuple.dart';

part 'tokenizer.dart';
part 'parser.dart';

Gherkin parse(String feature) {
  return new Parser(new Tokenizer(feature).tokenize()).parse();
}

class Gherkin {
  final String feature;
  final String description;
  final Iterable<Scenario> scenarios;

  const Gherkin({
    this.feature: '<anonymous feature>',
    this.description,
    this.scenarios: const []
  });

  factory Gherkin.parse(Parser parser) {
    parser.movePastBlankLines();

    if (parser.next.isA(TokenType.eof))
      return const Gherkin();

    // Feature
    parser.expect(
        TokenType.featureKeyword,
        'A feature must start with a feature keyword'
    ).move();

    // :
    if (parser.next.isA(TokenType.colon))
      parser.move();

    final feature = parser.readToEol().toString();

    final description = _parseDescription(parser).join('\n').trim();

    final scenarios = new List<Scenario>.unmodifiable(_parseScenarios(parser));

    return new Gherkin(
        feature: feature == '' ? '<anonymous feature>' : feature,
        description: description == '' ? null : description,
        scenarios: scenarios
    );
  }

  static Iterable<Scenario> _parseScenarios(Parser parser) sync* {
    parser.movePastBlankLines();
    while (parser.next.isntA(TokenType.eof)) {
      yield new Scenario.parse(parser);
    }
  }

  static Iterable<Sentence> _parseDescription(Parser parser) sync* {
    while (parser.next.isntAnyOf([TokenType.eof, TokenType.scenarioKeyword])) {
      if (parser.next.isA(TokenType.eol)) parser.move();
      else yield parser.readToEol();
    }
  }

  String toString() {
    final featurePart = 'Feature: $feature';
    final descriptionPart = description == null ? '' : '\n$description';
    final scenariosPart = scenarios.isEmpty ? '' : '\n\n${scenarios.join('\n\n')}';
    return '$featurePart$descriptionPart$scenariosPart';
  }

  bool operator ==(other) {
    return other is Gherkin
        && other.feature == feature
        && _equalIterables(other.scenarios, scenarios)
        && other.description == description;
  }
}

bool _equalIterables(Iterable a, Iterable b) {
  final ai = a.iterator;
  final bi = b.iterator;

  if (a.length != b.length) return false;

  while (ai.moveNext()) {
    if (!bi.moveNext()) return false;
    if (bi.current != ai.current) return false;
  }

  return true;
}

class Scenario {
  final Sentence description;
  final List<Step> steps;

  const Scenario({
    this.description: const Sentence(const []),
    this.steps: const []
  });

  factory Scenario.parse(Parser parser) {
    // Scenario
    parser.expect(
        TokenType.scenarioKeyword,
        'each scenario must start with "Scenario"'
    ).move();

    // :
    if (parser.next.isA(TokenType.colon))
      parser.move();

    final description = parser.readToEol();

    parser.movePastBlankLines();

    final steps = new List<Step>.unmodifiable(Step.parseMultiple(parser));

    return new Scenario(description: description, steps: steps);
  }

  bool operator ==(other) {
    return other is Scenario
        && _equalIterables(other.steps, steps)
        && other.description == description;
  }

  String toString() {
    final descriptionPart = description == null || description == ''
        ? ''
        : ': $description';

    final stepsPart = steps.isEmpty ? '' : '\n    ${steps.join('\n    ')}';
    return '  Scenario$descriptionPart$stepsPart';
  }
}

abstract class Step {
  final TokenType keywordType;
  final Sentence description;

  String get keyword;

  const Step(this.keywordType, this.description);

  bool operator ==(other) {
    return other is Step
        && other.keywordType == keywordType
        && other.description == description;
  }

  String toString() => '$keyword $description';

  factory Step.parse(Parser parser, [TokenType previousStepKeyword]) {
    if (previousStepKeyword == null) parser.expectActualStepKeyword();

    final keyword = parser.move();

    final description = parser.readToEol();

    final keywordToken = keyword.isActualStepKeyword
      ? keyword.type
      : previousStepKeyword;

    switch (keywordToken) {
      case TokenType.givenKeyword:
        return new GivenStep(description);
      case TokenType.thenKeyword:
        return new ThenStep(description);
      case TokenType.whenKeyword:
        return new WhenStep(description);
      default:
        throw new ParserException(keyword, 'expected a step keyword');
    }
  }

  static Iterable<Step> parseMultiple(Parser parser) sync* {
    TokenType previousStepKeyword;
    while (parser.next.isStepKeyword) {
      final step = new Step.parse(parser, previousStepKeyword);
      previousStepKeyword = step.keywordType;
      yield step;
      parser.movePastBlankLines();
    }
  }
}

class GivenStep extends Step {
  const GivenStep(Sentence description)
      : super(TokenType.givenKeyword, description);

  String get keyword => 'Given';

  bool operator ==(other) {
    return other is GivenStep
        && super == other;
  }
}

class WhenStep extends Step {
  const WhenStep(Sentence description)
      : super(TokenType.whenKeyword, description);

  String get keyword => 'When';

  bool operator ==(other) {
    return other is WhenStep
        && super == other;
  }
}

class ThenStep extends Step {
  const ThenStep(Sentence description)
      : super(TokenType.thenKeyword, description);

  String get keyword => 'Then';

  bool operator ==(other) {
    return other is ThenStep
        && super == other;
  }
}
