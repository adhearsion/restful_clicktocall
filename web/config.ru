require 'rubygems'
require 'bundler'

Bundler.require

ROOT_DIR = File.expand_path(File.dirname(__FILE__))

Sinatra::Application.set :run         => false,
                         :environment => :production

require './run_me'
run Sinatra::Application
