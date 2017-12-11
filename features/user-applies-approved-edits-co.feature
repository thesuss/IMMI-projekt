Feature: Whole process of a new user creating a login, applying, being approved, editing their company
  This exercises the entire process to ensure that data we are creating in the features and/or factories is not somehow masking any problems.

  Background:
    Given the following users exists
      | email                | admin |
      | new_user@example.com |       |
      | admin@shf.se         | true  |

    Given the following regions exist:
      | name         |
      | Stockholm    |
      | Västerbotten |

    Given the following kommuns exist:
      | name     |
      | Alingsås |

    And the following business categories exist
      | name         |
      | Groomer      |
      | Psychologist |


  @admin, @user, @member
  Scenario: User creates login, admin approves, user edits company, blank main address is displayed
    Given I am in "new_user@example.com" browser
    And I am logged in as "new_user@example.com"
    And I am on the "landing" page
    And I click on t("menus.nav.users.apply_for_membership")
    And I fill in the translated form with data:
      | membership_applications.new.first_name | membership_applications.new.last_name | membership_applications.new.company_number | membership_applications.new.phone_number | membership_applications.new.contact_email |
      | NewUser1                               | NewLastName                           | 5562252998                                 | 031-1234567                              | new_user@example.com                      |
    And I select "Groomer" Category
    And I click on t("membership_applications.new.submit_button_label")
    And I should see t("membership_applications.create.success", email_address: new_user@example.com)

    Then I am in "admin@shf.se" browser
    And I am logged in as "admin@shf.se"
    And I am on the "landing" page
    And I click on t("menus.nav.admin.manage_applications")
    Then I should see "NewUser1"
    And I am on the "application" page for "new_user@example.com"
    And I click on t("membership_applications.start_review_btn")
    And I click on t("membership_applications.accept_btn")
    And I should be on the "edit application" page for "new_user@example.com"
    And I should not see t("membership_applications.update.enter_member_number")
    And I click on t("membership_applications.edit.submit_button_label")
    Then I should see t("membership_applications.update.success")
    And I should see t("membership_applications.accepted")

    Given I am in "new_user@example.com" browser
    And I am logged in as "new_user@example.com"
    And I am on the "user details" page for "new_user@example.com"
    Then I click on t("menus.nav.members.pay_membership")
    And I complete the payment
    And I should see t("payments.success.success")

    Then I am in "admin@shf.se" browser
    And I am on the "application" page for "new_user@example.com"
    And I click on t("membership_applications.edit_membership_application")

    And I fill in t("membership_applications.show.membership_number") with "10101"
    And I click on t("membership_applications.edit.submit_button_label")
    Then I should see t("membership_applications.update.success")
    And I should see t("membership_applications.accepted")
    And I should see "10101"
    And I am logged out
    And I am logged in as "new_user@example.com"
    And I am on the "user details" page for "new_user@example.com"
    And I click on t("menus.nav.members.manage_company.edit_company")
    Then I should see t("companies.edit.title", company_name: "")
    And I should see t("companies.company_name")
    And I should see t("companies.show.company_number")
    And I should see t("companies.telephone_number")
    And I should see t("companies.show.email")
    And I should see t("companies.show.website")
    Then I click on the second t("companies.view_company") link
    Then I click on t("companies.show.add_address")
    And I should see t("companies.show.street")
    And I should see t("companies.show.post_code")
    And I should see t("companies.show.city")
    And I should see t("companies.show.kommun")
    And I should see t("companies.show.region")
