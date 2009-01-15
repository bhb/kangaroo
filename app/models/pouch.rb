class Pouch
  include DataMapper::Resource
  
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

end
