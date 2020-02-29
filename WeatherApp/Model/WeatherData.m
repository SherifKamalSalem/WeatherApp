//
//  WeatherData.m
//  WeatherApp
//
//  Created by Sherif Kamal on 2/28/20.
//  Copyright © 2020 Sherif Kamal. All rights reserved.
//

#import "WeatherData.h"

@implementation WeatherData

- (id)initWithJSON:(NSData *)jsonData {
    if (self = [super init]){
        NSError *error;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:&error];
        if (error) {
            NSLog(@"NSJSONSerialization failed with error: %@", [error localizedDescription]);
            return self;
        }
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            id idName = [jsonObject objectForKey:@"name"];
            if ([idName isKindOfClass:[NSString class]]) {_name = idName;}
            id idWeatherArr = [jsonObject objectForKey:@"weather"];
            if ([idWeatherArr isKindOfClass:[NSArray class]]) {
                id idWeather = [idWeatherArr objectAtIndex:0];
                if ([idWeather isKindOfClass:[NSDictionary class]]) {
                    id idMain = [idWeather objectForKey:@"main"];
                    if ([idMain isKindOfClass:[NSString class]]) {_main = idMain;}
                    id idDesc = [idWeather objectForKey:@"description"];
                    if ([idDesc isKindOfClass:[NSString class]]) {_desc = idDesc;}
                }
            }
            id idMainD = [jsonObject objectForKey:@"main"];
            if ([idMainD isKindOfClass:[NSDictionary class]]) {
                _temp = [NSNumber numberWithDouble: [[idMainD objectForKey:@"temp"] doubleValue]];
            }
        } else {
            NSLog(@"Data is not a Dictionary");
        }
    }
    return self;
}

- (NSString *)tempString {
    return [NSString stringWithFormat:@"%i°",[self.temp intValue]];
}

@end



