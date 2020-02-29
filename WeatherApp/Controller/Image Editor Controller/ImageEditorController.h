//
//  ImageEditorController.h
//  WeatherApp
//
//  Created by Sherif Kamal on 2/28/20.
//  Copyright © 2020 Sherif Kamal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WeatherData.h"

NS_ASSUME_NONNULL_BEGIN

@protocol EditImageDelegate <NSObject>

-(void)endImageEditing:(UIImage*) image;

@end

@interface ImageEditorController : UIViewController
@property (nonatomic, strong) WeatherData* weather;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, weak) id <EditImageDelegate> delegate;
@end

NS_ASSUME_NONNULL_END
