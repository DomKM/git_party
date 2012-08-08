require 'spec_helper'

describe Repo do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:owner) }
  it { should have_many(:to_dos).dependent(:destroy) }

  let(:repo) {
    Repo.new()
  }

  let(:tree) {
    Github.stub!(:get).and_return(File.read('./github_tree.txt'))
  }

  #let(:content) {
  #  RestClient.stub!(:get).and_return(File.read('./github_content.txt'))
  #}
  before :each do
    RestClient.stub!(:get).and_return('blah')
  end


  context ".from_github" do
    let(:repo) { Repo.new }

    it "parses the repo name" do
      repo.should_receive(:parse_repo_name).with('something')
      repo.from_github('something')
    end
  end
end
