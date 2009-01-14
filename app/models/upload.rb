class Upload
  include DataMapper::Resource
  
  property :id, Serial
  property :filename, String


end
