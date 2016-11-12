Feature: As an applicant
  In order to be able to edit my application
  I want to be allowed to do that

  PT Feature: https://www.pivotaltracker.com/story/show/134078325


  Background:
    Given the following users exists
      | email                  |
      | applicant_1@random.com |
      | applicant_2@random.com |

    And the following applications exist
      | company_name       | user_email             |
      | My Dog Business    | applicant_1@random.com |
      | Other Dog Business | applicant_2@random.com |

  Scenario: Applicant wants can edit his own application
    Given I am logged in as "applicant_1@random.com"
    And I am on the landing page
    And I click on "My Application"
    Then I should be on "Edit My Application" page
    And I fill in "Company Name" with "A Doggy Dog World"
    And I click on "Submit"

  Scenario: Applicant can not edit applications not created by him
    Given I am logged in as "applicant_2@random.com"
    And I go to "Edit My Application" page for "applicant_1@random.com"
    Then I should see "You are not authorized to view this page"
    And I should be on "landing" page
