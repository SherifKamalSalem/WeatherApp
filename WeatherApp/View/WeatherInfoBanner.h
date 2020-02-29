//
//  WeatherInfoBanner.h
//  WeatherApp
//
//  Created by Sherif Kamal on 2/28/20.
//  Copyright © 2020 Sherif Kamal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherInfoBanner.h"

NS_ASSUME_NONNULL_BEGIN

@interface WeatherInfoBanner : UIView
@property (weak, nonatomic) IBOutlet UIView *view;
@property (weak, nonatomic) IBOutlet UILabel *cityLbl;
@property (weak, nonatomic) IBOutlet UILabel *forecastConditionLbl;
@property (weak, nonatomic) IBOutlet UILabel *tempLbl;

@end

NS_ASSUME_NONNULL_END
