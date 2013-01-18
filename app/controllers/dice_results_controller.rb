class DiceResultsController < UIViewController
    include BW::KVO

  BUTTON_WIDTH=50
  BUTTON_HEIGHT = 50

  def initWithDice(selected_dice)
    self.initWithNibName(nil, bundle:nil)
    @results = selected_dice

    @buttons = {}

    self
  end

  def viewDidLoad
    self.title = "Roll Results"
    self.view.backgroundColor = UIColor.whiteColor
    @results.each_with_index{|d, index|
      #add_label d, index, @results.count
      create_button d, index
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
    UIView.animateWithDuration(0.5, animations:-> {
      view.backgroundColor = UIColor.yellowColor
    }, completion:-> finished {
      count = 0
      timer = BubbleWrap::Reactor.add_periodic_timer 0.05 do
        count = count + 1
        @results.each{|d| d.roll }
        (count < 30) || EM.cancel_timer(timer)
      end
      UIView.animateWithDuration(0.5, animations:-> {
        view.backgroundColor = UIColor.whiteColor
      }, completion:-> finished_again {})
    })
  end  

 
  def add_label(dice, left, top)
    label = UILabel.alloc.initWithFrame(CGRectZero)
    label.text = dice.to_s
    label.font = UIFont.systemFontOfSize(12)
    label.backgroundColor = UIColor.clearColor
    label.frame = [[left, top], [BUTTON_WIDTH, 15]]
    label.textAlignment = UITextAlignmentCenter
    self.view.addSubview(label)
  end
  

  def create_button(dice, index)
    #button_image = UIImage.imageNamed("orangeButton", resizableImageWithCapInsets: [18,18,18,18])
    button_gap = 25
    max_per_row = 4
    initial_gap = 25
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    #button.setBackgroundImage(button_image, forState: UIControlStateNormal)
    #button.backgroundColor = UIColor.clearColor
    label = dice.result.to_s
    button.setTitle(label, forState:UIControlStateNormal)
    #button.setTitleColor(UIColor.whiteColor, forState:UIControlStateNormal)
    #button.sizeToFit
    #button.tag = sides
    button.frame = [
      [initial_gap + (index%max_per_row)*(BUTTON_WIDTH + button_gap), (index/max_per_row) * (BUTTON_HEIGHT + button_gap) + initial_gap],
      [BUTTON_WIDTH, BUTTON_HEIGHT]
    ]
    #button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin
    #button.addTarget(self, action:"button_tapped:", forControlEvents:UIControlEventTouchUpInside)

    observe(dice, :result) do |old_value, new_value|
      button.setTitle dice.result.to_s, forState:UIControlStateNormal
    end
    add_label(dice, button.frame.origin.x, button.frame.origin.y + BUTTON_HEIGHT)
    self.view.addSubview(button)
    @buttons[button] = dice
  end

end

