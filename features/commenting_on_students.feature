Feature: Commenting on people
  In order to provide more focussed information on a person
  As a user
  I want to add multiple dated comments on a user

  Scenario: Add a comment
    Given I am a new, authenticated user
    And a student called "Oum Bora"
    When I go to the person page for "Oum Bora"
    And I add the comment "This is a comment on the student"
    Then the student "Oum Bora" should have the comments "This is a comment on the student"
