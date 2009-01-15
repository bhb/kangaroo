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

  def create#(upload)
    pouch = Pouch.get(params[:pouch_id])
    params.keys.select{|x|x=~/^file\d+/}.each do |key|
      file_info = params[key]
      unless(file_info=="" || file_info==nil)
        tempfile = file_info[:tempfile]
        filename = file_info[:filename]
        upload = Upload.save_and_create(pouch.id,filename,tempfile)
        if(upload.save!)
          pouch.uploads << upload
          pouch.save!
          upload.save!
        else
          message[:error] = "One or more uploads failed"
        end
      end
    end
    redirect(url(:controller => 'pouches', :action => 'show', :id => pouch.id))
  end

  def save_files(params)
    params.keys.select{|x| x=~/^file\d+/}.each do |key|
      file_info = params[key]
      unless(file_info=="" || file_info==nil)
        File.copy(file_info[:tempfile].path,file_info[:filename])
      end
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
