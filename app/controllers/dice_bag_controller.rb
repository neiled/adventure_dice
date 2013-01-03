class DiceBagController < UIViewController
  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTitle("Dice Bag", image: nil, tag: 1)
    @selected_dice = []
    self
  end

  def viewDidLoad
    self.view.backgroundColor = UIColor.whiteColor

    get_default_list.each_with_index do |number, index|
      create_button(number, index)
    end
    #create_button(6, 0)
    #create_button(10,1)
    create_roll_button
  end

  def create_roll_button
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.setTitle("Roll", forState:UIControlStateNormal)
    button.sizeToFit
    button.frame = [[70,270], [button.frame.size.width, button.frame.size.height]]
    button.autoresizingMask =
      UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin
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
    @selected_dice << sender.tag
    p @selected_dice
  end

  def roll_dice
    controller = DiceResultsController.alloc.initWithDice(@selected_dice)
    self.presentViewController(
      UINavigationController.alloc.initWithRootViewController(controller),
      animated:true,
      completion: lambda {})
  end
  
  def get_default_list
    [2,3,4,5,6,7,8,10,12,14,16,18,20,24,30,34,50,60,100]
  end
end
