//
//  M2HelpView.m
//  M2Common
//
//  Created by Chen Meisong on 13-7-17.
//  Copyright (c) 2013年 Chen Meisong. All rights reserved.
//

#define M2HV_UserDefaultsKey_CFBundleVersionVersion @"M2HV_UserDefaultsKey_CFBundleVersionVersion"

#import "M2HelpView.h"

@interface M2HelpView(){
    BOOL _hasImages;
}
@end

@implementation M2HelpView

- (id)initWithImageNames:(NSArray*)imageNames{
    BOOL isPhone = (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
    CGRect frame = [UIScreen mainScreen].bounds;
    if (!isPhone) {
        frame = CGRectMake(0.0, 0.0, frame.size.height, frame.size.width);// Pad暂只支持横屏
    }
    
    self = [super initWithFrame:frame];
    if (self) {
        if (!imageNames || imageNames.count <= 0) {
            return self;
        }
        
        _hasImages = YES;
        
        self.backgroundColor = [UIColor blackColor];
        
        float width = self.bounds.size.width;
        float height = self.bounds.size.height;
        
        UIScrollView *container = [[UIScrollView alloc] initWithFrame:self.bounds];
        container.contentSize = CGSizeMake(width * imageNames.count, height);
        container.showsHorizontalScrollIndicator = NO;
        container.showsVerticalScrollIndicator = NO;
        container.pagingEnabled = YES;
       
        UIImageView *imgV = nil;
        for (int i = 0; i < imageNames.count; i++) {
            imgV = [[UIImageView alloc] initWithFrame:CGRectMake(width * i, 0.0, width, height)];
            imgV.image = [UIImage imageNamed:imageNames[i]];
            imgV.userInteractionEnabled = YES;
            
            if (i == imageNames.count - 1) {
                UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
                float closeWidth = isPhone ? M2HelpView_Phone_CloseButton_Width : M2HelpView_PadLand_CloseButton_Width;
                float closeHeight = isPhone ? M2HelpView_Phone_CloseButton_Height : M2HelpView_PadLand_CloseButton_Height;
                float closeBottomMargin = isPhone ? M2HelpView_Phone_CloseButton_BottomMargin : M2HelpView_PadLand_CloseButton_BottomMargin;
                closeButton.frame = CGRectMake((imgV.bounds.size.width - closeWidth) / 2.0, imgV.bounds.size.height - closeBottomMargin - closeHeight, closeWidth, closeHeight);
                closeButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
                [closeButton addTarget:self action:@selector(onClick) forControlEvents:UIControlEventTouchUpInside];
                [imgV addSubview:closeButton];

#warning TODO:下述代码只为校准开始按钮的位置，确定后可删除或注释掉
                closeButton.backgroundColor = [UIColor blueColor];//TODO
                closeButton.alpha = 0.5;//TODO
                [closeButton setTitle:@"开始按钮" forState:UIControlStateNormal];//TODO
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

+ (void)showImageNames:(NSArray*)imageNames inController:(UIViewController*)controller{
    if (!imageNames || imageNames.count <= 0 || !controller) {
        return;
    }
    M2HelpView *helpView = [[M2HelpView alloc] initWithImageNames:imageNames];
    [helpView showInController:controller];
}

#pragma mark - private
- (void)showInController:(UIViewController*)controller{
    if ([self superview] || !_hasImages || !controller) {
        return;
    }
    controller = controller.navigationController ? controller.navigationController : controller;
    [controller.view addSubview:self];
    [controller.view bringSubviewToFront:self];
}

- (void)onClick{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *nowVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
    [userDefaults setObject:nowVersion forKey:M2HV_UserDefaultsKey_CFBundleVersionVersion];
    [userDefaults synchronize];
    
    __weak M2HelpView *weakSelf = self;
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
