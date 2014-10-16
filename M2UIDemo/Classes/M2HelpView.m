//
//  M2HelpView.m
//  M2Common
//
//  Created by Chen Meisong on 13-7-17.
//  Copyright (c) 2013年 Chen Meisong. All rights reserved.
//

#define M2HV_UserDefaultsKey_CFBundleVersionVersion @"M2HV_UserDefaultsKey_CFBundleVersionVersion"

#import "M2HelpView.h"

@interface M2HelpView()<UIScrollViewDelegate>
@property (nonatomic) BOOL      hasImages;
@property (nonatomic) UIButton  *closeButton;
@end

@implementation M2HelpView

- (id)initWithImageNames:(NSArray*)imageNames{
    CGRect frame = [UIScreen mainScreen].bounds;
    BOOL isPhone = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
    if (!isPhone) {
        frame = CGRectMake(0.0, 0.0, frame.size.height, frame.size.width);// Pad暂只支持横屏
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        if (!imageNames || imageNames.count <= 0) {
            return self;
        }
        
        _hasImages = YES;
        
        self.backgroundColor = [UIColor clearColor];
        
        float width = self.bounds.size.width;
        float height = self.bounds.size.height;
        
        UIScrollView *container = [[UIScrollView alloc] initWithFrame:self.bounds];
        container.contentSize = CGSizeMake(width * imageNames.count, height);
        container.showsHorizontalScrollIndicator = NO;
        container.showsVerticalScrollIndicator = NO;
        container.pagingEnabled = YES;
        container.delegate = self;
        
        UIImageView *imgV = nil;
        for (int i = 0; i < imageNames.count; i++) {
            imgV = [[UIImageView alloc] initWithFrame:CGRectMake(width * i, 0.0, width, height)];
            imgV.image = [UIImage imageNamed:imageNames[i]];
            imgV.userInteractionEnabled = YES;
            if (i == imageNames.count - 1) {
                _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
                [_closeButton addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
                [imgV addSubview:_closeButton];
            }
            [container addSubview:imgV];
        }
        
        [self addSubview:container];
    }
    
    return self;
}

#pragma mark - public
+ (BOOL)hasShowHelpDone{
    NSString *version = [[NSUserDefaults standardUserDefaults] objectForKey:M2HV_UserDefaultsKey_CFBundleVersionVersion];
    if (!version) {
        return NO;
    }
    
    NSString *nowVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    if (![version isEqualToString:nowVersion]) {
        return NO;
    }
    
    return YES;
}

#pragma mark -
- (void)showInController:(UIViewController*)controller{
    if ([self superview] || !_hasImages || !controller) {
        return;
    }
    controller = controller.navigationController ? controller.navigationController : controller;
    [controller.view addSubview:self];
    [controller.view bringSubviewToFront:self];
}



#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    double thresholdOffsetX = scrollView.contentSize.width - CGRectGetWidth(scrollView.bounds) / 4 * 3;
    NSLog(@"scrollView.contentOffset.x(%f) thresholdOffsetX(%f)  %s", scrollView.contentOffset.x, thresholdOffsetX, __func__);
    if (scrollView.contentOffset.x > thresholdOffsetX) {
        scrollView.delegate = nil;
        __weak typeof(self) weakSelf = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf closeMe];
        });
    }
}

#pragma mark -
- (void)onClick{
    [self closeMe];
}

- (void)closeMe {
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *nowVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    [userDefaults setObject:nowVersion forKey:M2HV_UserDefaultsKey_CFBundleVersionVersion];
    [userDefaults synchronize];
    
    __weak typeof(self) weakSelf = self;
    [[UIApplication sharedApplication] beginIgnoringInteractionEvents];
    [UIView animateWithDuration:0.382
                     animations:^{
                         weakSelf.alpha = 0.0f;
                     } completion:^(BOOL finished) {
                         [weakSelf removeFromSuperview];
                         [[UIApplication sharedApplication] endIgnoringInteractionEvents];
                     }];
}

@end
