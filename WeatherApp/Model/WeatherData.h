//
//  WeatherData.h
//  WeatherApp
//
//  Created by Sherif Kamal on 2/28/20.
//  Copyright © 2020 Sherif Kamal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherData : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSString *main;
@property (strong, nonatomic) NSString *desc;
@property (strong, nonatomic) NSNumber *temp;


-(id)initWithJSON:(NSData *)jsonData;
- (NSString *)tempString;

@end
