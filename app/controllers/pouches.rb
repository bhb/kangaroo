class Pouches < Application
  provides :html, :zip
  
  def index
    @pouches = Pouch.all
    display @pouches
  end

  def to_zip(id)
    @pouch = Pouch.get(id)
    bundle_filename = "#{Merb.root}/pouch/#{id}.zip"
    
    # check to see if the file exists already
    if File.file?(bundle_filename)
      return bundle_filename
    end 
    
    # open or create the zip file
    Zip::ZipFile.open(bundle_filename, Zip::ZipFile::CREATE) {
      |zipfile|
      # collect the files
      @pouch.uploads.collect {
        |file|
        # add file to archive
        zipfile.add( "#{file.path}", "#{file.path}")
      }
    }
    
    # set read permissions on the file
    File.chmod(0644, bundle_filename)
    
    return bundle_filename
  end

  def show(id)
    @pouch = Pouch.get(id)
    raise NotFound unless @pouch
    display @pouch
  end

  def new
    only_provides :html
    @pouch = Pouch.new
    display @pouch
  end

  def edit(id)
    only_provides :html
    @pouch = Pouch.get(id)
    raise NotFound unless @pouch
    display @pouch
  end

  def create(pouch)
    if pouch['name']==''
      @pouch = Pouch.create(pouch)
      @pouch.set_unique_name
    else
      @pouch = Pouch.new(pouch)
    end
    if @pouch.save
      redirect resource(@pouch), :message => {:notice => "Pouch was successfully created"}
    else
      message[:error] = "Pouch failed to be created"
      render :new
    end
  end

  def update(id, pouch)
    @pouch = Pouch.get(id)
    raise NotFound unless @pouch
    if @pouch.update_attributes(pouch)
       redirect resource(@pouch)
    else
      display @pouch, :edit
    end
  end

  def destroy(id)
    @pouch = Pouch.get(id)
    raise NotFound unless @pouch
    if @pouch.destroy
      redirect resource(:pouches)
    else
      raise InternalServerError
    end
  end

end # Pouches
