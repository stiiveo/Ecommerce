# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def shared_pods
  pod 'Firebase/Core'
  pod 'Firebase/Auth'
  pod 'Firebase/Firestore'
  pod 'Firebase/Storage'
  pod 'Firebase/Functions'
  pod 'IQKeyboardManagerSwift'
  pod 'Kingfisher'
end

target 'Ecommerce' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Ecommerce
  pod 'Stripe'
  shared_pods

  # target 'EcommerceTests' do
  #   inherit! :search_paths
  #   # Pods for testing
  # end

  # target 'EcommerceUITests' do
  #   # Pods for testing
  # end

end

target 'EcommerceAdmin' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for EcommerceAdmin
  shared_pods

  # target 'EcommerceAdminTests' do
  #   inherit! :search_paths
  #   # Pods for testing
  # end

  # target 'EcommerceAdminUITests' do
  #   # Pods for testing
  # end

end
