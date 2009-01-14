class Pouches < Application
  # provides :xml, :yaml, :js

  def index
    @pouches = Pouch.all
    display @pouches
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
    @pouch = Pouch.new(pouch)
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
