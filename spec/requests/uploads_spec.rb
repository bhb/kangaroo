require File.join(File.dirname(__FILE__), '..', 'spec_helper.rb')

given "a upload exists" do
  Upload.all.destroy!
  request(resource(:uploads), :method => "POST", 
    :params => { :upload => { :id => nil }})
end

describe "resource(:uploads)" do
  describe "GET" do
    
    before(:each) do
      @response = request(resource(:uploads))
    end
    
    it "responds successfully" do
      @response.should be_successful
    end

    it "contains a list of uploads" do
      pending
      @response.should have_xpath("//ul")
    end
    
  end
  
  describe "GET", :given => "a upload exists" do
    before(:each) do
      @response = request(resource(:uploads))
    end
    
    it "has a list of uploads" do
      pending
      @response.should have_xpath("//ul/li")
    end
  end
  
  describe "a successful POST" do
    before(:each) do
      Upload.all.destroy!
      @response = request(resource(:uploads), :method => "POST", 
        :params => { :upload => { :id => nil }})
    end
    
    it "redirects to resource(:uploads)" do
      @response.should redirect_to(resource(Upload.first), :message => {:notice => "upload was successfully created"})
    end
    
  end
end

describe "resource(@upload)" do 
  describe "a successful DELETE", :given => "a upload exists" do
     before(:each) do
       @response = request(resource(Upload.first), :method => "DELETE")
     end

     it "should redirect to the index action" do
       @response.should redirect_to(resource(:uploads))
     end

   end
end

describe "resource(:uploads, :new)" do
  before(:each) do
    @response = request(resource(:uploads, :new))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@upload, :edit)", :given => "a upload exists" do
  before(:each) do
    @response = request(resource(Upload.first, :edit))
  end
  
  it "responds successfully" do
    @response.should be_successful
  end
end

describe "resource(@upload)", :given => "a upload exists" do
  
  describe "GET" do
    before(:each) do
      @response = request(resource(Upload.first))
    end
  
    it "responds successfully" do
      @response.should be_successful
    end
  end
  
  describe "PUT" do
    before(:each) do
      @upload = Upload.first
      @response = request(resource(@upload), :method => "PUT", 
        :params => { :upload => {:id => @upload.id} })
    end
  
    it "redirect to the article show action" do
      @response.should redirect_to(resource(@upload))
    end
  end
  
end

