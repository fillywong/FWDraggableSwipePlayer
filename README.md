# FWDraggableSwipePlayer
A draggable player like youtube's and PPS's app, full screen with swipe player 

# Screen shots

![alt tag](https://raw.githubusercontent.com/fillywong/FWDraggableSwipePlayer/master/Assets/demo.gif)
![alt tag](https://raw.githubusercontent.com/fillywong/FWDraggableSwipePlayer/master/Assets/demo2.gif)

# Usage

* With draggable manager:

``` FWDraggableManager *manager = [[FWDraggableManager alloc]initWithList:list Config:[[FWSWipePlayerConfig alloc]init]];```
```[manager showAtViewAndPlay:self.view]; ```

change draggable detail view:
``` UIView *detailView = [[UIView alloc]init];```
``` detailView.backgroundColor = [UIColor blueColor]; ```
``` [self.playerManager setDetailView:detailView]; ```

* only view 
  
```FWSwipePlayerViewController *playerController = [[[FWSwipePlayerViewController alloc]init] updateMoviePlayerWithInfo:videoinfo Config:[[FWSWipePlayerConfig alloc]init]];```

```[playerController attachTo:self];```
```[playerController playStartAt:200];```
