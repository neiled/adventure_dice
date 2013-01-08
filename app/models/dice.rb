class Dice
  include MotionModel::Model
  
  columns :sides => :int,
          :result => :int,
          :modifier => {:type => :int, :default => 0}

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
