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
  
  def to_s
    "d" + self.sides.to_s + modifier_string
  end
  
  def modifier_string
    if modifier > 0 
      "+" + modifier.to_s
    elsif modifier < 0
      "-" + modifier.abs.to_s
    else
      ""
    end
  end

end
