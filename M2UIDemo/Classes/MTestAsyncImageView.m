//
//  MAsyncImageView.m
//  M2UIDemo
//
//  Created by Chen Meisong on 14-2-11.
//  Copyright (c) 2014年 Chen Meisong. All rights reserved.
//

#import "MTestAsyncImageView.h"

@interface MTestAsyncImageView(){
    UIImageView *_imageView;
    UIActivityIndicatorView *_loadingView;
}
@property (nonatomic, copy) void (^completion)(BOOL finished);
@end

@implementation MTestAsyncImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _imageView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        _imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        _imageView.layer.borderColor = [UIColor blueColor].CGColor;
        _imageView.layer.borderWidth = 1;
        [self addSubview:_imageView];
        
        //
        _loadingView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        _loadingView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
        _loadingView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2, CGRectGetHeight(self.bounds) / 2);
        _loadingView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleBottomMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin;
        [self addSubview:_loadingView];
    }
    return self;
}

- (void)loadImageWithName:(NSString *)name completion:(void (^)(BOOL finished))completion{
    self.completion = completion;
    
    _image = nil;
    _imageView.image = _image;
    [_loadingView startAnimating];
    
    [self performSelector:@selector(didLoadImage:) withObject:name afterDelay:arc4random() % 1000 / 1000.0];
}

- (void)didLoadImage:(NSString *)name{
    
    _image = [UIImage imageNamed:name];
    _imageView.image = _image;
    
    [_loadingView stopAnimating];
    
    if (_completion) {
        _completion(YES);
    }
}

@end
