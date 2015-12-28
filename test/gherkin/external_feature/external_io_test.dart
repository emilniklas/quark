@TestOn('vm')

library test.gherkin.external_feature.io;

import 'package:quark/integration.dart';
export 'package:quark/init.dart';
export 'package:quark/vm.dart';

@Feature('external.feature')
class ExternalFeatureIoTest extends IntegrationTest {
  @Given('given')
  given() {}

  @When('when')
  when() {}

  @Then('then')
  then() {}
}
