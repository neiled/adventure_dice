class DiceBagController < UIViewController
    include BW::KVO

  BAG_LEFT = 250
  BAG_HEIGHT = 30
  BUTTON_WIDTH=65
  BUTTON_HEIGHT = 44

  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTitle("Dice Bag", image: nil, tag: 1)
    @selected_dice = {}
    @selected_buttons = []
    @buttons = []
    self
  end

  def viewDidLoad
    image = UIImage.imageNamed("pool_table2")
    self.view.backgroundColor = UIColor.colorWithPatternImage(image)

    add_modifier_bar

    get_default_list.each_with_index do |number, index|
      create_button(number, index)
    end

    create_roll_button
    add_bag_view
  end

  def add_modifier_bar
    @slider = UISlider.alloc.init
    self.view.addSubview(@slider)
    @slider.frame = [[20,370],[200, @slider.frame.size.height]]
    @slider.minimumValue = -10
    @slider.maximumValue = 10
    @slider.value = 0
    @slider.addTarget(self, action:"update_button_labels:",
      forControlEvents:UIControlEventValueChanged)
  end
  
  def add_bag_view
    @bag_view = UIScrollView.alloc.init
    @bag_view.frame = [[BAG_LEFT, 0], [self.view.frame.size.width - BAG_LEFT, self.view.frame.size.height-130]]
    @bag_view.contentSize.width = BUTTON_WIDTH
    @bag_view.canCancelContentTouches = true
    self.view.addSubview(@bag_view)
  end

  def create_roll_button
    @roll_button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    @roll_button.setTitle("Roll", forState:UIControlStateNormal)
    @roll_button.sizeToFit
    @roll_button.frame = [[250,400], [BUTTON_WIDTH, @roll_button.frame.size.height]]
    @roll_button.autoresizingMask =UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin
    @roll_button.addTarget(self, action:"roll_dice",
      forControlEvents:UIControlEventTouchUpInside)
    @roll_button.setEnabled(false)
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
    new_dice = Dice.new(sender.tag, @slider.value.round)
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
    
    @selected_buttons.each_with_index do |button, index|
      button.frame = [
        [0, BUTTON_HEIGHT * index + 20],
        [button.frame.size.width, button.frame.size.height]
      ]
    end

    set_scroll_content_size
    @roll_button.setEnabled(false) unless @selected_buttons.count > 0
  end

  def roll_dice
    @results_controller = DiceResultsController.alloc.initWithDice(@selected_dice.values)
    bar_button = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemDone, target: self, action:"close")
    @results_controller.navigationItem.rightBarButtonItem = bar_button
    self.presentViewController(
      UINavigationController.alloc.initWithRootViewController(@results_controller),
      animated:true,
      completion: lambda {})
  end

  def close
    @results_controller.dismissModalViewControllerAnimated(true)
  end

  def set_scroll_content_size
    @bag_view.contentSize = [BUTTON_WIDTH, BUTTON_HEIGHT * (@selected_buttons.count ) + (BAG_HEIGHT * 2) ]
  end
  
  def get_default_list
    [2,3,4,5,6,7,8,10,12,14,16,18,20,24,30,50,60,100]
  end
end
