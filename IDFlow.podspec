Pod::Spec.new do |spec|
  spec.name               = "IDFlow"
  spec.version            = "1.0.9"
  spec.platform = :ios, '14.0'
  spec.ios.deployment_target = '14.0'
  spec.summary            = "IDFlow Framework"
  spec.description        = "IDFlow Framework for iOS"
  spec.homepage           = "https://myid.uz/"
  spec.documentation_url  = "https://myid.uz/"
  spec.license = { :type => 'Commercial', :text => 'See www.myid.uz' }
  spec.author             = { "Uzinfocom" => "..." }
  spec.swift_version      = "5.8"
  spec.source            = { :http => "https://github.com/myidsdk/idflow-ios-sdk/releases/download/#{spec.version}/IDFlow.xcframework.zip" }
  spec.ios.vendored_frameworks = 'IDFlow.xcframework'
end
