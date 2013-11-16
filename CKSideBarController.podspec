Pod::Spec.new do |s|
  s.name     = 'CKSideBarController'
  s.version  = ‘0.0.2’
  s.license  = 'MIT'
  s.summary  = 'CKSideBarController is a UITabBarController-like UIViewController for iPad.'
  s.homepage = 'https://github.com/jaykz52/CKSideBarController'
  s.authors  = { 'Jason Kozemczak' => 'jason.kozemczak@gmail.com' }
  s.source   = { :git => 'https://github.com/MaxKramer/CKSideBarController.git', :tag => '0.0.2' }
  s.source_files = 'Source'
  s.resources    = 'Source/Resources/*'
  s.frameworks = 'UIKit', 'QuartzCore', 'CoreGraphics'
  s.requires_arc = true
end
