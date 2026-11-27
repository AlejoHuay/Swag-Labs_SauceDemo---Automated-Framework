# frozen_string_literal: true

Given('I am on the login page') do
  @login_page = LoginPage.new
  @login_page.open
end

When('I sign in with valid standard user credentials') do
  @login_page.sign_in(
    username: ENV.fetch('TEST_USERNAME'),
    password: ENV.fetch('TEST_PASSWORD')
  )
end

Then('I should see the product catalog') do
  expect(page).to have_current_path('/inventory.html')
  expect(page).to have_content('Products')
end