class DiceFavouriteController < UITableViewController
  def initWithNibName(name, bundle: bundle)
    super
    self.tabBarItem = UITabBarItem.alloc.initWithTitle("Favourites", image:nil, tag:2)

    self
  end

  def viewWillAppear(animated)
    tableView.reloadData
  end


  def tableView(tableView, numberOfRowsInSection:section)
    App.delegate.favourites.size
  end

  def tableView(tableView, cellForRowAtIndexPath:indexPath)
    UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier:nil).tap do |cell|
      cell.textLabel.text = App.delegate.favourites[indexPath.row].join(" ")
    end
  end

  def tableView(tableView, canEditRowAtIndexPath:indexPath)
    true
  end

  def tableView(tableView, commitEditingStyle:editingStyle, forRowAtIndexPath:indexPath)
    App.delegate.delete_favourite(indexPath.row)
    tableView.reloadData
  end

end
