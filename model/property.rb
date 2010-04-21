# basic config
class Property
  include DataMapper::Resource

  property :id,         Serial
  property :identifier, String, :length => 300
  property :value,  	  String, :length => 300

  validates_present :identifier
  
  def self.set_p(identifier, value)
    property = Property.create("identifier" => identifier, "value" => value)
    return property.save()
  end
  
  def self.get_p(identifer)
    return Property.first(:conditions => { :identifier => identifer })
  end
end
