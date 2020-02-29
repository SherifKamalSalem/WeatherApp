//
//  WeatherInfoBanner.m
//  WeatherApp
//
//  Created by Sherif Kamal on 2/28/20.
//  Copyright © 2020 Sherif Kamal. All rights reserved.
//

#import "WeatherInfoBanner.h"

@interface WeatherInfoBanner ()

@end

@implementation WeatherInfoBanner

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self customInit];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self customInit];
    }
    return self;
}

-(void)customInit {
    [self setBackgroundColor:UIColor.clearColor];
    _view = [self loadViewFromNib];
    _view.frame = self.bounds;
    [self setFrame:self.bounds];
    _view.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    _view.translatesAutoresizingMaskIntoConstraints = YES;
    [self setupBlurEffect];
    self.layer.cornerRadius = 10;
    [self addSubview:_view];
}

-(UIView*)loadViewFromNib {
    return [[NSBundle mainBundle] loadNibNamed:@"WeatherInfoBanner" owner:self options:nil].firstObject;
}

///add blur effect to the banner
-(void)setupBlurEffect {
    UIBlurEffect* blur = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView* visualEffect = [[UIVisualEffectView alloc] initWithEffect:blur];
    UIVisualEffectView* bluredView = [[UIVisualEffectView alloc] initWithEffect:blur];
    visualEffect.frame = _view.frame;
    bluredView.frame = _view.bounds;
    [bluredView setFrame:self.bounds];
    [_view insertSubview:bluredView atIndex:0];
}

@end
