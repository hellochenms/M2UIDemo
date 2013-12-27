//
//  M2NavigationController.m
//  CoreUIKit
//
//  Created by Chen Meisong on 13-11-13.
//  Copyright (c) 2013年 Chen Meisong. All rights reserved.
//

#import "M2NavigationController.h"

@interface M2NavigationController ()

@end

@implementation M2NavigationController

- (id)initWithRootViewController:(UIViewController *)rootViewController{
    if (self = [super initWithRootViewController:rootViewController]) {
//        self.navigationBarHidden = YES;
    }
    
    return self;
}

//#pragma mark - rotate
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation NS_DEPRECATED_IOS(2_0, 6_0);{
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
//        return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
//    }else{
//        return UIInterfaceOrientationIsLandscape(toInterfaceOrientation);
//    }
//}
//- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0){
//    return YES;
//}
//- (NSUInteger)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0){
//    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
//        return UIInterfaceOrientationMaskPortrait|UIInterfaceOrientationMaskPortraitUpsideDown;
//    }else{
//        return UIInterfaceOrientationMaskLandscapeLeft|UIInterfaceOrientationMaskLandscapeRight;
//    }
//}

#pragma mark - rotate
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation NS_DEPRECATED_IOS(2_0, 6_0);{
    return YES;
}
- (BOOL)shouldAutorotate NS_AVAILABLE_IOS(6_0){
    return YES;
}
- (NSUInteger)supportedInterfaceOrientations NS_AVAILABLE_IOS(6_0){
    return UIInterfaceOrientationMaskAll;
}

@end
