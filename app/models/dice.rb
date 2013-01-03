class Dice
  attr_accessor :sides
  attr_accessor :result

  def initialize(sides)
    self.sides = sides
    roll
    
    self
  end
  
  def roll
    self.result = Random.rand(sides)+1
  end

end
