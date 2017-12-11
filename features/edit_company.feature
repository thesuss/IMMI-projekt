Feature: As a member
  in order to easily update my information
  I need to be able to edit my company

  Background:
    Given the following users exists
      | email                      | admin | member    |
      | applicant_1@happymutts.com |       | true      |
      | applicant_3@happymutts.com |       | false     |
      | admin@shf.se               | true  | true      |

    And the following companies exist:
      | name                 | company_number | email                  |
      | No More Snarky Barky | 5560360793     | snarky@snarkybarky.com |
      | Bowsers              | 2120000142     | bowwow@bowsersy.com    |

    And the following applications exist:
      | user_email                 | company_number | state    |
      | applicant_1@happymutts.com | 5560360793     | accepted |
      | applicant_3@happymutts.com | 2120000142     | accepted |


  Scenario: Member can edit their company
    Given I am logged in as "applicant_1@happymutts.com"
    And I am on the edit company page for "5560360793"
    Then I should see t("companies.edit.title", company_name: "No More Snarky Barky")

  Scenario: Prospective member can not edit their company
    Given I am logged in as "applicant_3@happymutts.com"
    And I am on the edit company page for "2120000142"
    Then I should not see t("companies.edit.title", company_name: "Bowsers")
    And I should see t("errors.not_permitted")

  Scenario: Visitor tries to edit a company
    Given I am Logged out
    And I am on the edit company page for "5560360793"
    Then I should see t("errors.not_permitted")

  Scenario: User can not edit someone elses company
    Given I am logged in as "applicant_3@happymutts.com"
    And I am on the edit company page for "5560360793"
    Then I should see t("errors.not_permitted")
