# FWDraggableSwipePlayer
A draggable player like youtube's and PPS's app, full screen with swipe player 

# Screen shots

![alt tag](https://raw.githubusercontent.com/fillywong/FWDraggableSwipePlayer/master/Assets/demo.gif)
![alt tag](https://raw.githubusercontent.com/fillywong/FWDraggableSwipePlayer/master/Assets/demo2.gif)

# Usage

* With draggable manager:

``` FWDraggablePlayerManager *manager = [[FWDraggablePlayerManager alloc]initWithList:list Config:[[FWSWipePlayerConfig alloc]init]];```

```[manager showAtViewAndPlay:self.view]; ```

* only view 

with list video:
  
```[[[FWSwipePlayerViewController alloc]init] updateMoviePlayerWithVideoList:list Config:[[FWSWipePlayerConfig alloc]init]];```

```[self.view addSubview:playerController.view];```

no list video:
  
```[[[FWSwipePlayerViewController alloc]init] updateMoviePlayerWithInfo:videoinfo Config:[[FWSWipePlayerConfig alloc]init]];```

```[self.view addSubview:playerController.view];```
