require 'kramdown'

# a page of the manual
class Page
  include DataMapper::Resource

  property :id,         Serial
  property :title,      String, :length => 300
  property :slug,  	    String, :length => 300
  property :body,       Text
  property :created_at, DateTime
  property :updated_at, DateTime

  validates_present :slug, :title
  
  def self.page_number(in_page)
    page_number = "?"
    i = 1
    if in_page # actually on a page so find its num
      for page in Page.all(:order => [ :created_at.asc ])
        if in_page == page
          page_number = i
          break
        end
        
        i += 1
      end
    end
    
    return page_number
  end
  
  def formatted_body
    return Kramdown::Document.new(self.body).to_html
  end
end
