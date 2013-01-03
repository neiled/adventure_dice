class Dice
  attr_accessor :sides
  attr_accessor :result
  attr_accessor :modifier

  def initialize(sides, modifier = 0)
    self.sides = sides
    self.modifier = modifier
    roll
    
    self
  end
  
  def roll
    self.result = Random.rand(sides) + 1 + modifier
  end

end
