Feature: Product catalog and shopping cart
  As a shopper
  I want to add products from the catalog to my cart
  so that I can review them before checking out

  Background:
    Given I am logged in as a standard user

  @smoke @catalog
  Scenario: The catalog shows the product list
    Then I should see the product list
    And every product should show a name, a price and an "Add to cart" button