# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'EnxDemoApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

        pod 'EnxRTCiOS'
        pod 'Socket.IO-Client-Swift', '~> 16.1.1'
        pod 'SVProgressHUD'
        pod 'ReachabilitySwift'
        pod 'AlertToast'

  # Pods for EnxDemoApp
  
  post_install do |installer|
            installer.generated_projects.each do |project|
                  project.targets.each do |target|
                      target.build_configurations.each do |config|
                          config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
                       end
                  end
           end
        end

end
