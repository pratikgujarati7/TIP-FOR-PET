//
//  Common_SplashViewController.h
//  HungerE
//
//  Created by Pratik Gujarati on 23/09/16.
//  Copyright © 2016 accereteinfotech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomLabel.h"

#define IS_OS_8_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)

@interface Common_SplashViewController : UIViewController<UIScrollViewDelegate>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIView *mainContainerView;

@property (nonatomic,retain) IBOutlet UIImageView *mainSplashBackgroundImageView;
@property (nonatomic,retain) IBOutlet UIImageView *mainLogoImageView;
@property (nonatomic,retain) IBOutlet CustomLabel *lblMain;

//========== OTHER VARIABLES ==========//
@end
