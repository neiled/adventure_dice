class DiceFavouriteController < UITableViewController
  include EnableRollResults
  
  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTitle("Favourites", image:nil, tag:2)

    self
  end

  def viewWillAppear(animated)
    @favourites = Favourite.load
    tableView.reloadData
  end


  def tableView(tableView, numberOfRowsInSection:section)
    @favourites.size
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:nil).tap do |cell|
      cell.textLabel.text = @favourites[indexPath.row].dice.join(" ")
    end
  end

  def tableView(tableView, canEditRowAtIndexPath:indexPath)
    true
  end

  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    @favourites.delete_at(indexPath.row)
    Favourites.save(@favourites)
    #App.delegate.delete_favourite(indexPath.row)
    tableView.reloadData
  end
  
  def tableView(tableView, didSelectRowAtIndexPath:indexPath)
    tableView.deselectRowAtIndexPath(indexPath, animated: true)
    favourite = @favourites[indexPath.row]
    roll_dice(favourite.dice, false)
  end

end
