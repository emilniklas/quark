import 'package:quark/quark.dart';
export 'package:quark/init.dart';

@Feature('something.feature')
class SomethingTest extends IntegrationTest {
  @Given('that something is done')
  thatSomethingIsDone() {
    // ...
  }

  @When('I do something else')
  iDoSomethingElse() {
    // ...
  }

  @Then('I expect something')
  iExpectSomething() {
    // ...
  }
}