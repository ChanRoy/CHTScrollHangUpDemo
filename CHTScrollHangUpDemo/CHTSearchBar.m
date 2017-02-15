//
//  CHTSearchBar.m
//  CHTScrollHangUpDemo
//
//  Created by cht on 2017/2/15.
//  Copyright © 2017年 cht. All rights reserved.
//

#import "CHTSearchBar.h"
#import "UIColor+CHTExtend.h"

static NSString *const kPlaceholderText = @"请输入搜索关键词";

@interface CHTSearchBar ()

@property (nonatomic, strong) UIButton *searchButton;
@property (nonatomic, strong) UILabel *placeholder;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UIButton *clearBtn;

@end

@implementation CHTSearchBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        [self setupUI];
        
        _placeholder.text = kPlaceholderText;
        
    }
    return self;
}

#pragma mark - UI

- (void)setupUI{
    
    _searchButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _searchButton.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];//RGBACOLOR(255,255,255, 0.9);
    
    _searchButton.frame = CGRectMake(0, 0, self.frame.size.width, 35);
    _searchButton.layer.cornerRadius = 5;
    [self addSubview:_searchButton];
    [_searchButton addTarget:self action:@selector(searchBarButtonClick) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *glassBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    glassBtn.frame = CGRectMake(19, (CGRectGetHeight(_searchButton.frame) - 16)/2, 16, 16);
    [_searchButton addSubview:glassBtn];
    UIImage *image = [[UIImage imageNamed:@"glassSelectImage"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [glassBtn setImage:image  forState:UIControlStateNormal];
    
    _placeholder = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(glassBtn.frame), (CGRectGetHeight(_searchButton.frame) - 16)/2, _searchButton.frame.size.width - CGRectGetMaxX(glassBtn.frame) , 16)];
    
    _placeholder.textColor = [UIColor colorWithHexString:@"#b2b2b2"];
    _placeholder.font = [UIFont systemFontOfSize:14];
    [_searchButton addSubview:_placeholder];
    
    if (_isHomePage) {
        return;
    }
    _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(glassBtn.frame), (CGRectGetHeight(_searchButton.frame) - 16)/2, _searchButton.frame.size.width - CGRectGetMaxX(glassBtn.frame), 16)];
    _contentLabel.font = [UIFont systemFontOfSize:14.0f];
    _contentLabel.textColor = [UIColor colorWithHexString:@"#b2b2b2"];
    [_searchButton addSubview:_contentLabel];
    _contentLabel.hidden = YES;
    
    _clearBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat width = 15;
    _clearBtn.frame = CGRectMake(CGRectGetWidth(_searchButton.frame) - width - 10, (CGRectGetHeight(_searchButton.frame) - width)/2, width, width);
    [_clearBtn setImage:[UIImage imageNamed:@"search_clear"] forState:UIControlStateNormal];
    [_searchButton addSubview:_clearBtn];
    _clearBtn.hidden = YES;
    [_clearBtn addTarget:self action:@selector(clearContent:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - set methods
- (void)setContent:(NSString *)content{
    
    if ([content isEqualToString:@""] || content == nil) {
        return;
    }
    _content = content;
    _contentLabel.text = _content;
    _contentLabel.hidden = NO;
    _placeholder.hidden = YES;
    _clearBtn.hidden = NO;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    _placeholder.textColor = _textColor;
}

- (void)setTextFont:(UIFont *)textFont
{
    _textFont = textFont;
    _placeholder.font = textFont;
}

- (void)setBtnColor:(UIColor *)btnColor
{
    _btnColor = btnColor;
    _searchButton.backgroundColor = _btnColor;
}

#pragma mark - events
- (void)searchBarButtonClick
{
        //NSLog(@"111");
        if (_searchBarBlock) {
            _searchBarBlock();
        }
}

- (void)clearContent:(UIButton *)clearBtn{
    
    self.content = nil;
    _contentLabel.hidden = YES;
    _clearBtn.hidden = YES;
    _placeholder.hidden = NO;
    
    if (_clearContentBlock) {
        _clearContentBlock();
    }
}

@end
