class SettingsController < UIViewController
  
  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTitle("Settings", image: UIImage.imageNamed("20-gear-2"), tag: 3)
    self
  end
end
