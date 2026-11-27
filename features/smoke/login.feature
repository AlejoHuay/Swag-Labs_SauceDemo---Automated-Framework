Feature: User authentication

    @smoke @login_success
    Scenario: Standard user signs in successfully
        Given I am on the login page
        When I sign in with valid standard user credentials
        Then I should see the product catalog
