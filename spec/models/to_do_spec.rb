require 'spec_helper'

describe ToDo do
  it {should validate_presence_of(:path) }
  it {should validate_presence_of(:repo) }
  it {should validate_presence_of(:sha) }
  it {should belong_to(:repo)}
end
