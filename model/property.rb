# basic config
class Property
  include DataMapper::Resource
  
  property :id,         Serial
  property :identifier, String, :length => 300
  property :value,  	  String, :length => 300

  validates_present :identifier
  
  def self.set_p(identifier, value)
    property = Property.first(:conditions => { :identifier => identifier })
    property = Property.create() if !property
    property.identifier = identifier if !property.identifier
    property.value = value
    success = property.save()
    self.update_from_database(Properties)
    return success
  end
  
  def self.get_p(identifier)
    property = Property.first(:conditions => { :identifier => identifier })
    return property ? property.value : nil
  end
  
  # takes a hash and fills it with properties set in the db, overwriting any existing defaults
  def self.update_from_database(defaults)
    for db_property in Property.all
      defaults[db_property.identifier] = db_property.value
    end
    defaults[""] = ""
  end
end
