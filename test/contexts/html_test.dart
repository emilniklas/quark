@TestOn('browser')
library quark.test.contexts.html;

import 'package:test/test.dart';
import 'package:quark/integration.dart';
import 'package:quark/contexts/html.dart';
import '../mock_runner.dart';
import 'dart:html';
import 'dart:async';

class HtmlContextIntegrationTest = IntegrationTest with HtmlContext;

main() {
  MockRunner runner;

  setUp(() {
    runner = new MockRunner();
  });

  Future runShouldSucceed(String gherkin) async {
    final t = new HtmlContextIntegrationTest();
    t.useFeature(gherkin);
    await t.register(runner);
  }

  Future runShouldFail(String gherkin, [matching]) async {
    try {
      final completer = new Completer();
      runZoned(() {
        return runShouldSucceed(gherkin);
      }, onError: completer.completeError,
          zoneSpecification: new ZoneSpecification());
      await completer.future.timeout(
          const Duration(seconds: 10), onTimeout: () {
        fail('Test did not fail');
      });
    } catch (e) {
      if (matching != null)
        expect(e, matching);
    }
  }

  test('see on page', () async {
    final feature = '''
      Feature
        Scenario
          Then I see "content"
          Then I expect to see "content"
          Then I can see "content"
          Then I should see "content" on the page
          Then I should see "content" on the screen
    ''';
    await runShouldFail(feature);
    querySelector('body').appendText('content');
    await runShouldSucceed(feature);
  });
}