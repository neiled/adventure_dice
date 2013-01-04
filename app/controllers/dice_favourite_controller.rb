class DiceFavouriteController < UIViewController
  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTitle("Favourites", image:nil, tag:2)

    self
  end
end
