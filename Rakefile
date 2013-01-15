# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'
Bundler.require

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Adv Dice'
  app.version = '0.1'
  app.identifier = 'com.plasticwater.adventuredice'
  app.interface_orientations = [:portrait]
  app.testflight.sdk = 'vendor/TestFlightSDK'
  app.testflight.api_token = '8b0e0efef73b56d54d855b5d9150cf91_MzQ2MDU1MjAxMi0wMy0wNiAxNzowOTo0MS41MDY4NTA'
  app.testflight.team_token = 'df1d9a7ea54333ddd6e72e9dbc9c566d_Njg5OTIyMDEyLTAzLTA3IDE0OjI3OjAzLjM5ODk0OA'  

  app.pods do
    pod 'MBProgressHUD'
  end
end
