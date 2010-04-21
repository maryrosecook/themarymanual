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
  @logged_in = session["edit_mode"]
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
    session["edit_mode"] = true
  end
  redirect "/hidden_compartment"
end

# page

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
  @woo = "squeak"
  @page = Page.first(:conditions => { :slug => slug })
  @can_edit = session["edit_mode"]
  if @can_edit
    @edit_link = @page ? "/page/edit/#{slug}" : "/page/create/#{slug}"
  end
  
  haml :page
end