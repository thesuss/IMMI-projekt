And(/^the following applications exist:$/) do |table|
  table.hashes.each do |hash|
    application_attributes = hash.except('user_email')
    user = User.find_by(email: hash[:user_email])
    FactoryGirl.create(:membership_application, application_attributes.merge(user: user))
  end
end

And(/^I navigate to the edit page for "([^"]*)"$/) do |company_name|
  membership_application = MembershipApplication.find_by(company_name: company_name)
  visit edit_membership_application_path(membership_application)
end

Given(/^I am on "([^"]*)" application page$/) do |company_name|
  membership = MembershipApplication.find_by(company_name: company_name)
  visit membership_application_path(membership)
end

Given(/^I am on the list applications page$/) do
  visit membership_applications_path
end