//
//  CHTSearchBar.h
//  CHTScrollHangUpDemo
//
//  Created by cht on 2017/2/15.
//  Copyright © 2017年 cht. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HomePageSearchButtonClick)(void);

@interface CHTSearchBar : UIView

@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *btnColor;
@property (nonatomic, copy) NSString *content;

@property (nonatomic, assign) BOOL isHomePage;

//@property (nonatomic, assign) NavgationBarShowType navgationBarShowType;
@property (nonatomic, copy) HomePageSearchButtonClick searchBarBlock;
@property (nonatomic, copy) void (^clearContentBlock)();

//- (id)initWithFrame:(CGRect)frame houseType:(QFHKHouseType)houseType;

@end
