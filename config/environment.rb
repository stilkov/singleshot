# Be sure to restart your web server when you modify this file.

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')
require 'activesupport'
require 'socket'

Rails::Initializer.run do |config|
  # Settings in config/environments/* take precedence over those specified here.
  # Application configuration should go into files in config/initializers
  # -- all .rb files in that directory are automatically loaded.

  # Add additional load paths for your own custom dirs
  # config.load_paths += %W( #{RAILS_ROOT}/extras )

  # Specify gems that this application depends on and have them installed with rake gems:install
  if RUBY_PLATFORM[/java/]
    config.gem 'activerecord-jdbcmysql-adapter',  :version=>'~>0.9', :lib=>false
    config.gem 'jruby-openssl',                   :version=>'0.4', :lib=>false
  elsif RUBY_VERSION >= '1.9.0'
    # TODO: find the MySQL gem that works with 1.9.1.
  else
    config.gem 'mysql', :version=>'~>2.7', :lib=>false
  end
  config.gem 'nokogiri',              :version=>'~>1.3.0' # a) faster, b) solves an encoding bug under Ruby 1.9
  config.gem 'mislav-will_paginate',  :version=>'2.3.11', :lib=>'will_paginate'
  config.gem 'liquid',                :version=>'2.0'

  # Only load the plugins named here, in the order given (default is alphabetical).
  # :all can be used as a placeholder for all plugins not explicitly named
  # config.plugins = [ :exception_notification, :ssl_requirement, :all ]
  config.plugins = [ 'presenter', 'exception_notification' ]
  config.plugins.push 'rack-bug' unless RAILS_ENV == 'production'

  # Skip frameworks you're not going to use. To use Rails without a database,
  # you must remove the Active Record framework.
  # config.frameworks -= [ :active_record, :active_resource, :action_mailer ]

  # Activate observers that should always be running
  # config.active_record.observers = :cacher, :garbage_collector, :forum_observer

  secret = File.read(Rails.root + 'secret.key') rescue ActiveSupport::SecureRandom.hex(64)
  config.action_controller.session = { :key => '_singleshot_session', :secret => secret }

  # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
  # Run "rake -D time" for a list of tasks for finding time zone names.
  config.time_zone = 'UTC'

  # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
  # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}')]
  # config.i18n.default_locale = :de


  config.action_controller.use_accept_header = true

  config.active_record.schema_format = :sql
  config.active_record.partial_updates = true

  config.active_record.observers = []

  # TODO: set this before going to production.
  config.action_mailer.default_url_options = { :host=> Socket.gethostname }
end
