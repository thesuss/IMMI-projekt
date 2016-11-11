Feature: As an Admin
  So that we can accept or reject new Memberships,
  I need to review a Membership Application that has been submitted

Background:
Given the following applications exist:
  | company_name | company_number | contact_person | phone_number | company_email |
  | Hunderiet    | 1234567890     | Emma Svensson  | 1234-234567  | min@mail.se   |
  | DoggieZone   | 2345678901     | Pam Andersson  | 0234-234567  | din@mail.se   |
  | Tassa-in AB  | 1234367890     | Anna Knutsson  | 1234-234569  | sin@mail.se   |

Scenario: Listing incoming Applications
  Given I am on the list applications page
  Then I should see "Hunderiet"
  And I should see "DoggieZone"
  And I should see "Tassa-in AB"
  When I click on "DoggieZone"
  Then I should be on "DoggieZone" page
  And I should see "2345678901"
  And I should see "Pam Andersson"
  And I should see "0234-234567"
  And I should see "din@mail.se"
