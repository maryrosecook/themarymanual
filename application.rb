require 'rubygems'
require 'sinatra'
require 'environment'

# setup

error do
  e = request.env['sinatra.error']
  puts e.to_s
  puts e.backtrace.join('\n')
  'Application error'
end

get '/' do
  @no_page_header_or_footer = true
  @title = SiteConfig.title
  haml :root
end

# nav

get "/contents" do
  @pages = Page.contents()
  @can_edit = session["logged_in"]
  @page_number = 1
  haml :contents
end

get "/ex_libris" do
  @page_number = 2
  haml :ex_libris
end

# authentication

get "/hidden_compartment" do
  @page_number = "?"
  @password_set = Property.get_p("password")
  @logged_in = session["logged_in"]
  haml :hidden_compartment
end

post "/set_password" do
  if !Property.get_p("password") && params[:password] # can only set password if not already set
    Property.set_p "password", params[:password]
  end
  redirect "/hidden_compartment"
end

post "/login" do
  real_password = Property.get_p("password")
  if real_password.value == params[:password] # can only set password if not already set
    session["logged_in"] = true
  end
  redirect "/hidden_compartment"
end

# page edit

post "/page/create" do
  redirect "/hidden_compartment" if !session["logged_in"]
  
  page = Page.create(params)
  page.set_slug
  page.save
  redirect "/page/#{page.slug}"
end

get "/page/create" do
  redirect "/hidden_compartment" if !session["logged_in"]
  
  @editing = true
  @page = Page.create()
  haml :page
end

post "/page/edit/:slug" do
  redirect "/hidden_compartment" if !session["logged_in"]
  
  page = Page.first(:conditions => { :slug => params[:slug] })
  page.update(params)
  page.save
  redirect "/page/#{page.slug}"
end

get "/page/edit/:slug" do
  redirect "/hidden_compartment" if !session["logged_in"]
  redirect "/page/create" if !Page.first(:conditions => { :slug => params[:slug] })
  
  @can_delete = session["logged_in"]
  @editing = true
  @page = Page.first(:conditions => { :slug => params[:slug] })
  haml :page
end

get "/page/delete/:slug" do
  redirect "/hidden_compartment" if !session["logged_in"]
  page = Page.first(:conditions => { :slug => params[:slug] })
  if page
    page.destroy
  end
  
  redirect "/contents"
end

# page

get "/page/:slug" do
  slug = params[:slug]
  @woo = "squeak"
  @page = Page.first(:conditions => { :slug => slug })
  @can_edit = session["logged_in"]
  
  haml :page
end