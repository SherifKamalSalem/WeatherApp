//
//  WeatherServices.m
//  WeatherApp
//
//  Created by Sherif Kamal on 2/28/20.
//  Copyright © 2020 Sherif Kamal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WeatherServices.h"
#import "WeatherData.h"

@implementation WeatherServices

+ (WeatherServices *)sharedInstance {
    static WeatherServices *sharedInstance = nil;
       static dispatch_once_t onceToken;
       dispatch_once(&onceToken, ^{
           sharedInstance = [[WeatherServices alloc] init];
       });
       return sharedInstance;
}


- (void)fetchCurrentWeatherDataForLocation:(CLLocation *)location completion:(void(^)(WeatherData *weatherData))completion failure:(void(^)(NSError* error))failure {
    float latitude = location.coordinate.latitude;
    float longitude = location.coordinate.longitude;
    
    NSString *APIKey = @"eee2d705923723561141937e71fc536e";
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%f&lon=%f&units=imperial&appid=%@",latitude,longitude, APIKey];
    
    NSURLSession *session = [NSURLSession sharedSession];
    NSURL *url = [NSURL URLWithString:urlString];
    
    [[session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error){
        if(error) {
            failure(error);
        } else {
            WeatherData *weather = [[WeatherData alloc] initWithJSON:data];
            completion(weather);
        }
        
    }] resume];
}

@end
