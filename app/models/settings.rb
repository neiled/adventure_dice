class Settings

  PERSIST_AS = :settings
  
  SETTINGS_HASH = {
      title: "Settings",
      persist_as: PERSIST_AS,
      sections: [{
        title: "Options",
        rows: [{
          title: "Shake to Re-Roll",
          type: :switch,
          key: :shake,
          value: true
        }, {
          title: "Animate Results",
          type: :switch,
          key: :animate,
          value: true
        }, {
          title: "Show Totals",
          type: :switch,
          key: :totals,
          value: false
        }]
      }, {
        title: "Help",
        rows: [{
          title: "Give Feedback",
          type: "submit"}]
        }]
    }

  def form
    Formotion::Form.persist(SETTINGS_HASH)
  end

  def setting(setting_name)
    form = Formotion::Form.new(SETTINGS_HASH)
    form.open
    form.render[setting_name]
  end
end
