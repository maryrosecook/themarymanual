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
  validates_length :title, :within => 1..300
  
  def self.page_number(in_page)
    page_number = "?"
    i = 2 # contents page is page 1
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
  
  def update_with(params)
    self.title = self.esc params[:title]
    self.body = self.esc params[:body]
  end
  
  def esc(str)
    str = str.gsub("\342\200\230", "'")
    str = str.gsub("\342\200\231", "'")
    str = str.gsub("\342\200\234", '"')
    str = str.gsub("\342\200\235", '"')
    str = str.gsub("\x91\x0D\x0A", "'")
    str = str.gsub("\x92\x0D\x0A", "'")
    str = str.gsub("\x91", "'")
    str = str.gsub("\x92", "'")

    return str
  end
  
  def set_slug
    base_slug = self.title.downcase.gsub(/\W/, "")
    slug_try = base_slug

    i = 1
    found = false
    while !found
      matching_page = Page.first(:conditions => {:slug => slug_try})
      if !matching_page || matching_page.id == self.id # no page w/ this slug or is this page
        found = true
        self.slug = slug_try
      else
        slug_try = base_slug + i.to_s
      end
      i += 1
    end
  end
  
  def self.contents
    return Page.all(:order => [ :created_at.asc ])
  end
  
  def formatted_body
    return Kramdown::Document.new(self.body).to_html
  end
end
