import 'package:greeter/greeter.dart';
import 'package:quark/integration.dart';
export 'package:quark/init.dart';

@Feature(file: 'features/greets_on_home_page.feature')
class GreetsOnHomePageTest extends IntegrationTest {
  @When('I visit the home page')
  iVisitTheHomePage() async {
    await visit(file: 'web/index.html');
  }

  @Then('I should see a greeting')
  iShouldSeeAGreeting() async {
    await see('Hello, Jane!');
  }
}