#
#  Be sure to run `pod spec lint GoshDarnIt.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|
  s.name         = "GoshDarnIt"
  s.version      = "0.0.1"
  s.summary      = "Profanity Filter in Swift."
  s.homepage     = "https://github.com/ryanmaxwell/GoshDarnIt"
  s.license      = "MIT"
  s.author             = { "Ryan Maxwell" => "ryanm@xwell.nz" }
  s.ios.deployment_target = "9.0"
  s.tvos.deployment_target = "9.0"
  s.source       = { :git => "git@github.com:ryanmaxwell/GoshDarnIt.git" }
  s.source_files  = "Classes", "Classes/**/*.{h,m}"
  s.resources = "Resources/*"
  s.requires_arc = true
end
