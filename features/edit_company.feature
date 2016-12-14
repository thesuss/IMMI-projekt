Feature: As a member
  in order to easily update my information
  I need to be able to edit my company

  Background:
    Given the following users exists
      | email                      | admin |
      | applicant_1@happymutts.com |       |
      | applicant_3@happymutts.com |       |
      | admin@shf.se               | true  |

    And the following companies exist:
      | name                 | company_number | email                  |
      | No More Snarky Barky | 5560360793     | snarky@snarkybarky.com |
      | Bowsers              | 2120000142     | bowwow@bowsersy.com    |

    And the following applications exist:
      | first_name | user_email                 | company_number | status   |
      | Emma       | applicant_1@happymutts.com | 5560360793     | Accepted |
      | Anna       | applicant_3@happymutts.com | 2120000142     | Accepted |


  Scenario: User can to edit their company
    Given I am logged in as "applicant_1@happymutts.com"
    And I am on the edit company page for "5560360793"
    Then I should see "Webbsida (glöm inte http://)"

  Scenario: Visitor tries to edit a company
    Given I am Logged out
    And I am on the edit company page for "5560360793"
    Then I should see "Du har inte behörighet att göra detta."

  Scenario: User can not edit someone elses company
    Given I am logged in as "applicant_3@happymutts.com"
    And I am on the edit company page for "5560360793"
    Then I should see "Du har inte behörighet att göra detta."
