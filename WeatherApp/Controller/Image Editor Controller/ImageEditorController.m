//
//  ImageEditorController.m
//  WeatherApp
//
//  Created by Sherif Kamal on 2/28/20.
//  Copyright © 2020 Sherif Kamal. All rights reserved.
//

#import "ImageEditorController.h"
#import <Foundation/Foundation.h>
#import "WeatherInfoBanner.h"
#import "WeatherData.h"

@interface ImageEditorController ()
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;
@property (weak, nonatomic) IBOutlet UIButton *dismissBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;

@end

@implementation ImageEditorController

@synthesize image;
@synthesize weather;
@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupImageView:image];
    [self addWeatherBanner];
}


#pragma mark - UI
-(void)setupImageView:(UIImage*) image {
    [_imageView setImage:image];
}

///Add weather info into banner on top left of image
-(void)addWeatherBanner {
    NSString* temp = weather.temp.stringValue;
    WeatherInfoBanner* banner = [[WeatherInfoBanner alloc] initWithFrame:CGRectMake(0, 0, 200, 150)];
    banner.tempLbl.text = temp;
    banner.forecastConditionLbl.text = weather.desc;
    banner.cityLbl.text = weather.name;
    [_contentImageView addSubview:banner];
}

///Convert image to view by capture screenshot for the view
- (UIImage *)imageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, 0.0);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];

    UIImage * img = UIGraphicsGetImageFromCurrentImageContext();

    UIGraphicsEndImageContext();

    return img;
}

#pragma mark - User Actions

- (IBAction)shareBtnTapped:(id)sender {
    UIImage* image = [self imageWithView:_contentView];
    NSMutableArray* images = [[NSMutableArray alloc] init];
    [images addObject:image];
    UIActivityViewController* activity = [[UIActivityViewController alloc] initWithActivityItems:images applicationActivities:nil];
    [self presentViewController:activity animated:YES completion:nil];
}

- (IBAction)endEditingBtnTapped:(id)sender {
    UIImage* image = [self imageWithView:_contentView];
    [delegate endImageEditing:image];
    [self dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)saveBtnTapped:(id)sender {
    UIImage* image = [self imageWithView:_contentView];
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(thisImage:hasBeenSavedInPhotoAlbumWithError:usingContextInfo:), NULL);
}

///selector for saving image to photos album
- (void)thisImage:(UIImage *)image hasBeenSavedInPhotoAlbumWithError:(NSError *)error usingContextInfo:(void*)ctxInfo {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Image saved"
                                                                   message:@"Image saved successfully"
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"Ok"
                                                           style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
    }];
    
    [alert addAction:okAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (IBAction)dismissBtnTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
