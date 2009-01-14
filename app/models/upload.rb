class Upload
  include DataMapper::Resource
  
  property :id, Serial
  property :zip_filename, String


end
