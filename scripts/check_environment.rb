# frozen_string_literal: true

require 'rubygems'
require 'rbconfig'

expected = {
  'cucumber' => '9.2.1', 'capybara' => '3.40.0',
  'selenium-webdriver' => '4.26.0', 'selenium' => '0.2.11',
  'rspec' => '3.13.2', 'capybara-screenshot' => '1.0.27'
}.freeze
differences = []
checks = {
  'Ruby' => ['3.0.2', RUBY_VERSION],
  'Arquitectura Ruby' => ['x64-mingw32', RbConfig::CONFIG['arch']],
  'RubyGems' => ['3.2.22', Gem::VERSION]
}
checks.each do |name, (wanted, actual)|
  puts "#{name}: esperado=#{wanted}; observado=#{actual}"
  differences << name unless wanted == actual
end
expected.each do |name, version|
  installed = Gem::Specification.find_all_by_name(name).map { |spec| spec.version.to_s }
  puts "#{name}: esperado=#{version}; instalado=#{installed.empty? ? 'ausente' : installed.join(', ')}"
  differences << name unless installed.include?(version)
end
bundlers = Gem::Specification.find_all_by_name('bundler').map { |spec| spec.version.to_s }
puts "Bundler instalado: #{bundlers.empty? ? 'ausente' : bundlers.join(', ')}"
puts 'La resolución del proyecto se comprueba por separado con bundle check.'
differences << 'Bundler ausente' if bundlers.empty?
puts differences.empty? ? 'Entorno esperado disponible; navegador aún no comprobado.' : "Diferencias: #{differences.join(', ')}"
exit(differences.empty? ? 0 : 1)
