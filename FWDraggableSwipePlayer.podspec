#
# Be sure to run `pod lib lint FWDraggableSwipePlayer.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "FWDraggableSwipePlayer"
  s.version          = "1.0.0"
  s.summary          = "MPMoviePlayerController A draggable player like youtube's and PPS's app, full screen with swipe player"
  s.description      = <<-DESC
FWDraggablePlayerManager *manager = [[FWDraggablePlayerManager alloc]initWithList:list Config:[[FWSWipePlayerConfig alloc]init]];

[manager showAtViewAndPlay:self.view];
                       DESC
  s.homepage         = "https://github.com/fillywong/FWDraggableSwipePlayer"
  # s.screenshots     = "raw.githubusercontent.com/fillywong/FWDraggableSwipePlayer/master/Assets/demo.gif", "raw.githubusercontent.com/fillywong/FWDraggableSwipePlayer/master/Assets/demo2.gif"
  s.license      = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { "fillywong" => "514884572@qq.com" }
  s.source           = { :git => "https://github.com/fillywong/FWDraggableSwipePlayer.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'FWDraggableSwipePlayerDemo/FWDraggableSwipePlayer/**/*'

  # s.public_header_files = 'FWDraggableSwipePlayerDemo/FWDraggableSwipePlayer/**/*.h'
  # s.frameworks = 'UIKit', 'Foundation'
end
