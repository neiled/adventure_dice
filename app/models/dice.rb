
class Dice
  PROPERTIES = [:sides, :result, :modifier]
  PROPERTIES.each { |prop|
    attr_accessor prop
  }

  def initialize(attributes = {})
    attributes.each { |key, value|
      self.send("#{key}=", value) if PROPERTIES.member? key
    }
    self.modifier = 0 unless modifier
    self.sides = 6 unless sides
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

  def initWithCoder(decoder)
    self.init
    PROPERTIES.each { |prop|
      value = decoder.decodeObjectForKey(prop.to_s)
      self.send((prop.to_s + "=").to_s, value) if value
    }
    self
  end

  # called when saving an object to NSUserDefaults
  def encodeWithCoder(encoder)
    PROPERTIES.each { |prop|
      encoder.encodeObject(self.send(prop), forKey: prop.to_s)
    }
  end

end
