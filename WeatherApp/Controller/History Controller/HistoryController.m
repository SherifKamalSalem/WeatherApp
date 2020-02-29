//
//  ViewController.m
//  WeatherApp
//
//  Created by Sherif Kamal on 2/28/20.
//  Copyright © 2020 Sherif Kamal. All rights reserved.
//

#import "HistoryController.h"
#import "WeatherServices.h"
#import "WeatherInfoBanner.h"
#import "ImageEditorController.h"
#import <UIKit/UIKit.h>
#import "FSPagerView-Swift.h"

@interface HistoryController ()
@property (weak, nonatomic) IBOutlet FSPagerView *pagerImage;
@property (weak, nonatomic) IBOutlet UIView *emptyContentView;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) WeatherData* weather;

@end

@implementation HistoryController
UIImagePickerController *imagePicker;
NSMutableString *apiURLString;
NSMutableArray *images;

@synthesize weather;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    [self enableLocationServices];
    [self setupImageViewer];
}

- (void)setupImageViewer {
    images = [self getImages];
    [[self pagerImage] reloadData];
    [self.pagerImage registerClass:[FSPagerViewCell class] forCellWithReuseIdentifier:@"cell"];
    self.pagerImage.transformer = [[FSPagerViewTransformer alloc] initWithType:FSPagerViewTransformerTypeCoverFlow];
    self.pagerImage.itemSize = CGSizeMake(300, 500);
    self.pagerImage.interitemSpacing = 10;
    self.pagerImage.decelerationDistance = 2;
    self.pagerImage.isInfinite = YES;
    [self.pagerImage reloadData];
}

#pragma mark - Check location availability
- (void)enableLocationServices {
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers;
    
    switch ([CLLocationManager authorizationStatus]) {
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            [self.locationManager stopUpdatingLocation];
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.locationManager startUpdatingLocation];
            break;
        default:
            break;
    }
}

#pragma mark - CLLocationManagerDelegate Methods

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    [[WeatherServices sharedInstance]
     fetchCurrentWeatherDataForLocation:[locations lastObject]
     completion:^(WeatherData *weatherData) {
        if (weatherData != nil) {
            self.weather = weatherData;
        }
    }
     failure:^(NSError *error) {
        NSLog(@"Failed: %@",error);
    }
     ];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            [self.locationManager requestWhenInUseAuthorization];
            [self.locationManager startUpdatingLocation];
            break;
        case kCLAuthorizationStatusDenied:
        case kCLAuthorizationStatusRestricted:
            [self.locationManager stopUpdatingLocation];
            break;
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:
            [self.locationManager startUpdatingLocation];
            break;
        default:
            break;
    }
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage* image = info[UIImagePickerControllerEditedImage];
    [self dismissViewControllerAnimated:YES completion:nil];
    ImageEditorController* editor = [[ImageEditorController alloc] initWithNibName:@"ImageEditorController" bundle:nil];
    editor.image = image;
    editor.delegate = self;
    editor.weather = weather;
    editor.view.backgroundColor = UIColor.blackColor;
    editor.modalPresentationStyle = UIModalPresentationOverFullScreen;
    editor.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:editor animated:YES completion:nil];
}



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - User Actions
- (IBAction)cameraBtnPressed:(id)sender {
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.allowsEditing = YES;
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Image Picker Option"
                                                                       message:@"Please choose image picker option"
                                                                preferredStyle:UIAlertControllerStyleActionSheet]; // 1
        UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"Camera"
                                                               style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self pickImageWithOption:UIImagePickerControllerSourceTypeCamera];
        }];
        UIAlertAction *libraryAction = [UIAlertAction actionWithTitle:@"Photo Library"
                                                                style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self pickImageWithOption:UIImagePickerControllerSourceTypePhotoLibrary];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel"
                                                                style:UIAlertActionStyleCancel handler:^(UIAlertAction * action) {
            
        }];
        
        [alert addAction:cameraAction];
        [alert addAction:libraryAction];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
}

-(void)pickImageWithOption:(UIImagePickerControllerSourceType) option {
    switch (option) {
        case UIImagePickerControllerSourceTypeCamera:
            imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:NULL];
            break;
        case UIImagePickerControllerSourceTypePhotoLibrary:
            imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.delegate = self;
            [self presentViewController:imagePicker animated:YES completion:NULL];
            break;
        default:
            break;
    }
}

#pragma mark - Loading & Saving images
- (NSMutableArray*)getImages {
    NSMutableArray *images = [[NSMutableArray alloc] init];
    images = [[NSMutableArray alloc]init];
    NSError *error = nil;
    NSString *stringPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)objectAtIndex:0];
    NSArray *filePathsArray = [[NSFileManager defaultManager] subpathsOfDirectoryAtPath: stringPath  error:&error];
    for(int i=0;i<[filePathsArray count];i++)
    {
        NSString *strFilePath = [filePathsArray objectAtIndex:i];
        if ([[strFilePath pathExtension] isEqualToString:@"jpg"] || [[strFilePath pathExtension] isEqualToString:@"png"] || [[strFilePath pathExtension] isEqualToString:@"PNG"])
        {
            NSString *imagePath = [[stringPath stringByAppendingString:@"/"] stringByAppendingString:strFilePath];
            NSData *data = [NSData dataWithContentsOfFile:imagePath];
            if(data)
            {
                UIImage *image = [UIImage imageWithData:data];
                [images addObject:image];
            }
        }
    }
    return images;
}

- (void)saveImage:(UIImage*) image {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *guid = [[NSUUID new] UUIDString];
    NSString *uniqueFileName = [NSString stringWithFormat:@"%@.png", guid];
    NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:uniqueFileName];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:savedImagePath atomically:NO];
}

#pragma mark FSPagerViewDelegate methods
- (FSPagerViewCell *)pagerView:(FSPagerView *)pagerView cellForItemAtIndex:(NSInteger)index
{
    FSPagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"cell" atIndex:index];
    cell.imageView.image = images[index];
    return cell;
}

- (NSInteger)numberOfItemsInPagerView:(FSPagerView * _Nonnull)pagerView {
    if (images.count != 0) {
        [self.emptyContentView setHidden:YES];
        [self.pagerImage setHidden:NO];
        return images.count;
    } else {
        [self.pagerImage setHidden:YES];
        [self.emptyContentView setHidden:NO];
        return 0;
    }
}


#pragma mark Image Editing Delegate
-(void)endImageEditing:(UIImage*) image {
    [self saveImage:image];
    images = [self getImages];
    [[self pagerImage] reloadData];
}

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    
}

- (void)traitCollectionDidChange:(nullable UITraitCollection *)previousTraitCollection {
    
}

- (void)preferredContentSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}

- (void)systemLayoutFittingSizeDidChangeForChildContentContainer:(nonnull id<UIContentContainer>)container {
    
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    
}

- (void)willTransitionToTraitCollection:(nonnull UITraitCollection *)newCollection withTransitionCoordinator:(nonnull id<UIViewControllerTransitionCoordinator>)coordinator {
    
}

- (void)didUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context withAnimationCoordinator:(nonnull UIFocusAnimationCoordinator *)coordinator {
    
}

- (void)setNeedsFocusUpdate {
    
}

- (BOOL)shouldUpdateFocusInContext:(nonnull UIFocusUpdateContext *)context {
    return NO;
}

- (void)updateFocusIfNeeded {
    
}

@end
