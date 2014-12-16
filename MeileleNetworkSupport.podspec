#
# Be sure to run `pod lib lint MeileleNetworkSupport.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MeileleNetworkSupport"
  s.version          = "0.3.3"
  s.platform         = :ios, '6.0'
  s.license          = 'MIT'
  s.summary          = "A delightful iOS networking framework with AFNetWorking "
  s.homepage         = "https://github.com/louis-cai/MeileleNetworkSupport"

  s.author           = { "louis cai" => "louis.cai.cn@gmail.com" }
  s.source           = { :svn => "svn://192.168.0.36/iOS/MeileleAPI/MeileleNetworkSupport-master/trunk"}


  s.frameworks       = 'Foundation', 'UIKit'
  s.requires_arc     = true

  s.default_subspec = 'Core'
  s.subspec 'Core' do |core|
    core.source_files = 'Pod/Classes/Core/*.{h,m}','Pod/Classes/MeileleNetworkSupport.h'
    core.dependency 'AFNetworking', '~> 2.4.1'
  end

  s.subspec 'RAC' do |rac|
    rac.source_files = 'Pod/Classes/RAC/*.{h,m}'
    rac.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) MNS_RAC=1' }
    rac.dependency 'MeileleNetworkSupport/Core'
    rac.dependency 'ReactiveCocoa', '~> 2.3.1'
    rac.dependency 'AFNetworking', '~> 2.4.1'
    rac.dependency 'AFNetworking-RACExtensions', '~> 0.1.4'
  end

  s.subspec 'Logger' do |log|
    log.source_files = 'Pod/Classes/Logger/*.{h,m}'
    log.xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) MNS_LOG=1' }
    log.dependency 'MeileleNetworkSupport/Core'
    log.dependency 'AFNetworking', '~> 2.4.1'
    log.dependency 'AFNetworkActivityLogger', '~> 2.0.3'
  end

end
