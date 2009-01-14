class Uploads < Application
  # provides :xml, :yaml, :js

  def index
    @uploads = Upload.all
    display @uploads
  end

  def show(id)
    @upload = Upload.get(id)
    raise NotFound unless @upload
    display @upload
  end

  def new
    only_provides :html
    @upload = Upload.new
    display @upload
  end

  def edit(id)
    only_provides :html
    @upload = Upload.get(id)
    raise NotFound unless @upload
    display @upload
  end

  def create(upload)
    @upload = Upload.new(upload)
    if @upload.save
      redirect resource(@upload), :message => {:notice => "Upload was successfully created"}
    else
      message[:error] = "Upload failed to be created"
      render :new
    end
  end

  def update(id, upload)
    @upload = Upload.get(id)
    raise NotFound unless @upload
    if @upload.update_attributes(upload)
       redirect resource(@upload)
    else
      display @upload, :edit
    end
  end

  def destroy(id)
    @upload = Upload.get(id)
    raise NotFound unless @upload
    if @upload.destroy
      redirect resource(:uploads)
    else
      raise InternalServerError
    end
  end

end # Uploads
