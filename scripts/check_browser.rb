# frozen_string_literal: true

status = 0
session = nil
begin
  require 'bundler/setup'
  require_relative '../config/browser'
  Framework::Browser.configure
  session = Capybara::Session.new(:framework_chrome)
  session.visit('about:blank')
  raise 'El navegador no permaneció en about:blank.' unless session.current_url == 'about:blank'

  capabilities = session.driver.browser.capabilities
  puts "Sesión técnica creada: #{capabilities.browser_name} #{capabilities.browser_version}; about:blank."
rescue StandardError, LoadError => error
  warn "Diagnóstico fallido: #{error.class}: #{error.message}"
  warn 'Revise bundle check y las rutas locales CHROME_BINARY/CHROMEDRIVER_PATH. No se instalaron componentes.'
  status = 1
ensure
  begin
    session&.quit
  rescue StandardError => error
    warn "No se pudo cerrar la sesión: #{error.class}: #{error.message}"
    status = 2
  end
end
exit status
