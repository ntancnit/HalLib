Pod::Spec.new do |s|
  s.platform = :ios
  s.ios.deployment_target = '11.0'
  s.name = "halframework"
  s.swift_version = '4.0'
  s.summary = "halframework manager"
  s.requires_arc = true
  s.version = "1.0"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "ntancnit@gmail.com" => "ntancnit@gmail.com" }
  s.homepage = "https://github.com/ntancnit/HalLib"
  s.source = { :git => "https://github.com/ntancnit/HalLib.git", :tag => "#{s.version}"}
  s.ios.framework = "UIKit"
  s.ios.framework = "CoreLocation"
  s.ios.framework = "Foundation"
  s.dependency 'RxSwift', '~> 4.0.0'
  s.dependency 'RxCocoa', '~> 4.0.0'
  s.dependency 'RxDataSources', '~> 3.0'
  s.dependency 'Action'
  s.dependency 'Alamofire', '~> 4.0'
  s.dependency 'AlamofireImage', '~> 3.0'
  s.dependency 'ObjectMapper', '~> 3.0'
  s.dependency 'IQKeyboardManagerSwift', '~> 5.0.0'
  s.dependency 'SVProgressHUD'
  s.dependency 'PureLayout'
  s.dependency 'KeychainAccess'
  s.source_files = "halframework/**/*.{swift,h,m}"
  s.resources = "halframework/**/*.{png,jpeg,jpg,storyboard,xib,plist,swift}"
end