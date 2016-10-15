ENV['RACK_ENV'] = 'test'
require 'rspec'
require 'rack/test'
require 'factory_girl'
require 'faker'
require 'database_cleaner'
require 'capybara/rspec'
require 'timecop'
require_relative '../app'
require 'rake'
load File.expand_path('../../lib/tasks/out_of_date.rake', __FILE__)
Rake::Task.define_task(:environment)

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.include FactoryGirl::Syntax::Methods

  config.before(:suite) do
    FactoryGirl.find_definitions
  end

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.around(:each) do |example|
    DatabaseCleaner.cleaning do
      example.run
    end
  end

  config.after do
    DatabaseCleaner.clean
  end
end

def app
  Sinatra::Application
end

Capybara.app = Sinatra::Application