//
//  ViewController.m
//  CHTScrollHangUpDemo
//
//  Created by cht on 2017/2/15.
//  Copyright © 2017年 cht. All rights reserved.
//

#import "ViewController.h"

static NSString *const kCellId = @"cellId"; //reuse id
static CGFloat const kImgHeight = 200;

@interface ViewController ()<UITableViewDelegate, UITableViewDataSource,UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UIView *fakeNavBar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.view.backgroundColor = [UIColor yellowColor];
    
    [self.view addSubview:self.tableView];
    [self.tableView addSubview:self.headerImageView];
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
    }
    return _headerImageView;
}

- (UIView *)fakeNavBar{
    
    if (_fakeNavBar == nil) {
                
    }
    return _fakeNavBar;
}

#pragma mark - tableview datasource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 10;
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
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
