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
    self.view.styleId = "results_view"
    @results.each_with_index{|d, index|
      create_button d, index
    }

    @reroll_button = subview(
      UIButton.buttonWithType(UIButtonTypeRoundedRect),
      title: "Re-roll",
      top: 350, left: 90, width: 150, height: 50
    )
    @reroll_button.addTarget(self, action:"reroll_dice", forControlEvents:UIControlEventTouchUpInside)
    @reroll_button.styleClass = "button reroll_button"
    @reroll_button.translatesAutoresizingMaskIntoConstraints = false
    add_constraints
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
    if @shaking and Settings.new.setting(:shake)
      reroll_dice
    end
  end
  
  def reroll_dice
    if Settings.new.setting(:animate)
      UIView.animateWithDuration(0.5, animations:-> {
      }, completion:-> finished {
        count = 0
        timer = BubbleWrap::Reactor.add_periodic_timer 0.05 do
          count = count + 1
          @results.each{|d| d.roll }
          (count < 30) || EM.cancel_timer(timer)
        end
        UIView.animateWithDuration(0.5, animations:-> {
        }, completion:-> finished_again {})
      })
    else
      @results.each{|d| d.roll }
    end
  end  

  def add_constraints
    views_dict = { "reroll_button" => @reroll_button}
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        "V:[reroll_button]-|",
        options: 0,
        metrics: nil,
        views: views_dict))
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|-[reroll_button]-|", 
        options: 0,
        metrics: nil,
        views: views_dict))
  end
 
  def add_label(dice, left, top)
    label = UILabel.alloc.initWithFrame(CGRectZero)
    label.text = dice.to_s
    label.styleClass = "result_label"
    label.frame = [[left, top], [BUTTON_WIDTH, 15]]
    self.view.addSubview(label)
  end
  

  def create_button(dice, index)
    button_gap = 25
    max_per_row = 4
    initial_gap = 25
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.styleClass = "button result_button"
    label = dice.result.to_s
    button.setTitle(label, forState:UIControlStateNormal)
    button.frame = [
      [initial_gap + (index%max_per_row)*(BUTTON_WIDTH + button_gap), (index/max_per_row) * (BUTTON_HEIGHT + button_gap) + initial_gap], [BUTTON_WIDTH, BUTTON_HEIGHT] ]
    observe(dice, :result) do |old_value, new_value|
      button.setTitle dice.result.to_s, forState:UIControlStateNormal
    end
    button.addTarget(self, action:"reroll_one_dice:", forControlEvents:UIControlEventTouchUpInside)
    add_label(dice, button.frame.origin.x, button.frame.origin.y + BUTTON_HEIGHT)
    self.view.addSubview(button)
    @buttons[button] = dice
  end

  def reroll_one_dice(sender)
    @buttons[sender].roll
  end

end

