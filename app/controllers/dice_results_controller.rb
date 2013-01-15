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
      add_label d, index, @results.count
    }

    reroll_button = subview(
      UIButton.buttonWithType(UIButtonTypeRoundedRect),
      title: "Re-roll",
      top: 350, left: 90, width: 150, height: 50
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
    unobserve_all
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
    UIView.animateWithDuration(0.5, animations:-> {
      view.backgroundColor = UIColor.yellowColor
    }, completion:-> finished {
      UIView.animateWithDuration(0.5, animations:-> {
        view.backgroundColor = UIColor.whiteColor
      }, completion:-> finished_again {})
    })
  end  

 
  def add_label(dice, index, total)
    height = (App.frame.size.height - 120) / total
    label = UILabel.alloc.initWithFrame(CGRectZero)
    label.text = dice.to_s + " = " + dice.result.to_s
    points_per_pixel = label.font.pointSize / label.text.sizeWithFont(label.font).height 
    label.font = UIFont.systemFontOfSize(height*points_per_pixel)
    label.backgroundColor = UIColor.clearColor
    label.frame =
      [[0,
      height * index], [App.frame.size.width, height]]
    label.adjustsFontSizeToFitWidth = true
    self.view.addSubview(label)

    observe(dice, :result) do |old_value, new_value|
      label.text = dice.to_s + " = " + new_value.to_s
    end

  end
end
