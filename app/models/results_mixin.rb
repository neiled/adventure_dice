module EnableRollResults

  #was @selected_dice.values
  def roll_dice(dice)
    @dice_being_rolled = dice
    @results_controller = DiceResultsController.alloc.initWithDice(@dice_being_rolled)
    bar_button_close = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemDone, target: self, action:"close")
    bar_button_save = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemSave, target: self, action:"add_favorite")    
    @results_controller.navigationItem.rightBarButtonItem = bar_button_close
    @results_controller.navigationItem.leftBarButtonItem = bar_button_save
    self.presentViewController(
      UINavigationController.alloc.initWithRootViewController(@results_controller),
      animated:true,
      completion: lambda {})
  end

  def close
    @results_controller.dismissModalViewControllerAnimated(true)
  end
  
  def add_favorite
    current_favourites = Favourite.load
    current_favourites << Favourite.new({:dice => @dice_being_rolled})
    Favourite.save
  end

end
