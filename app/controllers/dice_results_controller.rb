class DiceResultsController < UIViewController
    include BW::KVO

  def initWithDice(selected_dice)
    self.initWithNibName(nil, bundle:nil)
    @results = selected_dice

    self
  end

  def viewDidLoad
    self.title = "Roll Results"
    self.view.backgroundColor = UIColor.whiteColor
    @results.each_with_index{|d, index|
      add_label d, index
    }

    reroll_button = subview(
      UIButton.buttonWithType(UIButtonTypeRoundedRect),
      title: "Re-roll",
      top: 300, left: 90, width: 150, height: 50
    )
    reroll_button.addTarget(self,
                            action:"reroll_dice", forControlEvents:UIControlEventTouchUpInside)
    reroll_dice
    true
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
    @results.each{|d| d.roll }
    UIView.animateWithDuration(1.0, delay:0.0, options:UIViewAnimationOptionAutoreverse,
        animations:-> { view.backgroundColor = UIColor.yellowColor })
  end  

 
  def add_label(dice, index)
    label = UILabel.alloc.initWithFrame(CGRectZero)
    label.text = dice.to_s + " = " + dice.result.to_s
    label.font = UIFont.systemFontOfSize(20)
    label.sizeToFit
    label.frame =
      [[20,
      label.frame.size.height + 50 * index], [130, label.frame.size.height]]
    label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin
    self.view.addSubview(label)

    observe(dice, :result) do |old_value, new_value|
      label.text = dice.to_s + " = " + new_value.to_s
    end
  end
end
