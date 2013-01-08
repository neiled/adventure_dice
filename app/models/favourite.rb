class Favourite
  include MotionModel::Model
  
  columns     :name => :string
  has_many    :dice

  #attr_accessor :dice
  #attr_accessor :name
end
