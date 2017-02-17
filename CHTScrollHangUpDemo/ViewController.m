//
//  ViewController.m
//  CHTScrollHangUpDemo
//
//  Created by cht on 2017/2/15.
//  Copyright © 2017年 cht. All rights reserved.
//

#import "ViewController.h"
#import "CHTSearchBar.h"
#import "UIColor+CHTExtend.h"

#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define ALPHA_OF_NAVBAR          0.7
#define TOP_INFO_IMAGEVIEW_TOP   80

static NSString *const kCellId = @"cellId"; //reuse id
static CGFloat const kImgHeight = 200;

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) CHTSearchBar *searchBar;
@property (nonatomic, strong) UIView *topImageCoverView;
@property (nonatomic, strong) CHTSearchBar *fakeSearchBar;
@property (nonatomic, assign) CGFloat alphaY;
@property (nonatomic, strong) UIImageView *navBarHairlineImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configNavBar];
    [self configUI];
}

- (void)configNavBar{
    
    [self findHairlineImageViewUnder:self.navigationController.navigationBar].hidden = YES;
    [self cht_getBackView:self.navigationController.navigationBar color:[UIColor clearColor]];
    self.navigationItem.titleView = self.searchBar;
}

- (void)configUI{
    
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.headerImageView];
    [self.tableView addSubview:self.fakeSearchBar];
    [self.headerImageView addSubview:self.topImageCoverView];
}

#pragma mark - lazy load
- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(kImgHeight, 0, 0, 0);
        _tableView.showsVerticalScrollIndicator = NO;
        //去掉空白行的显示
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UIImageView *)headerImageView{
    
    if (_headerImageView == nil) {
        _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kImgHeight, CGRectGetWidth(self.view.frame), kImgHeight)];
        _headerImageView.image = [UIImage imageNamed:@"img"];
        //UIViewContentModeScaleAspectFill，保证拉升时长宽一起拉升
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        
    }
    return _headerImageView;
}

- (CHTSearchBar *)searchBar{
    
    if (_searchBar == nil) {
        _searchBar = [[CHTSearchBar alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH-44, 36)];
        _searchBar.hidden = YES;
    }
    return _searchBar;
}

- (CHTSearchBar *)fakeSearchBar{
    
    if (_fakeSearchBar == nil) {
        //搜索栏---这个view放在tableview上，跟随滑动。到达navigationbar位置时隐藏
        _fakeSearchBar = [[CHTSearchBar alloc] initWithFrame:CGRectMake(22, -40, SCREEN_WIDTH-44, 36)];
    }
    return _fakeSearchBar;
}

- (UIView *)topImageCoverView{
    
    if (_topImageCoverView == nil) {
        //遮盖层---制造渐变过程
        _topImageCoverView = [[UIView alloc]initWithFrame:self.headerImageView.bounds];
        
        _topImageCoverView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
        _topImageCoverView.alpha = 0;
    }
    return _topImageCoverView;
}

#pragma mark - private methods
- (void)cht_getBackView:(UIView *)view color:(UIColor *)color{
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    
    if (SYSTEM_VERSION < 10) {
        
        // <iOS10
        if ([view isKindOfClass:NSClassFromString(@"_UINavigationBarBackground")]) {
            
            view.backgroundColor = color;
        }else if ([view isKindOfClass:NSClassFromString(@"_UIBackdropView")]){
            
            //将_UINavigationBarBackground上面的遮罩层隐藏
            view.hidden = YES;
        }
        for (UIView *subView in view.subviews) {
            
            [self cht_getBackView:subView color:color];
        }
    }
    
#ifdef __IPHONE_10_0
    else{
        // >=iOS10
        if ([view isKindOfClass:NSClassFromString(@"_UIBarBackground")] ||
            [view isKindOfClass:NSClassFromString(@"UIVisualEffectView")]) {
            
            
            CGFloat alpha;
            [color getWhite:nil alpha:&alpha];
            view.backgroundColor = color;
            
            if ([view isKindOfClass:NSClassFromString(@"UIVisualEffectView")]) {
                
                //UIVisualEffectView 颜色的alpha值需要单独设置
                ((UIVisualEffectView *)view).alpha = alpha;
                
            }
            //color为透明颜色则隐藏遮盖层
            view.hidden = alpha == 0 ? YES : NO;
            
        }
        for (UIView *subView in view.subviews) {
            
            [self cht_getBackView:subView color:color];
        }
        self.navigationController.navigationBar.barTintColor = color;
    }
#endif
}

//递归寻找UINavigationBar下方的直线
- (UIImageView *)findHairlineImageViewUnder:(UIView *)view {
    if ([view isKindOfClass:UIImageView.class] && view.bounds.size.height <= 1.0) {
        return (UIImageView *)view;
    }
    for (UIView *subview in view.subviews) {
        UIImageView *imageView = [self findHairlineImageViewUnder:subview];
        if (imageView) {
            return imageView;
        }
    }
    return nil;
}

#pragma mark - tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 20;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellId];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"row -- %ld",indexPath.row];
    return cell;
}

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
