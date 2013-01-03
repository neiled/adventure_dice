class DiceResultsController < UIViewController
    include BW::KVO

  stylesheet :dice_results

  def initWithDice(selected_dice)
    self.initWithNibName(nil, bundle:nil)
    generate_results(selected_dice)

    self
  end

  layout :result do
    subview(UIButton.buttonWithType(UIButtonTypeRoundedRect), :result)
  end

  def viewDidLoad
    self.title = "Roll Results"
    self.view.backgroundColor = UIColor.whiteColor
    @results.each_with_index{|d, index|
      add_label d, index
    }
  end

  def generate_results(dice)
    @results = dice.map { |d| Dice.new(d)}
  end
  
  def add_label(dice, index)
    label = UILabel.alloc.initWithFrame(CGRectZero)
    label.text = "d" + dice.sides.to_s + " = " + dice.result.to_s
    label.sizeToFit
    label.center =
      [self.view.frame.size.width / 2,
      30 + 20 * index]
    label.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleTopMargin
    self.view.addSubview(label)

    observe(dice, :result) do |old_value, new_value|
      label.text = "d" + dice.sides.to_s + " = " + new_value.to_s
    end
  end
end
