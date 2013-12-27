//
//  M2ViewController.m
//  CoreUIKit
//
//  Created by Chen Meisong on 13-11-12.
//  Copyright (c) 2013年 Chen Meisong. All rights reserved.
//

#import "M2ViewController.h"

@interface M2ViewController ()

@end

@implementation M2ViewController

- (id)init{
    if (self = [super init]) {
        if (isios7) {
            self.automaticallyAdjustsScrollViewInsets = NO;
            self.edgesForExtendedLayout = UIRectEdgeNone;
        }
    }
    
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    self.view.backgroundColor = randomColor;
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
