# Quark

[![Build Status](https://travis-ci.org/emilniklas/quark.svg?branch=master)](https://travis-ci.org/emilniklas/quark)
[![Coverage Status](https://coveralls.io/repos/emilniklas/quark/badge.svg?branch=master&service=github)](https://coveralls.io/github/emilniklas/quark?branch=master)

---

### Abstract

Quark is a comprehensive testing framework, covering different styles and types of tests.
Reflection with [Reflectable](https://pub.dartlang.org/packages/reflectable) makes test doubles,
grouping and test definition a breeze.

## Usage

### Unit Testing

```dart
// greeter.dart

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
// greeter_test.dart
import 'package:quark/quark.dart';
import 'greeter.dart';
export 'package:quark/init.dart';

class GreeterTest extends UnitTest {
  @test itGreetsAPerson(GreetingDouble greeting) {
    // Creation using injected test double
    final greeter = new Greeter(greeting);

    // The greeting will return "Yo"
    when(greeting.phrase).thenReturn('Yo');

    // Make the assertion
    expect(greeter.greet('buddy'), 'Yo, buddy!');

    // Verify that the phrase was fetched from the greeting.
    verify(greeting.phrase).wasCalled();
  }
}

// Clean test double declaration inspired by Mockito
class GreetingDouble extends TestDouble implements Greeting {}
```

### Integration Testing with Gherkin Features!

```gherkin
Feature: Welcome message on the home screen

Scenario: Not logged in
  Given I'm not logged in
  When I visit the home page
  Then I expect to see "Hello, Guest!"
```

```dart
import 'package:quark/quark.dart';
export 'package:quark/init.dart';

class WelcomeMessageOnTheHomeScreenTest extends IntegrationTest {
  @Given("I'm not logged in")
  imNotLoggedIn() {}

  @When("I visit the home page")
  iVisitTheHomePage() {}

  @Then("I expect to see \"(.*?)\"")
  iExpectToSee(String message) {}
}
```

## Running tests
Quark works on all platforms. Here's how to run all the tests:

```shell
> git clone https://github.com/emilniklas/quark.git
> cd quark
> pub serve # Start the transformer server - for Reflectable

# Then, in another tab
> pt -p vm,dartium,content-shell && pt -p chrome,phantomjs,firefox,safari --pub-serve=8080
```
