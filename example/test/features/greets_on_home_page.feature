Feature: Greets on the Home Page
  As a visitor to the site
  When I visit the home page
  I expect to be greeted in a friendly way

  Scenario: A standard visit
    When I visit the home page
    Then I should see a greeting