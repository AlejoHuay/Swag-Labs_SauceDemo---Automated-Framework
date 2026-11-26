# frozen_string_literal: true

# Cucumber executes After hooks in reverse registration order: evidence precedes
# the reset registered by capybara/cucumber. Its Selenium driver owns exit cleanup.
Before do
  Capybara::Screenshot.final_session_name = nil
  Thread.current[:capybara_screenshot_offending_window] = nil
end

After do |scenario|
  next unless scenario.failed?

  begin
    Capybara.using_session(Capybara::Screenshot.final_session_name) do
      # Capybara 3.40.0 has no public browser_initialized? predicate.
      # Inspect without invoking #browser, which would create a new session.
      next unless page.driver.instance_variable_get(:@browser)

      saver = Capybara::Screenshot.new_saver(Capybara, page, false, 'failure')
      # Saver#save skips pages with an empty current_path, including about:blank.
      saver.save_screenshot
      if saver.screenshot_saved? && File.file?(saver.screenshot_path)
        attach(File.binread(saver.screenshot_path), 'image/png', 'Failure screenshot')
        warn "Evidencia: #{saver.screenshot_path}"
      end
    end
  rescue StandardError => error
    warn "No se pudo capturar o adjuntar evidencia: #{error.class}: #{error.message}"
  ensure
    Thread.current[:capybara_screenshot_offending_window] = nil
  end
end
