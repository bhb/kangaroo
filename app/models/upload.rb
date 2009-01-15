class Upload
  include DataMapper::Resource
  
  belongs_to :pouch
  property :id, Serial
  property :filename, String

  def self.pouch_root
    "pouch"
  end

  def self.save_and_create(pouch_id,filename,tempfile)
    upload_path = path(pouch_id)
    unless(File.exists?(upload_path))
      FileUtils.mkdir_p(upload_path)
    end
    new_filename = File.join(upload_path,filename)
    File.copy(tempfile.path,new_filename)
    self.new(:filename => new_filename)
  end

  def self.path(pouch_id)
    File.join(Merb.root,pouch_root,pouch_id.to_s)
  end

  def display_filename
    self.filename.gsub(self.class.path(self.pouch.id),'')
  end

end
