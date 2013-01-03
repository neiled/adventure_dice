class DiceResultsController < UIViewController
    include BW::KVO

  stylesheet :dice_results

  def initWithDice(selected_dice)
    self.initWithNibName(nil, bundle:nil)
    @results = selected_dice

    self
  end

  layout :result do
    subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :result)
  end

  def viewDidLoad
    self.title = "Roll Results"
    self.view.backgroundColor = UIColor.whiteColor
    @results.each_with_index{|d, index|
      add_label d, index
    }
  end
  
  attr_accessor :shaking
  def shaking?
    @shaking
  end

  def viewWillAppear(animated)
    super
    becomeFirstResponder
  end

  def viewDidDisappear(animated)
    super
    resignFirstResponder
  end

  def canBecomeFirstResponder
    true
  end

  def motionEnded(motion, withEvent:event)
    @shaking = motion == UIEventSubtypeMotionShake
    reroll_dice
  end
  
  def reroll_dice
    p "Re-roll the dice here"
  end  

 
  def add_label(dice, index)
    label = UILabel.alloc.initWithFrame(CGRectZero)
    label.text = "d" + dice.sides.to_s + " = " + dice.result.to_s
    label.sizeToFit
    label.center =
      [self.view.frame.size.width / 2,
      30 + 20 * index]
    label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin
    self.view.addSubview(label)

    observe(dice, :result) do |old_value, new_value|
      label.text = "d" + dice.sides.to_s + " = " + new_value.to_s
    end
  end
end
