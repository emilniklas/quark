# Quark

[![Build Status](https://travis-ci.org/emilniklas/quark.svg?branch=master)](https://travis-ci.org/emilniklas/quark)
[![Coverage Status](https://coveralls.io/repos/emilniklas/quark/badge.svg?branch=master&service=github)](https://coveralls.io/github/emilniklas/quark?branch=master)

---

### Abstract

Quark is a comprehensive testing framework, covering different styles and types of tests.
Reflection with [Reflectable](https://pub.dartlang.org/packages/reflectable) makes test doubles,
grouping and test definition a breeze.

It wraps the [test](https://pub.dartlang.org/packages/test) package and works alongside other tools
with the usual test runner.

## Usage
Add `quark` and `test` to the development dependencies of your project.

```yaml
# pubspec.yaml
dev_dependencies:
  quark: any
  test: any # To get access to the test runner executable
```

```shell
> pub get
# Run the tests with the usual test runner command
> pub run test
```

### Unit Testing
```dart
// lib/greeter.dart

class Greeter {
  final Greeting greeting;

  Greeter(this.greeting);

  String greet(String name) {
    return '${greeting.phrase}, $name!';
  }
}

// An example of a collaborator that can be mocked
class Greeting {
  final String phrase;

  const Greeting(this.phrase);
}
```

```dart
// test/unit/greeter_test.dart
import 'package:quark/quark.dart';
export 'package:quark/init.dart';

import 'package:greeter/greeter.dart';

// Clean test double declaration inspired by Mockito
class GreetingDouble extends TestDouble implements Greeting {}

class GreeterTest extends UnitTest {
  @test itGreetsAPerson() {
    // Creation using test double
    final greeting = new GreetingDouble();
    final greeter = new Greeter(greeting);

    // The greeting will return "Yo"
    when(greeting.phrase).thenReturn('Yo');

    // Make the assertion
    expect(greeter.greet('buddy'), 'Yo, buddy!');

    // Verify that the phrase was fetched from the greeting.
    verify(greeting.phrase).wasCalled();
  }
}
```

### Integration Testing with Gherkin Features!
The Gherkin language, introduced by the [Cucumber](https://cucumber.io) project, is a way to
write features and business expectations in an extremely readable way.

```gherkin
# test/integration/welcome_on_home_screen.feature
Feature: Welcome message on the home screen

Scenario: Not logged in
  Given I'm not logged in
  When I visit the home page
  Then I expect to see "Hello, Guest!"
```

To write the implementations of feature steps, extend the `IntegrationTest` class and
and annotate with the `Feature` annotation.

```dart
// test/integration/welcome_on_home_screen_test.dart

// The TestOn annotation and browser.dart export enables
// reading features by relative URI.
@TestOn('browser')
export 'package:quark/browser.dart';

// There is also a vm implementation.
// @TestOn('vm')
// export 'package:quark/vm.dart';

import 'package:quark/quark.dart';
export 'package:quark/init.dart';

@Feature('welcome_on_home_screen.feature')
// The Gherkin can also be written inline and can then be run in both
// the browser and the vm.
// @Feature('''
//   Feature: ...
// ''')
class WelcomeMessageOnTheHomeScreenTest extends IntegrationTest {
  @Given("I'm not logged in")
  imNotLoggedIn() {}

  @When("I visit the home page")
  iVisitTheHomePage() {}

  @Then("I expect to see \"(.*?)\"")
  iExpectToSee(String message) {}
}
```

If there are steps in the feature that have no implementation in the test, the test runner
will print out snippets that can be copied into the test. Simple!

## Running tests
Quark works on all platforms. Here's how to run all the tests:

```shell
> git clone https://github.com/emilniklas/quark.git
> cd quark
> pub serve # Start the transformer server - for Reflectable

# Then, in another tab
> pt -p vm,dartium,content-shell && pt -p chrome,phantomjs,firefox,safari --pub-serve=8080
```
