source 'https://rubygems.org'

# Specify your gem's dependencies in sequel_paper_trail.gemspec
gemspec

gem 'sequel', '~> 5.5'

group :development do
  gem 'rake', '~> 13.0'
end

group :testing do
  gem 'codeclimate-test-reporter', '~> 0.4.7', require: nil
  gem 'coveralls_reborn', '~> 0.25.0', require: false
  gem 'pry', '~> 0.14'
  gem 'rspec', '~> 3.11.0'
  gem 'simplecov', '~> 0.21.0', platforms: :mri, require: false
  if RUBY_PLATFORM == 'java'
    gem 'jdbc-sqlite3', '~> 3.0'
  else
    gem 'sqlite3', '~> 1.5'
  end
end
