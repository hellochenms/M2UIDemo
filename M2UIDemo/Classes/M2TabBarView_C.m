//
//  M2TabBarView_C.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-1-21.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "M2TabBarView_C.h"

#define M2TBVC_Default_ItemsCountInPage 5

@implementation M2TabBarView_C

- (id)initWithFrame:(CGRect)frame{
    return [self initWithFrame:frame itemsCountInPage:M2TBVC_Default_ItemsCountInPage];
}

- (id)initWithFrame:(CGRect)frame itemsCountInPage:(NSInteger)itemsCountInPage{
    self = [super initWithFrame:frame];
    if (self) {
//        // Initialization code
//        if (itemsCountInPage <= 0) {
//            return self;
//        }
//        
//        // self
//        _curSelectedIndex = NSNotFound;
//        _unSelectedTextColor = [UIColor grayColor];
//        _unSelectedFont = [UIFont systemFontOfSize:13];
//        
//        // 保证_itemsCountInPage为奇数
//        _itemsCountInPage = itemsCountInPage;
//        if (_itemsCountInPage % 2 == 0) {
//            _itemsCountInPage = _itemsCountInPage / 2 + 1;
//        }
//        
//        // scroll view
//        _mainView = [[UIScrollView alloc] initWithFrame:self.bounds];
//        _mainView.showsHorizontalScrollIndicator = NO;
//        _mainView.showsVerticalScrollIndicator = NO;
//        _mainView.delegate = self;
//        [self addSubview:_mainView];
    }
    
    return self;
}


@end
