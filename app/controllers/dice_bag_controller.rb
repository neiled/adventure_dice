class DiceBagController < UIViewController
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
    button_width = 60
    button_gap = 10
    max_per_row = 3
    initial_gap = 30
    
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    label = "d"+sides.to_s
    button.setTitle(label, forState:UIControlStateNormal)
    button.sizeToFit
    button.tag = sides
    button.frame = [
      [initial_gap + (index%max_per_row)*(button_width + button_gap), (index/max_per_row) * (button.frame.size.height + button_gap) + initial_gap],
      [button_width, button.frame.size.height]
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
    bag_left = 90
    bag_height = 10
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.setTitle(new_dice.sides.to_s, forState:UIControlStateNormal)
    button.sizeToFit
    button.frame = [
      [bag_left, button.frame.size.height * (@selected_dice.count - 1 ) + bag_height],
      [button.frame.size.width, button.frame.size.height]
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
    @selected_dice.delete(sender)
    @selected_buttons.delete(sender)
    bag_left = 90
    bag_height = 10
    
    @selected_buttons.each_with_index do |button, index|
      button.frame = [
        [bag_left, button.frame.size.height * (index - 1 ) + bag_height],
        [button.frame.size.width, button.frame.size.height]
      ]      
    end
  end

  def roll_dice
    controller = DiceResultsController.alloc.initWithDice(@selected_dice.values)
    self.presentViewController(
      UINavigationController.alloc.initWithRootViewController(controller),
      animated:true,
      completion: lambda {})
  end
  
  def get_default_list
    [2,3,4,5,6,7,8,10,12,14,16,18,20,24,30,34,50,60,100]
  end
end
