require 'rubygems'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-aggregates'
require 'haml'

require 'sinatra' unless defined?(Sinatra)

configure do
  enable :sessions

  DataMapper.setup(:default, ENV['DATABASE_URL'] || "mysql://root@localhost/cookongrammar")
  
  set :views, "#{File.dirname(__FILE__)}/views"

  # load models
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/model")
  Dir.glob("#{File.dirname(__FILE__)}/model/*.rb") { |model| require File.basename(model, '.*') }
  #DataMapper.auto_upgrade!
  Properties = {"title" => "Title",
                "subtitle" => "Sub title",
                "coverimage" => "/images/blankcover.jpg",
                "exlibris" => "You."}
  Property.update_from_database(Properties)
end
