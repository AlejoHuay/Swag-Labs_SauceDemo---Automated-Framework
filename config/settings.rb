# frozen_string_literal: true

require 'uri'

module Framework
  class Settings
    attr_reader :base_url, :headless, :wait_time

    def initialize(env = ENV)
      @base_url = env.fetch('BASE_URL', 'https://www.saucedemo.com')
      begin
        uri = URI.parse(@base_url)
        valid = uri.is_a?(URI::HTTP) && uri.host && !uri.host.empty? &&
                !uri.userinfo && !uri.fragment && !uri.query
        raise URI::InvalidURIError unless valid
      rescue URI::InvalidURIError
        raise ArgumentError, 'BASE_URL debe ser una URL http/https con host, sin credenciales, query ni fragmento.'
      end

      value = env.fetch('HEADLESS', 'false').downcase
      unless %w[true false].include?(value)
        raise ArgumentError, 'HEADLESS debe ser true o false.'
      end
      @headless = value == 'true'
      begin
        @wait_time = Float(env.fetch('WAIT_TIME', '10'))
        raise ArgumentError unless @wait_time.finite? && @wait_time.positive?
      rescue ArgumentError, TypeError
        raise ArgumentError, 'WAIT_TIME debe ser un número finito mayor que cero (segundos).'
      end
      freeze
    end
  end
end
