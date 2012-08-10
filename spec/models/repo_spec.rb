require 'spec_helper'

describe Repo do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:owner) }
  it { should have_many(:to_dos).dependent(:destroy) }

  before :each do
    JSON.stub(:parse).and_return({:tree=>[{:type=>"blob", :path=>".gitignore", :mode=>"100644", :size=>1545, :url=>"https://api.github.com/repos/DomKM/git_party/git/blobs/81a8e31717a443b4ddb0eb6889ec50dbe7ee4cc1", :sha=>"81a8e31717a443b4ddb0eb6889ec50dbe7ee4cc1"}]})
    ##RestClient.stub!(:get).and_return("blah")
    ##Repo.any_instance.stub(:shas).and_return(['abc'])
    ##Repo.any_instance.stub(:find_content).and_return({"abc" =>"blah"})

    #my_trees = mock()
    ##my_response = { "tree" => [ { "type" => "blob" , "path" => "blah", "sha" => "12345" } ] }
    #my_trees.stub(:get).and_return(my_response)

    #my_git_data = mock()
    #my_git_data.stub(:trees).and_return(my_trees)

    #my_github_thingy = mock()
    #my_github_thingy.stub(:git_data).and_return(my_git_data)

    #Github.stub(:new).and_return(my_github_thingy)
  end

  context ".github" do
    before(:each) do
      @repo = Repo.new
      @repo.name = "git_party"
      @repo.owner = "domkm"
    end

    it "returns a hash of todos" do
      @repo.github.should be_instance_of Hash
    end
  end
end
