require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a pouch exists" do
  Pouch.all.destroy!
  request(resource(:pouches), :method => "POST", 
    :params => { :pouch => { :id => nil }})
end

describe "resource(:pouches)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:pouches))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of pouches" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a pouch exists" do
    before(:each) do
      @response = request(resource(:pouches))
    end
    
    it "has a list of pouches" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Pouch.all.destroy!
      @response = request(resource(:pouches), :method => "POST", 
        :params => { :pouch => { :id => nil }})
    end
    
    it "redirects to resource(:pouches)" do
      @response.should redirect_to(resource(Pouch.first), :message => {:notice => "pouch was successfully created"})
    end
    
  end
end

describe "resource(@pouch)" do 
  describe "a successful DELETE", :given => "a pouch exists" do
     before(:each) do
       @response = request(resource(Pouch.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:pouches))
     end

   end
end

describe "resource(:pouches, :new)" do
  before(:each) do
    @response = request(resource(:pouches, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@pouch, :edit)", :given => "a pouch exists" do
  before(:each) do
    @response = request(resource(Pouch.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@pouch)", :given => "a pouch exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Pouch.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @pouch = Pouch.first
      @response = request(resource(@pouch), :method => "PUT", 
        :params => { :pouch => {:id => @pouch.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@pouch))
    end
  end
  
end

