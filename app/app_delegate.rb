class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
    @window.makeKeyAndVisible
    dice_bag_controller = DiceBagController.alloc.initWithNibName(nil, bundle: nil)
    dice_favourites_controller = DiceFavouriteController.alloc.initWithNibName(nil, bundle: nil)

    settings_controller = SettingsController.alloc.init
    settings_navigation_controller = UINavigationController.alloc.initWithRootViewController(settings_controller)

    tab_controller = UITabBarController.alloc.initWithNibName(nil, bundle: nil)
    tab_controller.viewControllers = [dice_bag_controller, dice_favourites_controller, settings_navigation_controller]
    @window.rootViewController = tab_controller
    true
  end
  
end
