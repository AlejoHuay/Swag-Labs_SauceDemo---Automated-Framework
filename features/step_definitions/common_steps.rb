# frozen_string_literal: true

Given('I am logged in as a standard user') do
    @login_page = LoginPage.new
    @login_page.open

    @login_page.sign_in(
        username: ENV.fetch('TEST_USERNAME'),
        password: ENV.fetch('TEST_PASSWORD')
    )   

    expect(page).to have_current_path('/inventory.html')
end