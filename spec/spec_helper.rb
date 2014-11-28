ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../dummy/config/environment", __FILE__)
require 'rspec/rails'
require 'factory_girl'
require 'ffaker'
require 'shoulda-matchers'
require 'database_cleaner'
require 'capybara/rspec'


# Requires factories defined in spree_core
require 'spree/testing_support/authorization_helpers'
require 'spree/testing_support/factories'
require 'spree/testing_support/preferences'
require 'spree/testing_support/controller_requests'
require 'spree/testing_support/flash'
require 'spree/testing_support/url_helpers'
require 'spree/testing_support/order_walkthrough'
require 'spree/testing_support/capybara_ext'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

# pull in factories
Dir["#{File.dirname(__FILE__)}/factories/**"].each {|f| require f}

require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist
options = {
  js_errors: false,
  timeout: 240,
  phantomjs_logger: StringIO.new,
  logger: nil,
  phantomjs_options: ['--load-images=no', '--ignore-ssl-errors=yes']
}

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, options)
end
Capybara.default_wait_time = 10
Capybara.default_host = 'localhost:3000'


RSpec.configure do |config|
  config.mock_with :rspec

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, comment the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # A workaround to deal with random failure caused by phantomjs. Turn it on
  # by setting ENV['RSPEC_RETRY_COUNT']. Limit it to features tests where
  # phantomjs is used.
  config.before(:all, :type => :feature) do
    if ENV['RSPEC_RETRY_COUNT']
      config.verbose_retry       = true # show retry status in spec process
      config.default_retry_count = ENV['RSPEC_RETRY_COUNT'].to_i
    end
  end

  config.before :suite do
    Capybara.match = :prefer_exact
    DatabaseCleaner.clean_with :truncation
  end

  config.before(:each) do
    Rails.cache.clear
    if RSpec.current_example.metadata[:js]
      DatabaseCleaner.strategy = :truncation
    else
      DatabaseCleaner.strategy = :transaction
    end
    # TODO: Find out why open_transactions ever gets below 0
    # See issue #3428
    if ActiveRecord::Base.connection.open_transactions < 0
      ActiveRecord::Base.connection.increment_open_transactions
    end

    DatabaseCleaner.start
    reset_spree_preferences
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end

  config.after(:each, type: :feature) do |example| 
    missing_translations = page.body.scan(/translation missing: #{I18n.locale}\.(.*?)[\s<\"&]/)
    if missing_translations.any?
      #binding.pry
      puts "Found missing translations: #{missing_translations.inspect}"
      puts "In spec: #{example.location}"
    end
    if ENV['LOCAL']  && example.exception
      save_and_open_page
      page.save_screenshot("tmp/capybara/screenshots/#{example.metadata[:description]}.png", full: true)
    end
  end


  config.include Spree::TestingSupport::Preferences
  config.include Spree::TestingSupport::UrlHelpers
  config.include Spree::TestingSupport::ControllerRequests
  config.include Spree::TestingSupport::Flash
  config.include FactoryGirl::Syntax::Methods
  # config.use_transactional_fixtures = true

  config.fail_fast = ENV['FAIL_FAST'] == 'true' || false

end

