class DiceBagController < UIViewController
    include BW::KVO
    include EnableRollResults

  BAG_LEFT = 250
  BAG_HEIGHT = 30
  BUTTON_WIDTH=65
  BUTTON_HEIGHT = 54

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
    #@slider.frame = [[20,370],[200, @slider.frame.size.height]]
    @slider.translatesAutoresizingMaskIntoConstraints = false
    @slider.minimumValue = -10
    @slider.maximumValue = 10
    @slider.value = 0
    @slider.addTarget(self, action:"update_button_labels:",
      forControlEvents:UIControlEventValueChanged)
    self.view.addSubview(@slider)
  end

  def add_constraints
    views_dict = { "modifier_bar" => @slider, "roll_button" => @roll_button}
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        "V:[modifier_bar]-|",
        options: 0,
        metrics: nil,
        views: views_dict))
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        "H:|-[modifier_bar(>=200)]-[roll_button(65)]-8-|", 
        options: 0,
        metrics: nil,
        views: views_dict))
    self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat(
        "V:[roll_button]-|",
        options: 0,
        metrics: nil,
        views: views_dict))
  end
  
  def add_bag_view
    @bag_view = UIScrollView.alloc.init
    @bag_view.frame = [[BAG_LEFT, 0], [self.view.frame.size.width - BAG_LEFT, self.view.frame.size.height-130]]
    @bag_view.contentSize.width = BUTTON_WIDTH
    @bag_view.canCancelContentTouches = true
    self.view.addSubview(@bag_view)
    
    l = CAGradientLayer.layer
    l.frame = @bag_view.bounds;
    l.colors = [UIColor.colorWithRed(0, green:0, blue:0, alpha:0).CGColor, UIColor.colorWithRed(0, green:0, blue:0, alpha:1).CGColor, nil]
    l.startPoint = [0, 0]
    l.endPoint = [1,1];

    @bag_view.layer.mask = l;     
  end

  def create_roll_button
    @roll_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @roll_button.setTitle("Roll", forState:UIControlStateNormal)
    @roll_button.sizeToFit
    @roll_button.frame = [[250,400], [BUTTON_WIDTH, @roll_button.frame.size.height]]
    @roll_button.addTarget(self, action:"roll_button_pressed",
      forControlEvents:UIControlEventTouchUpInside)
    @roll_button.setEnabled(false)
    @roll_button.translatesAutoresizingMaskIntoConstraints = false
    button_image = UIImage.imageNamed("greenButton", resizableImageWithCapInsets: [18,18,18,18])
    @roll_button.setBackgroundImage(button_image, forState: UIControlStateNormal)
    @roll_button.backgroundColor = UIColor.clearColor
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
    button_image = UIImage.imageNamed("orangeButton", resizableImageWithCapInsets: [18,18,18,18])
    button_gap = 15
    max_per_row = 3
    initial_gap = 15
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.setBackgroundImage(button_image, forState: UIControlStateNormal)
    button.backgroundColor = UIColor.clearColor
    label = "d"+sides.to_s
    button.setTitle(label, forState:UIControlStateNormal)
    button.setTitleColor(UIColor.whiteColor, forState:UIControlStateNormal)
    button.sizeToFit
    button.tag = sides
    button.frame = [
      [initial_gap + (index%max_per_row)*(BUTTON_WIDTH + button_gap), (index/max_per_row) * (button.frame.size.height + button_gap) + initial_gap],
      [BUTTON_WIDTH, BUTTON_HEIGHT]
    ]
    button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin
    button.addTarget(self, action:"button_tapped:",
      forControlEvents:UIControlEventTouchUpInside)

    self.view.addSubview(button)
    @buttons << button
  end

  def button_tapped(sender)
    new_dice = Dice.new({sides: sender.tag, modifier: @slider.value.round})
    update_bag(new_dice)
  end
  
  def update_bag(new_dice)
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.setTitle(new_dice.to_s, forState:UIControlStateNormal)
    button.sizeToFit
    button.frame = [
      [0, (@selected_dice.count )  * BUTTON_HEIGHT + 20],
      [BUTTON_WIDTH, BUTTON_HEIGHT]
    ]
    button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin    
    button.addTarget(self,
      action:"remove_button:",
      forControlEvents:UIControlEventTouchUpInside)
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
          [0, BUTTON_HEIGHT * index + 20],
          [button.frame.size.width, button.frame.size.height]
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
    @bag_view.contentSize = [BUTTON_WIDTH, BUTTON_HEIGHT * (@selected_buttons.count ) + (BAG_HEIGHT * 2) ]
  end
  
  def get_default_list
    [2,3,4,5,6,7,8,10,12,14,16,18,20,24,30,50,60,100]
  end
end
