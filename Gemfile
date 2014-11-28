source 'http://rubygems.org'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.3'

gem 'spree', github: 'spree/spree', branch: '2-4-stable'
gem 'youtube_it', github: 'kylejginavan/youtube_it', branch: 'master'

gemspec

group :test do
  if RUBY_PLATFORM.downcase.include? "darwin"
    gem 'guard-rspec'
    gem 'rb-fsevent'
    gem 'growl'
  end
  gem 'coffee-rails'
end

#gem 'spree', '~> 1.3'