#
# Be sure to run `pod lib lint EngagingChoice.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'EngagingChoice'
  s.version          = '0.1.4'
  s.summary          = 'ENGAGING CHOICE -- THE NEW PERSON-BASED PERFORMANCE PLATFORM FOR MARKETERS, PUBLISHERS AND CONTENT PROVIDERS'
  s.swift_version    = '4.0'
# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
The Engaging Choice Platform is a patented performance and personalization engine built for the App Economy. We don’t just show ads. We present offers and give users the power of choice, creating an entirely engaged interaction that benefits user, marketer and publisher.
                    DESC

  s.homepage         = 'https://github.com/gitforengaging/EngagingChoice'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'gitforengaging' => 'gitforengaging@gmail.com' }
  s.source           = { :git => 'https://github.com/gitforengaging/EngagingChoice.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'

  s.source_files = 'EngagingChoice/Classes/**/*'
  
  s.resource_bundles = {
      'EngagingChoice' => ['EngagingChoice/**/*.{storyboard,xib,xcassets,json,imageset,png,ttf}', 'EngagingChoice/Resources/**/*.{xcassets,json,imageset,png,ttf}']
  }
  # s.resource_bundles = {
  #   'EngagingChoice' => ['EngagingChoice/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'AVKit', 'CoreLocation'
  s.dependency 'Alamofire', '~> 4.7'
  s.dependency 'SDWebImage', '~> 4.0'
end
