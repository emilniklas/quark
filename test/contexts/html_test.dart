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
    t.register(runner);
    await runner.run();
  }

  Future runShouldFail(String gherkin, [matching]) async {
    try {
      await runShouldSucceed(gherkin);
      fail('Test did not fail');
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

  test('visit', () async {
    final feature = '''
      Feature
        Scenario
          When I visit "page"
          When I go to "page"
          When I navigate to "page"
          When I visit page "page"
          When I go to page "page"
          When I navigate to page "page"
          When I visit url "page"
          When I go to url "page"
          When I navigate to url "page"
          Given I visit "page"
          Given I go to "page"
          Given I navigate to "page"
          Given I visit page "page"
          Given I go to page "page"
          Given I navigate to page "page"
          Given I visit url "page"
          Given I go to url "page"
          Given I navigate to url "page"
    ''';
    await runShouldFail(feature);
    String page;
    HtmlContext.navigator = (String navigateTo) async {
      page = navigateTo;
    };
    await runShouldSucceed(feature);
    expect(page, 'page');
  });
}


