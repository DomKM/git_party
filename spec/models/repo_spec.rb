require 'spec_helper'

describe Repo do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:owner) }
  it { should have_many(:to_dos).dependent(:destroy) }
end
