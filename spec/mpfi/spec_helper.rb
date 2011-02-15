begin
  require 'rspec'
rescue LoadError
  require 'rubygems' unless ENV['NO_RUBYGEMS']
  gem 'rspec'
  require 'rspec'
end

$:.unshift(File.dirname(__FILE__) + '/../lib')
require 'mpfr'
require 'mpfi'
require "#{File.dirname(File.expand_path(__FILE__))}/generate_number_module.rb"
