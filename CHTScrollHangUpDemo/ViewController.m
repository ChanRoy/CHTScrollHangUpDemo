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

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define ALPHA_OF_NAVBAR                 0.9
#define TOP_INFO_IMAGEVIEW_TOP          80

static NSString *const kCellId = @"cellId"; //reuse id
static CGFloat const kImgHeight = 200;

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIView *fakeNavBar;
@property (nonatomic, strong) CHTSearchBar *searchBar;
@property (nonatomic, strong) UIView *topBgView;
@property (nonatomic, strong) UIView *topImageCoverView;
@property (nonatomic, strong) CHTSearchBar *fakeSearchBar;
@property (nonatomic, assign) CGFloat alphaY;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.navigationController.navigationBar.hidden = YES;
    
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.headerImageView];
    self.fakeNavBar.hidden = NO;
    
    //搜索栏---这个view放在tableview上，跟随滑动。到达navigationbar位置时隐藏
    _fakeSearchBar = [[CHTSearchBar alloc] initWithFrame:CGRectMake(22, -45, SCREEN_WIDTH-44, 35)];
    [self.tableView addSubview:_fakeSearchBar];
}

#pragma mark - lazy load
- (UITableView *)tableView{
    
    if (_tableView == nil) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.contentInset = UIEdgeInsetsMake(kImgHeight, 0, 0, 0);
        //去掉空白行的显示
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}

- (UIImageView *)headerImageView{
    
    if (_headerImageView == nil) {
        _headerImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, -kImgHeight, CGRectGetWidth(self.view.frame), kImgHeight)];
        _headerImageView.image = [UIImage imageNamed:@"img.jpg"];
        //UIViewContentModeScaleAspectFill，保证拉升时长宽一起拉升
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        //遮盖层---制造渐变过程
        _topImageCoverView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_headerImageView.frame), CGRectGetHeight(_headerImageView.frame))];
        
        _topImageCoverView.backgroundColor = [UIColor colorWithHexString:@"#333333"];
        _topImageCoverView.alpha = 0;
        [_headerImageView addSubview:_topImageCoverView];
        
        
    }
    return _headerImageView;
}

- (UIView *)fakeNavBar{
    
    if (_fakeNavBar == nil) {
        //第一步替换navgationBar
        _fakeNavBar = [[UIView alloc] initWithFrame:CGRectMake(0, -20, SCREEN_WIDTH, 80)];
        _fakeNavBar.backgroundColor = [UIColor clearColor];
        [self.navigationController.navigationBar addSubview:_fakeNavBar];
        
        //第二步插入背景view
        _topBgView = [[UIView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH-44, 80)];
        _topBgView.backgroundColor = [UIColor clearColor];
        //    _topBgView.hidden = YES;
        //第三部插入搜索bar
        // 显示searchBar--此处自定义吧
        _searchBar = [[CHTSearchBar alloc] initWithFrame:CGRectMake(0, 32, SCREEN_WIDTH-44, 35)];
        [_topBgView addSubview:_searchBar];
        self.navigationItem.titleView = _topBgView;
    }
    return _fakeNavBar;
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
        //        NSLog(@"%.2f",offset.y);
        if (offset.y < -kImgHeight) {
            
            CGRect imgRect = _headerImageView.frame;
            //origin.y 保持不变，高度增加，保证了图片拉升的效果
            imgRect.origin.y = offset.y;
            imgRect.size.height = -offset.y;
            _headerImageView.frame = imgRect;
        }
        
        //add
        CGFloat offsetY = scrollView.contentOffset.y;
        
        // 随着scrollView.contentOffset.y的增大，逐渐隐藏自定义的导航栏； 为零及负值时完全显示导航栏
        
//        CGRect labelFrame = _topInfoImage.frame;
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
        //控制---topImageView上遮盖层效果和navigationbar上searchBar的出现和隐藏
        [self moveConfigTopBgView];
        
        //控制infoLable和topImageView的frame
        if (offsetY > -190) {
            //上拉时移动速度跟scrollview一致
//            labelFrame.origin.y = - (offsety + W(190)) + TOP_INFO_IMAGEVIEW_TOP;
        }else{
            //下拉时移动速度慢，速度跟scrollview / 2一致
//            labelFrame.origin.y = - (offsety + W(190))/2 + TOP_INFO_IMAGEVIEW_TOP;
        }
        
//        _topInfoImage.frame = labelFrame;
        

    }
}

- (void)moveConfigTopBgView{
    
    if (_tableView.contentOffset.y < - 80) {
        _fakeNavBar.backgroundColor = [[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:0];
        _topImageCoverView.alpha = _alphaY;
        _topBgView.hidden = YES;
        _fakeSearchBar.hidden = NO;
    }else{
        _fakeNavBar.backgroundColor = [[UIColor colorWithHexString:@"#333333"] colorWithAlphaComponent:ALPHA_OF_NAVBAR];
        _topBgView.hidden = NO;
        _topImageCoverView.alpha = 0;
        _fakeSearchBar.hidden = YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
