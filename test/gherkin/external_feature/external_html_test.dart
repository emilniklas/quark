@TestOn('browser')

library test.gherkin.external_feature.html;

import 'package:quark/integration.dart';
export 'package:quark/init.dart';
export 'package:quark/browser.dart';

@Feature('external.feature')
class ExternalFeatureHtmlTest extends IntegrationTest {
  @Given('given')
  given() {}

  @When('when')
  when() {}

  @Then('then')
  then() {}
}
