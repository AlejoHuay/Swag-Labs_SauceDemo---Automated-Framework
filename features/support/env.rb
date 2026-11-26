# frozen_string_literal: true

require 'bundler/setup'
require_relative '../../config/browser'
require 'capybara/cucumber'
require 'rspec/expectations'
require 'capybara-screenshot'
require 'securerandom'

World(RSpec::Matchers)
Framework::Browser.configure
Capybara.save_path = File.expand_path('../../screenshots', __dir__)
Capybara::Screenshot.autosave_on_failure = false
Capybara::Screenshot.append_random = true
Capybara::Screenshot.register_driver(:framework_chrome) do |driver, path|
  driver.browser.save_screenshot(path)
end

require_relative '../pages/base_page'
Dir[File.expand_path('../pages/**/*.rb', __dir__)].sort.each { |path| require path }
Dir[File.expand_path('../step_definitions/**/*.rb', __dir__)].sort.each { |path| require path }
require_relative 'hooks'
