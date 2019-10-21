#
# Be sure to run `pod lib lint TTCalendarPicker.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TTCalendarPicker'
  s.version          = '0.1.1'
  s.summary          = 'A lightweight, customizable, infinite scrolling calendar in Swift'
  s.description      = <<-DESC
A lightweight, highly customizable, infinite scrolling calendar picker developed by the iOS teams at Thumbtack, Inc.
                       DESC

  s.homepage         = 'https://github.com/Thumbtack/TTCalendarPicker'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'Apache 2', :file => 'LICENSE' }
  s.author           = { 'Daniel Roth' => 'droth@thumbtack.com' }
  s.source           = { :git => 'https://github.com/Thumbtack/TTCalendarPicker.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'

  s.swift_version    = '5'

  s.source_files = 'TTCalendarPicker/Classes/**/*'
  s.dependency 'SnapKit'
end
