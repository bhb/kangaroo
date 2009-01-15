class Pouches < Application
  provides :html, :zip
  
  def index
    @pouches = Pouch.all
    display @pouches
  end

  def show(id)
    @pouch = Pouch.get(id)
    raise NotFound unless @pouch
    render @pouch if request.params[:format]=='zip'
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
