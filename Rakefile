# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'
require 'bundler'
Bundler.setup
Bundler.require
require 'bubble-wrap/reactor'

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.
  app.name = 'Adv Dice'
  app.version = '0.1'
  app.identifier = 'com.plasticwater.adventuredice'
  app.interface_orientations = [:portrait]
  app.testflight.sdk = 'vendor/TestFlightSDK'
  app.testflight.api_token = '8b0e0efef73b56d54d855b5d9150cf91_MzQ2MDU1MjAxMi0wMy0wNiAxNzowOTo0MS41MDY4NTA'
  app.testflight.team_token = 'df1d9a7ea54333ddd6e72e9dbc9c566d_Njg5OTIyMDEyLTAzLTA3IDE0OjI3OjAzLjM5ODk0OA'  
  app.pixate.user = 'neil@plasticwater.com'
  app.pixate.key = 'GKTIM-1HG85-71O18-4EUJ3-SE0CF-VN7SS-2N8TE-3303R-BL2OK-A767N-V5G87-K8UE9-R1IGK-O0MQ5-J1HTR-1C'
  app.pixate.framework = 'vendor/PXEngine.framework'

  app.pods do
    pod 'MBProgressHUD'
  end
end
