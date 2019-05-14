#
# Be sure to run `pod lib lint RxSwiftExtensions.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = 'RxSwiftExtensions'
s.version          = '0.2.1'
s.summary          = 'Extension for rxswift.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

s.description      = <<-DESC
TODO: Add long description of the pod here.
DESC

s.homepage         = 'https://github.com/anddygon/RxSwiftExtensions'
# s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'anddygon' => 'anddygon@gmail.com' }
s.source           = { :git => 'https://github.com/anddygon/RxSwiftExtensions.git', :tag => s.version.to_s }
# s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

s.requires_arc          = true

s.ios.deployment_target = '9.0'

s.source_files = 'Classes/**/*'

# s.resource_bundles = {
#   'RxSwiftExtensions' => ['RxSwiftExtensions/Assets/*.png']
# }

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
 s.dependency 'RxSwift', '~> 5.0.0'
 s.dependency 'RxCocoa', '~> 5.0.0'
 s.dependency 'RxOptional', '~> 4.0.0'
 s.dependency 'RxDataSources', '~> 4.0.0'

s.swift_version = '5.0'

end
