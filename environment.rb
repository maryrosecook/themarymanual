require 'rubygems'
require 'dm-core'
require 'dm-timestamps'
require 'dm-validations'
require 'dm-aggregates'
require 'haml'
require 'ostruct'

require 'sinatra' unless defined?(Sinatra)

DataMapper.setup(:default, {
  :adapter  => 'mysql',
  :host     => 'localhost',
  :username => 'root' ,
  :password => '',
  :database => 'themarymanual_development'})

configure do
  SiteConfig = OpenStruct.new(
                 :title => 'The Mary Manual',
                 :author => 'maryrosecook',
                 :url_base => 'http://localhost:4567/'
               )

  # load models
  $LOAD_PATH.unshift("#{File.dirname(__FILE__)}/model")
  Dir.glob("#{File.dirname(__FILE__)}/model/*.rb") { |model| require File.basename(model, '.*') }
end
