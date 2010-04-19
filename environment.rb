require 'rubygems'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-aggregates'
require 'haml'
require 'ostruct'
require "digest/sha1"
require 'rack-flash'
require "sinatra-authentication"

require 'sinatra' unless defined?(Sinatra)

configure do
  SiteConfig = OpenStruct.new(
                 :title => 'The Mary Manual',
                 :author => 'maryrosecook',
                 :url_base => 'http://localhost:4567/'
               )

  # for sinatra-authentication
  use Rack::Session::Cookie, :secret => 'duiwbidubwdadbwawi8'
  use Rack::Flash
  
  DataMapper.setup(:default, ENV['DATABASE_URL'] || "mysql://root@localhost/themarymanual?encoding=utf8")

  # load models
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/model")
  Dir.glob("#{File.dirname(__FILE__)}/model/*.rb") { |model| require File.basename(model, '.*') }
end
