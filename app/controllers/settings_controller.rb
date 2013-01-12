class SettingsController < Formotion::FormController
  
  PERSIST_AS = :settings
  
  SETTINGS_HASH = {
      title: "Adventure Dice",
      persist_as: PERSIST_AS,
      sections: [{
        title: "Settings",
        rows: [{
          title: "Shake to Re-Roll",
          type: :switch,
          key: :shake,
          value: true
        }, {
          title: "Animate Results",
          type: :switch,
          key: :animate,
          value: false
        }]
      }, {
        title: "Help",
        rows: [{
          title: "Give Feedback",
          type: "submit"}]
        }]
    }
  
  def initController
    f = Formotion::Form.persist(SETTINGS_HASH)
    initWithForm(f)    
  end

  def viewDidLoad
    super
    #self.navigationController.tabBarItem = UITabBarItem.alloc.initWithTitle("Settings", image: UIImage.imageNamed("20-gear-2"), tag: 3)
  end
  
  def submit
    TestFlight.openFeedbackView
  end
  
end
