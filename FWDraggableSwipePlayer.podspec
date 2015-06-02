Pod::Spec.new do |s|
  s.name             = "FWDraggableSwipePlayer"
  s.version          = "1.0.2"
  s.summary          = "MPMoviePlayerController A draggable player like youtube's and PPS's app, full screen with swipe player"
  s.description      = <<-DESC
FWDraggablePlayerManager *manager = [[FWDraggablePlayerManager alloc]initWithList:list Config:[[FWSWipePlayerConfig alloc]init]];

[manager showAtViewAndPlay:self.view];
                       DESC
  s.homepage         = "https://github.com/fillywong/FWDraggableSwipePlayer"
  # s.screenshots     = "raw.githubusercontent.com/fillywong/FWDraggableSwipePlayer/master/Assets/demo.gif", "raw.githubusercontent.com/fillywong/FWDraggableSwipePlayer/master/Assets/demo2.gif"
  s.license      = { :type => 'MIT', :file => 'LICENSE.md' }
  s.author           = { "fillywong" => "514884572@qq.com" }
  s.source           = { :git => "https://github.com/fillywong/FWDraggableSwipePlayer.git", :tag => "#{s.version}", :commit => "ef169aad4b480e51b0b0c47722ba76de9d651035" }

  s.platform     = :ios, '6.0'
  s.requires_arc = true

  s.source_files = 'FWDraggableSwipePlayer/src/**/*'

  # s.public_header_files = 'FWDraggableSwipePlayer/src/**/*.h'
  # s.frameworks = 'UIKit', 'Foundation'
end
