//
//  ViewController.h
//  WeatherApp
//
//  Created by Sherif Kamal on 2/28/20.
//  Copyright © 2020 Sherif Kamal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ImageEditorController.h"
#import <CoreLocation/CoreLocation.h>
#import "FSPagerView-Swift.h"

@interface HistoryController : UIViewController <CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegateFlowLayout, EditImageDelegate, FSPagerViewDataSource, FSPagerViewDelegate>

@end

