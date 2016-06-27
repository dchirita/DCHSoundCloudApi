#
# Be sure to run `pod lib lint DCHSoundCloudApi.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "DCHSoundCloudApi"
  s.version          = "0.0.3"
  s.summary          = "DCHSoundCloudApi is a light wrapper for SoundCloud HTTP API"

  s.description      = <<-DESC
                          CocoaSoundCloudAPI is out of date and mantainence is no longer done. This project is supposed to replace it, but in a more mantainable manner, by adding functionality for real life use cases.
                       DESC

  s.homepage         = "https://github.com/dchirita/DCHSoundCloudApi"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Daniel Chirita" => "daniel.chirita@woowteam.com" }
  s.source           = { :git => "https://github.com/dchirita/DCHSoundCloudApi.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.tvos.deployment_target = '9.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'DCHSoundCloudApi' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Bolts'
  s.dependency 'AFNetworking'
  s.dependency 'CocoaLumberjack'
end
