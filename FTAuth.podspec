#
# Be sure to run `pod lib lint FTAuth.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'FTAuth'
  s.version          = '0.1.0'
  s.summary          = 'iOS SDK for FTAuth'

  s.description      = <<-DESC
Client-side library for the FTAuth server. Handles authentication and HTTP requests.
                       DESC

  s.homepage         = 'https://github.com/ftauth/sdk-ios'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dillon Nys' => 'dillon.andre.nys@gmail.com' }
  s.source           = { :git => 'https://github.com/ftauth/sdk-ios.git', :tag => s.version.to_s }

  s.platform = :ios
  s.ios.deployment_target = '11.0'
  s.swift_versions = ['5.0', '5.1', '5.2', '5.3']

  s.subspec 'Common' do |cs|
    cs.source_files = 'FTAuth/Classes/Common/**/*'
  end

  s.subspec 'Full' do |fs|
    fs.source_files = 'FTAuth/Classes/**/*'
    fs.vendored_frameworks = 'FTAuthInternal.framework'
  end

  s.test_spec 'Tests' do |test_spec|
    # Keychain access requires an app host
    test_spec.requires_app_host = true
    test_spec.source_files = 'FTAuth/Tests/**/*'
  end

  s.default_subspec = 'Full'
end
