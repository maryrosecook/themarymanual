# basic config
class Property
  include DataMapper::Resource

  property :id,         Serial
  property :identifier, String, :length => 300
  property :value,  	  String, :length => 300

  validates_present :identifier
  
  def self.set_(identifier, value)
    property = self.create("identifier" => identifier, "value" => value)
    return property.save()
  end
  
  def self.get_(identifer)
    return self.first(:conditions => { :identifer => identifer })
  end
end
