# Uncomment the next line to define a global platform for your project
# platform :ios, '10.0'

target 'Tube-Playlist' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Tube-Playlist

    pod 'youtube-ios-player-helper'
	pod 'SwiftyJSON'
	pod 'Alamofire'
    #pod 'Kingfisher'
	pod 'TTSegmentedControl'
    pod 'ChameleonFramework/Swift', :git => 'https://github.com/ViccAlexander/Chameleon.git', :branch => 'wip/swift4'

  target 'Tube-PlaylistTests' do
    inherit! :search_paths
    # Pods for testing
  end

  post_install do |installer|
        installer.pods_project.targets.each do |target|
            if ['youtube-ios-player-helper'].include? target.name
                target.build_configurations.each do |config|
                    config.build_settings['SWIFT_VERSION'] = '3.0'
                end
            end
        end
    end

end
