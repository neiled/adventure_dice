class DiceBagController < UIViewController

  BAG_LEFT = 250
  BAG_HEIGHT = 30
  BUTTON_WIDTH=60

  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTitle("Dice Bag", image: nil, tag: 1)
    @selected_dice = {}
    @selected_buttons = []
    self
  end

  def viewDidLoad
    self.view.backgroundColor = UIColor.whiteColor

    get_default_list.each_with_index do |number, index|
      create_button(number, index)
    end

    create_roll_button
  end

  def create_roll_button
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.setTitle("Roll", forState:UIControlStateNormal)
    button.sizeToFit
    button.frame = [[110,380], [button.frame.size.width, button.frame.size.height]]
    button.autoresizingMask =UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin
    button.addTarget(self,
      action:"roll_dice",
      forControlEvents:UIControlEventTouchUpInside)
    self.view.addSubview(button)
  end
  
  def create_button(sides, index)
    button_gap = 10
    max_per_row = 3
    initial_gap = 30
    
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    label = "d"+sides.to_s
    button.setTitle(label, forState:UIControlStateNormal)
    button.sizeToFit
    button.tag = sides
    button.frame = [
      [initial_gap + (index%max_per_row)*(BUTTON_WIDTH + button_gap), (index/max_per_row) * (button.frame.size.height + button_gap) + initial_gap],
      [BUTTON_WIDTH, button.frame.size.height]
    ]
    button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin
    button.addTarget(self,
      action:"button_tapped:",
      forControlEvents:UIControlEventTouchUpInside)
    self.view.addSubview(button)
  end

  def button_tapped(sender)
    new_dice = Dice.new(sender.tag)
    update_bag(new_dice)
  end
  
  def update_bag(new_dice)
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.setTitle("d"+new_dice.sides.to_s, forState:UIControlStateNormal)
    button.sizeToFit
    button.frame = [
      [BAG_LEFT, button.frame.size.height * (@selected_dice.count ) + BAG_HEIGHT],
      [BUTTON_WIDTH, button.frame.size.height]
    ]
    button.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin    
    button.addTarget(self,
      action:"remove_button:",
      forControlEvents:UIControlEventTouchUpInside)
    @selected_dice[button] = new_dice
    @selected_buttons << button
    self.view.addSubview(button)    
  end
  
  def remove_button(sender)
    sender.removeFromSuperview
    @selected_dice.delete(sender)
    @selected_buttons.delete(sender)
    
    @selected_buttons.each_with_index do |button, index|
      button.frame = [
        [BAG_LEFT, button.frame.size.height * index + BAG_HEIGHT],
        [button.frame.size.width, button.frame.size.height]
      ]      
    end
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
  
  def get_default_list
    [2,3,4,5,6,7,8,10,12,14,16,18,20,24,30,34,50,60,100]
  end
end
