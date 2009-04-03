require 'rubygems'
require 'sinatra'

ROOT_DIR = File.expand_path(File.dirname(__FILE__))

Sinatra::Application.set(
  :app_file    => File.join(ROOT_DIR, 'run_me.rb'),
  :run         => false,
  :environment => :production
)

run Sinatra.application
