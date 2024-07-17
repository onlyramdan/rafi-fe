require_relative "boot"
require 'csv'
require "rails/all"
require 'dotenv/load'


# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)


module ProjectFe
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0
    config.action_controller.default_protect_from_forgery = true

    # config.middleware.use Rack::NoCache


    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
    

    puts "=======================>>> LOAD API IoT"
    config.before_configuration do
      env_file = File.join(Rails.root, 'config', 'iot.yml')
      YAML.load(File.open(env_file)).each do |key, value|
          ENV[key.to_s] = value
      end if File.exist?(env_file) 
    end
  end
  
end
