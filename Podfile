# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'

target 'Crowdify' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  pod 'SnapKit'
  pod 'Firebase'
  pod 'Firebase/Database'

  pod 'GeoFire', :git => 'https://github.com/firebase/geofire-objc.git'

  pod 'SDWebImage', '4.0.0-beta2'

  # Pods for Crowdify

  target 'CrowdifyTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'CrowdifyUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end
