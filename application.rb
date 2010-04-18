require 'rubygems'
require 'sinatra'
require 'environment'

# setup

configure do
  set :views, "#{File.dirname(__FILE__)}/views"
end

error do
  e = request.env['sinatra.error']
  puts e.to_s
  puts e.backtrace.join('\n')
  'Application error'
end

helpers do
  # add your helpers here
end

# pages

get '/' do
  @title = SiteConfig.title
  haml :root
end

get "/contents" do
  @pages = Page.contents()
  haml :contents
end

get "/editmode:onoroff" do
  session["edit_mode"] = params[:onoroff] == "on" ? true : false
  redirect "/contents"
end

post "/page/create/:slug" do
  page = Page.create(params)
  page.save
  redirect "/page/#{page.slug}"
end

get "/page/create/:slug" do
  redirect "/page/edit/#{params[:slug]}" if Page.first(:conditions => { :slug => params[:slug] })
  
  @editing = true
  @page = Page.create()
  haml :page
end

post "/page/edit/:slug" do
  page = Page.first(:conditions => { :slug => params[:slug] })
  page.update(params)
  page.save
  redirect "/page/#{page.slug}"
end

get "/page/edit/:slug" do
  redirect "/page/create/#{params[:slug]}" if !Page.first(:conditions => { :slug => params[:slug] })
  
  @editing = true
  @page = Page.first(:conditions => { :slug => params[:slug] })
  haml :page
end

get "/page/:slug" do
  slug = params[:slug]
  @page = Page.first(:conditions => { :slug => slug })
  @can_edit = session["edit_mode"]
  if @can_edit
    @edit_link = @page ? "/page/edit/#{slug}" : "/page/create/#{slug}"
  end
  
  haml :page
end

get '/env' do
  ENV.inspect
end