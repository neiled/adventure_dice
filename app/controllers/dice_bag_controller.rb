class DiceBagController < UIViewController
    include BW::KVO
    include EnableRollResults

  BAG_LEFT = 250
  BAG_HEIGHT = 30
  BAG_WIDTH = 65
  BUTTON_WIDTH=55
  BUTTON_HEIGHT = 50

  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTitle("Dice Bag", image: UIImage.imageNamed("130-dice"), tag: 1)
    @selected_dice = {}
    @selected_buttons = []
    @buttons = []
    self
  end

  def viewDidLoad
    image = UIImage.imageNamed("retina_wood")
    self.view.backgroundColor = UIColor.colorWithPatternImage(image)

    add_modifier_bar

    get_default_list.each_with_index do |number, index|
      create_button(number, index)
    end

    create_roll_button
    add_bag_view

    add_constraints
  end

  def add_modifier_bar

    @slider = UISlider.alloc.initWithFrame([[20,370],[200, 50]])
    @slider.translatesAutoresizingMaskIntoConstraints = false
    @slider.minimumValue = -10
    @slider.maximumValue = 10
    @slider.value = 0
    @slider.addTarget(self, action:"update_button_labels:",
      forControlEvents:UIControlEventValueChanged)

    @modifier_label = UILabel.alloc.initWithFrame(CGRectZero)
    @modifier_label.text = "Modfier:"
    @modifier_label.styleId = "modifier_label"
    @modifier_label.frame = [[20, 350], [200, 25]]
    @modifier_label.translatesAutoresizingMaskIntoConstraints = false
    self.view.addSubview(@modifier_label)

    self.view.addSubview(@slider)
  end

  def add_constraints
    views_dict = { "modifier_bar" => @slider, "roll_button" => @roll_button, "modifier_label" => @modifier_label, "bag_view" => @bag_view}
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        "V:[modifier_label]-0-[modifier_bar]-|",
        options: 0,
        metrics: nil,
        views: views_dict))
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|-[modifier_bar(>=200)]-[roll_button(#{BUTTON_WIDTH})]-10-|", 
        options: 0,
        metrics: nil,
        views: views_dict))
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|-[modifier_label]", 
        options: 0,
        metrics: nil,
        views: views_dict))
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        "V:|-15-[bag_view]-0-[roll_button(#{BUTTON_HEIGHT})]-|",
        options: 0,
        metrics: nil,
        views: views_dict))
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        "H:[bag_view(#{BAG_WIDTH})]-0-|",
        options: 0,
        metrics: nil,
        views: views_dict))
  end

  def add_bag_view
    @bag_view = UIScrollView.alloc.init
    @bag_view.frame = [[BAG_LEFT, 0], [BAG_WIDTH, self.view.frame.size.height-130]]
    @bag_view.contentSize.width = BAG_WIDTH
    @bag_view.canCancelContentTouches = true
    @bag_view.translatesAutoresizingMaskIntoConstraints = false
    @bag_view.delegate = self
    self.view.addSubview(@bag_view)

    @l = CAGradientLayer.layer
    @l.bounds = @bag_view.bounds
    @l.locations = [0.8, 1.0]
    @l.colors = [UIColor.whiteColor.CGColor, UIColor.clearColor.CGColor]
    @l.anchorPoint = [0,0]
    @bag_view.layer.mask = @l
  end

  def scrollViewDidScroll(sender)
    CATransaction.begin
    CATransaction.setDisableActions true
    @l.position = [0, @bag_view.contentOffset.y]
    CATransaction.commit
  end

  def create_roll_button
    @roll_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @roll_button.setTitle("Roll", forState:UIControlStateNormal)
    @roll_button.frame = [[250,400], [BUTTON_WIDTH, BUTTON_HEIGHT]]
    @roll_button.addTarget(self, action:"roll_button_pressed", forControlEvents:UIControlEventTouchUpInside)
    @roll_button.setEnabled(false)
    @roll_button.translatesAutoresizingMaskIntoConstraints = false
    @roll_button.styleClass = "button roll_button"
    self.view.addSubview(@roll_button)
  end

  def update_button_labels(slider)
    @buttons.each { |button|
      value_rounded = slider.value.round
      modifier_string = value_rounded < 0 ? value_rounded.to_s : "+" + value_rounded.to_s
      label = "d" + button.tag.to_s + (value_rounded == 0 ? "" : modifier_string)
      button.setTitle(label, forState:UIControlStateNormal)
    }
  end

  def create_button(sides, index)
    button_gap_v = Device.retina? ? 20 : 5
    max_per_row = 3
    initial_gap = 15
    button_gap_h = 20
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    label = "d"+sides.to_s
    button.setTitle(label, forState:UIControlStateNormal)
    button.tag = sides
    button.styleClass = "button dice_button"
    button.frame = [
      [initial_gap + (index%max_per_row)*(BUTTON_WIDTH + button_gap_h), (index/max_per_row) * (BUTTON_HEIGHT + button_gap_v) + initial_gap],
      [BUTTON_WIDTH, BUTTON_HEIGHT]
    ]
    button.addTarget(self, action:"button_tapped:", forControlEvents:UIControlEventTouchUpInside)

    self.view.addSubview(button)
    @buttons << button
  end

  def button_tapped(sender)
    unless @selected_dice.size >= 16 then
        new_dice = Dice.new({sides: sender.tag, modifier: @slider.value.round})
        update_bag(new_dice)
    end
  end
  
  def update_bag(new_dice)
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.setTitle(new_dice.to_s, forState:UIControlStateNormal)
    button.styleClass = "button chosen_dice"
    button.frame = [
      [0, (@selected_dice.count )  * BUTTON_HEIGHT],
      [BUTTON_WIDTH, BUTTON_HEIGHT]
    ]
    button.addTarget(self, action:"remove_button:", forControlEvents:UIControlEventTouchUpInside)
    @selected_dice[button] = new_dice
    @selected_buttons << button

    @bag_view.addSubview(button)  
    set_scroll_content_size
    @roll_button.setEnabled(true)
  end
  
  def remove_button(sender)
    sender.removeFromSuperview
    @selected_dice.delete(sender)
    @selected_buttons.delete(sender)
    
    UIView.animateWithDuration(0.5, animations:-> {
      @selected_buttons.each_with_index do |button, index|
        button.frame = [
          [0, BUTTON_HEIGHT * index],
          [BUTTON_WIDTH, BUTTON_HEIGHT]
        ]
      end
    })


    set_scroll_content_size
    @roll_button.setEnabled(false) unless @selected_buttons.count > 0
  end

  def roll_button_pressed
    roll_dice @selected_dice.values
  end

  def set_scroll_content_size
    @bag_view.contentSize = [BAG_WIDTH, BUTTON_HEIGHT * (@selected_buttons.count ) + (BAG_HEIGHT * 2) ]
  end
  
  def get_default_list
    [2,3,4,5,6,7,8,10,12,14,16,18,20,24,30,50,60,100]
  end
end
