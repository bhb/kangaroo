class Pouch
  include DataMapper::Resource
  
  has n, :uploads
  property :id, Serial
  property :name, String

  validates_is_unique :name

  def set_unique_name
    self.name = self.id
    unless self.valid?
      while !self.valid?
        self.name = rand_string
      end
      self.save
    end
  end

  def rand_string(len = 6)
    chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
    rand_str = ""
    1.upto(len) { |i| rand_str << chars[rand(chars.size-1)] }
    return rand_str
  end

  def to_zip
    bundle_filename = "#{Merb.root}/pouch/#{self.id}.zip"
    # check to see if the file exists already
    if File.file?(bundle_filename)
      return File.read(bundle_filename)
    end 
    
    # open or create the zip file
    Zip::ZipFile.open(bundle_filename, Zip::ZipFile::CREATE) {
      |zipfile|
      zipfile.add("README","#{Merb.root}/README")
      # collect the files
      self.uploads.collect {
        |file|
        # add file to archive
        zipfile.add( "#{file.path}", "#{file.path}")
      }
    }
    
    # set read permissions on the file
    File.chmod(0644, bundle_filename)
    
    return File.read(bundle_filename)
  end

end
