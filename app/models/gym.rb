class Gym < ActiveRecord::Base
  attr_accessible :name, :website

  has_many :users
end
