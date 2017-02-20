# CHTScrollHangUpDemo
实现搜索栏随UITableView滚动，滚动到UINavigationBar处即悬挂在UINavigationBar上方的效果

![](https://github.com/ChanRoy/CHTScrollHangUpDemo/blob/master/CHTScrollHangUpDemo.gif)

## 简介
*随着UITableView的滚动，UINavigationBar透明度逐渐加深，SearchBar上移最后悬挂到UINavigationBar上。*

*具体效果如上图*

## 实现过程
### 分解效果：

最终的效果可以分解为三个不同的部分：

1. UITableView的头部图片大小随着UITableView的偏移量而改变；

2. UINavigationBar的透明度随着UITableView的偏移量而改变；

3. SearchBar随着UITableView滚动，最后悬挂到UINavigationBar上面。

### 分步实现：

#### 1.UITableView的头部图片大小随着UITableView的偏移量而改变：

这部分的实现比较简单，可以查看我以前写的一个Demo：[CHTScrollHeaderImageDemo](https://github.com/ChanRoy/CHTScrollHeaderImageDemo)。

#### 2.UINavigationBar的透明度随着UITableView的偏移量而改变:

这部分的实现相比第一部分要复杂一点，同样的我之前也写了个Demo：[CHTNavigationBarDemo](https://github.com/ChanRoy/CHTNavigationBarDemo)。

#### 3.SearchBar随着UITableView滚动，最后悬挂到UINavigationBar上面:

实现思路如下：

在UITableView上放置一个假的搜索栏：**fakeSearchBar**，在UINavigationBar上放置一个真的搜索栏：**searchBar**，初始化为隐藏。计算好位置，当UITableView滑动到**fakeSearchBar**与**searchBar**位置重叠时，让**fakeSearchBar**隐藏，**fakeSearchBar**显示。

相关代码如下：

- 初始化**searchBar**：

```
//声明属性
@property (nonatomic, strong) CHTSearchBar *searchBar;
```
```
//懒加载
- (CHTSearchBar *)searchBar{
    
    if (_searchBar == nil) {
        _searchBar = [[CHTSearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-44, 36)];
        _searchBar.hidden = YES;
    }
    return _searchBar;
}
```
```
//调用
self.navigationItem.titleView = self.searchBar;
```
- 初始化**fakeSearchBar**：

```
//声明属性
@property (nonatomic, strong) CHTSearchBar *fakeSearchBar;
```
```
//懒加载
- (CHTSearchBar *)fakeSearchBar{
    
    if (_fakeSearchBar == nil) {
        //搜索栏---这个view放在tableview上，跟随滑动。到达navigationbar位置时隐藏
        _fakeSearchBar = [[CHTSearchBar alloc] initWithFrame:CGRectMake(22, -40, SCREEN_WIDTH-44, 36)];
    }
    return _fakeSearchBar;
}
```
```
//调用
[self.tableView addSubview:self.fakeSearchBar];
```
- UIScrollViewDelegate相关：

```
#pragma mark - scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (scrollView == self.tableView) {
        
        CGPoint offset = scrollView.contentOffset;
        if (offset.y < -kImgHeight) {
            
            CGRect imgRect = _headerImageView.frame;
            //origin.y 保持不变，高度增加，保证了图片拉升的效果
            imgRect.origin.y = offset.y;
            imgRect.size.height = -offset.y;
            _headerImageView.frame = imgRect;
            
            //_topImageCoverView 大小与 _headerImageView 保持一致
            CGRect coverFrame = _topImageCoverView.frame;
            coverFrame.size.height = CGRectGetHeight(_headerImageView.frame);
            _topImageCoverView.frame = coverFrame;
            
        }
        
        //add
        CGFloat offsetY = scrollView.contentOffset.y;
        
        // 随着scrollView.contentOffset.y的增大，逐渐隐藏导航栏； 为零及负值时完全显示导航栏
        
        if (offsetY > -(190-(190-80)/2)) {
            _alphaY = (offsetY + 140) / 90;
            if (_alphaY >= ALPHA_OF_NAVBAR) {
                _alphaY = ALPHA_OF_NAVBAR;
            }
            
        }else{
            _alphaY = (offsetY + 140) / 90;
            if (_alphaY <= 0) {
                _alphaY = 0.0;
            }
        }
        
//        NSLog(@"***%.2f",_alphaY);
        
        //控制---topImageView上遮盖层效果和navigationbar上searchBar的出现和隐藏
        [self moveConfigTopBgView];
    
    }
}

- (void)moveConfigTopBgView{
    
    if (_tableView.contentOffset.y < - 64) {

        [self cht_getBackView:self.navigationController.navigationBar color:[[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:0]];
        self.topImageCoverView.alpha = _alphaY;
        self.searchBar.hidden = YES;
        self.fakeSearchBar.hidden = NO;
    }else{

        [self cht_getBackView:self.navigationController.navigationBar color:[[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:ALPHA_OF_NAVBAR]];
        self.searchBar.hidden = NO;
        self.topImageCoverView.alpha = 0;
        self.fakeSearchBar.hidden = YES;
    }
}
```
**备注：其中的_topImageCoverView是为了更好的过度效果加的一个遮盖层。**

完整的代码比较多，详见Demo。


