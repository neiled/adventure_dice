class DiceBagController < UIViewController
  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTitle("Dice Bag", image: nil, tag: 1)
    @selected_dice = []
    self
  end

  def viewDidLoad
    self.view.backgroundColor = UIColor.whiteColor

    create_button(6, 0)
    create_button(10,1)
    create_roll_button
  end

  def create_roll_button
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    button.setTitle("Roll", forState:UIControlStateNormal)
    button.sizeToFit
    button.frame = [[70,270,], [button.frame.size.width, button.frame.size.height]]
    button.autoresizingMask =
      UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin
    button.addTarget(self,
      action:"roll_dice",
      forControlEvents:UIControlEventTouchUpInside)
    self.view.addSubview(button)
  end
  
  def create_button(sides, index)
    button_width = 60
    button = UIButton.buttonWithType(UIButtonTypeRoundedRect)
    label = "d"+sides.to_s
    button.setTitle(label, forState:UIControlStateNormal)
    button.sizeToFit
    button.tag = sides
    button.frame = [
      [30 + index*(button_width + 10), button.frame.size.height + 30],
      [button_width, button.frame.size.height]
    ]
    button.autoresizingMask =
      UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin
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
end
