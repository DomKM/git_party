class Repo < ActiveRecord::Base
  validates_presence_of :name, :owner
  has_many :to_dos, dependent: :destroy
end
