require 'spec_helper'

describe Repo do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:owner) }
  it { should have_many(:to_dos).dependent(:destroy) }

  before :each do
    RestClient.stub!(:get).and_return("blah")
    Repo.any_instance.stub(:shas).and_return(['abc'])
    Repo.any_instance.stub(:find_content).and_return({"abc" =>"blah"})

    my_trees = mock()
    my_response = { :tree => "asdfsadf" }
    my_trees.stub(:get).and_return(my_response)

    my_git_data = mock()
    my_git_data.stub(:trees).and_return(my_trees)

    my_github_thingy = mock()
    my_github_thingy.stub(:git_data).and_return(my_git_data)

    Github.stub(:new).and_return(my_github_thingy)
  end

  context ".from_github" do
    let(:repo) { Repo.new }

    it "parses repo name" do
      repo.from_github('something/whatever')
      repo.name.should == 'whatever'
    end

    it "parses owner name" do
      repo.from_github('something/whatever')
      repo.owner.should == "something"
    end

    it "returns an array of content" do
      a = repo.from_github('something/whatever')
      @todos.should == {}
    end

    it "returns a hash of 'todos'"

  end
end
