Feature: As an admin
  So that I can view and manage companies
  I need to be able to create them

  Companies are created when a membership application is approved. That
  will not have any user interaction, but we need to have companies
  exist and the admin needs to be able to see the list of them.

  This feature exercises what happens when a company is created and is the
  basis for a member being able to edit their company page.

  PT:  https://www.pivotaltracker.com/story/show/133081453

  Background:
    Given the following users exists
      | email                      | admin |
      | applicant_1@happymutts.com |       |
      | applicant_3@happymutts.com |       |
      | admin@shf.se               | true  |

    Given the following regions exist:
      | name         |
      | Stockholm    |
      | Västerbotten |
      | Norrbotten   |

    Given the following kommuns exist:
      | name      |
      | Bromölla  |

    And the following companies exist:
      | name                 | company_number | email                  | region     |
      | No More Snarky Barky | 5560360793     | snarky@snarkybarky.com | Stockholm  |
      | Bowsers              | 2120000142     | bowwow@bowsersy.com    | Norrbotten |

    Given the following payments exist
      | user_email                 | start_date | expire_date | payment_type | status | hips_id | company_number |
      | applicant_1@happymutts.com | 2017-01-01 | 2017-12-31  | branding_fee | betald | none    | 5560360793     |
      | applicant_3@happymutts.com | 2017-01-01 | 2017-12-31  | branding_fee | betald | none    | 2120000142     |

    And the following applications exist:
      | user_email                 | company_number | state    |
      | applicant_1@happymutts.com | 5560360793     | accepted |
      | applicant_3@happymutts.com | 2120000142     | accepted |


    And the following business categories exist
      | name         |
      | Groomer      |
      | Psychologist |
      | Trainer      |
      | Awesome      |

  Scenario: Admin sees all companies listed
    Given I am logged in as "admin@shf.se"
    When I am on the "all companies" page
    Then I should see "No More Snarky Barky"
    And I should see "Bowsers"

  Scenario: User tries to create a company
    Given I am logged in as "applicant_1@happymutts.com"
    And I am on the "create a new company" page
    Then I should see t("errors.not_permitted")

  Scenario: Visitor tries to create a company
    Given I am Logged out
    And I am on the "create a new company" page
    Then I should see t("errors.not_permitted")

  Scenario: Admin creates a company
    Given I am logged in as "admin@shf.se"
    When I am on the "create a new company" page
    And I fill in the translated form with data:
      | companies.company_name | companies.show.company_number | companies.show.email | companies.website_include_http |
      | Happy Mutts            | 5569467466                    | kicki@gladajyckar.se | http://www.gladajyckar.se      |
    And I click on t("submit")
    Then I should see t("companies.create.success")
    Then I click on t("companies.show.add_address")
    And I fill in the translated form with data:
      | companies.show.street | companies.show.post_code | companies.show.city |
      | Ålstensgatan 4        | 123 45                   | Bromma              |
    And I select "Stockholm" in select list t("companies.operations_region")
    And I select "Bromölla" in select list t("companies.show.kommun")
    Then I click on t("submit")
    And I should see t("addresses.create.success_sole_address")
    And I should see "1" address
    And I should not see the radio button with id "cb_address_3" unchecked
    And I should see "Happy Mutts"
    And I should see "123 45"
    And I should see "Bromma"
    And I should see "Bromölla"
    And the "http://www.gladajyckar.se" should go to "http://www.gladajyckar.se"

  Scenario Outline: Admin creates company - when things go wrong
    Given I am logged in as "admin@shf.se"
    When I am on the "create a new company" page
    And I fill in the translated form with data:
      | companies.company_name | companies.show.company_number | companies.show.email | companies.telephone_number | companies.website_include_http |
      | <name>                 | <org_number>                  | <email>              | <phone>                    | <website>                      |
    When I click on t("submit")
    Then I should see <error>
    And I should see t("companies.create.error")

    Scenarios:
      | name        | org_number | phone      | email                | website                   | error                                                        |
      | Happy Mutts | 00         | 0706898525 | kicki@gladajyckar.se | http://www.gladajyckar.se | t("errors.messages.wrong_length", count: 10)                 |
      | Happy Mutts | 5562252998 |            | kickiimmi.nu         | http://www.gladajyckar.se | t("errors.messages.invalid")                                 |
      | Happy Mutts | 5562252998 |            | kicki@imminu         | http://www.gladajyckar.se | t("errors.messages.invalid")                                 |
      | Happy Mutts | 5560360793 | 0706898525 | kicki@imminu.se      | http://www.gladajyckar.se | t("activerecord.errors.models.company.company_number.taken") |

  @time_adjust
  Scenario: Admin edits a company and visitor views changes
    Given the date is set to "2017-10-01"
    And I am logged in as "admin@shf.se"
    And I am on the edit company page for "5560360793"
    When I fill in the translated form with data:
      | companies.show.email | companies.website_include_http |
      | kicki@gladajyckar.se | http://www.snarkybarkbark.se   |
    And I click on t("submit")
    Then I should see t("companies.update.success")
    And I should see "kicki@gladajyckar.se"
    And the "http://www.snarkybarkbark.se" should go to "http://www.snarkybarkbark.se"
    Then I click on t("companies.show.add_address")
    And I fill in the translated form with data:
      | activerecord.attributes.address.street | activerecord.attributes.address.post_code | activerecord.attributes.address.city |
      | 1 Algovik                              | 919 32                                    | Åsele                                |
    And I select "Västerbotten" in select list t("activerecord.attributes.address.region")
    And I select "Bromölla" in select list t("activerecord.attributes.address.kommun")
    Then I click on t("submit")
    And I wait 10 seconds
    And I should see "Algovik"
    And I should see "Bromölla"
    And I should see t("address_visibility.street_address")

    And I am Logged out
    And I am on the "landing" page
    And I click on "No More Snarky Barky"
    And I should see "1 Algovik"
    And I should see "Bromölla"
    And I should see "919 32"
    And I should not see t("address_visibility.street_address")


  Scenario Outline: Admin edits a company - when things go wrong (sad case)
    Given I am logged in as "admin@shf.se"
    And I am on the edit company page for "5560360793"
    And I fill in the translated form with data:
      | companies.company_name | companies.show.company_number | companies.show.email | companies.telephone_number | companies.website_include_http |
      | <name>                 | <org_number>                  | <email>              | <phone>                    | <website>                      |
    When I click on t("submit")
    Then I should see error <model_attribute> <error>
    And I should see t("companies.update.error")

    Scenarios:
      | name        | org_number | phone | email        | website                   | model_attribute                            | error                        |
      | Happy Mutts | 5560360793 |       | kickiimmi.nu | http://www.gladajyckar.se | t("activerecord.attributes.company.email") | t("errors.messages.invalid") |
      | Happy Mutts | 5560360793 |       | kicki@imminu | http://www.gladajyckar.se | t("activerecord.attributes.company.email") | t("errors.messages.invalid") |


  Scenario Outline: Admin edits a company: company number is wrong length
    Given I am logged in as "admin@shf.se"
    And I am on the edit company page for "5560360793"
    And I fill in the translated form with data:
      | companies.company_name | companies.show.company_number | companies.show.email | companies.telephone_number | companies.website_include_http |
      | <name>                 | <org_number>                  | <email>              | <phone>                    | <website>                      |
    When I click on t("submit")
    Then I should see t("errors.messages.wrong_length.other", count: 10)

    Scenarios:
      | name        | org_number | phone      | email                | website                   |
      | Happy Mutts | 00         | 0706898525 | kicki@gladajyckar.se | http://www.gladajyckar.se |


  Scenario: Website path is incomplete (does not include http://)
    Given I am logged in as "admin@shf.se"
    And I am on the edit company page for "5560360793"
    When I fill in the translated form with data:
      | companies.website_include_http |
      | www.snarkybarkbark.se          |
    And I click on t("submit")
    Then I should see t("companies.update.success")
    And the "www.snarkybarkbark.se" should go to "http://www.snarkybarkbark.se"

  Scenario: Website path is complete (includes http://)
    Given I am logged in as "admin@shf.se"
    And I am on the edit company page for "5560360793"
    When I fill in the translated form with data:
      | companies.website_include_http |
      | http://www.snarkybarkbark.se   |
    And I click on t("submit")
    Then I should see t("companies.update.success")
    And the "www.snarkybarkbark.se" should go to "http://www.snarkybarkbark.se"
