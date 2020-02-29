//
//  WeatherServices.h
//  WeatherApp
//
//  Created by Sherif Kamal on 2/28/20.
//  Copyright © 2020 Sherif Kamal. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import "WeatherData.h"

@interface WeatherServices : NSObject

+(WeatherServices*) sharedInstance;

- (void)fetchCurrentWeatherDataForLocation:(CLLocation *)location completion:(void(^)(WeatherData *weatherData))completion failure:(void(^)(NSError* error))failure;

@end
