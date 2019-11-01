# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Cluster' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Cluster
	#pod 'Google-Maps-iOS-Utils'
  pod 'GoogleMaps'
  pod 'SwiftyJSON'
  
end

pre_install do |installer|
  # workaround for https://github.com/CocoaPods/CocoaPods/issues/3289
  Pod::Installer::Xcode::TargetValidator.send(:define_method, :verify_no_static_framework_transitive_dependencies) {}
end
