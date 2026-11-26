# frozen_string_literal: true

require 'capybara'
require 'selenium-webdriver'
require_relative 'settings'

module Framework
  module FreshSessionReset
    # Capybara 3.40.0's Chrome reset uses a CDP wildcard rejected by Chrome 158.
    # A fresh browser session also isolates cookies and storage across origins.
    def reset!
      quit
    end
  end

  class ChromeDriver < Capybara::Selenium::Driver
    private

    def specialize_driver
      super
      singleton_class.prepend(FreshSessionReset)
    end
  end

  module Browser
    module_function

    def cached_binary(component, executable)
      pattern = File.join(Dir.home, '.cache', 'selenium', component, 'win64', '*', executable)
      Dir.glob(pattern).select { |path| File.file?(path) }
         .sort_by { |path| Gem::Version.new(File.basename(File.dirname(path))) }.last
    end

    def on_path(executable)
      ENV.fetch('PATH', '').split(File::PATH_SEPARATOR)
         .map { |directory| File.join(directory, executable) }
         .find { |path| File.file?(path) }
    end

    def local_path(variable, candidates)
      path = ENV.key?(variable) ? ENV[variable] : candidates.compact.find { |item| File.file?(item) }
      unless path && File.file?(path) && File.executable?(path)
        raise ArgumentError, "#{variable}: no se encontró un ejecutable local. Indique una ruta existente; no se descargarán componentes."
      end
      File.expand_path(path)
    end

    def options(settings)
      installations = %w[PROGRAMFILES PROGRAMFILES(X86) LOCALAPPDATA].filter_map do |key|
        File.join(ENV[key], 'Google', 'Chrome', 'Application', 'chrome.exe') if ENV[key]
      end
      binary = local_path('CHROME_BINARY', [on_path('chrome.exe'), *installations,
                                          cached_binary('chrome', 'chrome.exe')])
      result = Selenium::WebDriver::Chrome::Options.new
      result.binary = binary
      result.add_argument('--headless=new') if settings.headless
      result
    end

    def service
      path = local_path('CHROMEDRIVER_PATH', [on_path('chromedriver.exe'),
                                            cached_binary('chromedriver', 'chromedriver.exe')])
      Selenium::WebDriver::Service.chrome(path: path)
    end

    def configure(settings = Settings.new)
      Capybara.app_host = settings.base_url
      Capybara.run_server = false
      Capybara.default_max_wait_time = settings.wait_time
      Capybara.register_driver(:framework_chrome) do |app|
        ChromeDriver.new(app, browser: :chrome,
                         options: options(settings), service: service)
      end
      Capybara.default_driver = :framework_chrome
      Capybara.javascript_driver = :framework_chrome
    end
  end
end
