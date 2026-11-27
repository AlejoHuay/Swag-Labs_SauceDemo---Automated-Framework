# frozen_string_literal: true

require_relative 'base_page'

class LoginPage < BasePage
    USERNAME_FIELD = '[data-test="username"]'
    PASSWORD_FIELD = '[data-test="password"]'
    LOGIN_BUTTON = '[data-test="login-button"]'

    def open
        visit('/')
    end

    def sign_in(username:, password:)
        find(:css, USERNAME_FIELD).set(username)
        find(:css, PASSWORD_FIELD).set(password)
        find(:css, LOGIN_BUTTON).click
    end
end