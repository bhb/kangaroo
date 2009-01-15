class Pouch
  include DataMapper::Resource
  
  has n, :uploads
  property :id, Serial
  property :name, String


end
