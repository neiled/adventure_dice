class DiceResultsController < UIViewController
  def initWithDice(selected_dice)
    self.initWithNibName(nil, bundle:nil)
    generate_results(selected_dice)

    self
  end

  def viewDidLoad
    self.title = "Roll Results"
    self.view.backgroundColor = UIColor.whiteColor
    @results.each {|d| p d}
  end

  def generate_results(dice)
    @results = dice.map { |d| Dice.new(d)}
  end
end
