library test.gherkin.external_feature;

import 'package:quark/integration.dart';

abstract class ExternalFeatureImplementation {
  @Given('given')
  given() {}

  @When('when')
  when() {}

  @Then('then')
  then() {}
}