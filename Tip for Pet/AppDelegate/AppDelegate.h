//
//  AppDelegate.h
//  ENZYM
//
//  Created by Pratik Gujarati on 24/05/17.
//  Copyright © 2017 accreteit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common_SplashViewController.h"
#import "MBProgressHUD.h"
#import "NYAlertViewController.h"

#import <Foundation/Foundation.h>
#import <UserNotifications/UserNotifications.h>

@import Firebase;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UNUserNotificationCenterDelegate, FIRMessagingDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) Common_SplashViewController *splashVC;
@property (strong, nonatomic) UINavigationController *navC;

-(void)showErrorAlertViewWithTitle:(NSString *)title withDetails:(NSString *)detail;

-(MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title;
-(void)dismissGlobalHUD;

-(BOOL)isClock24Hour;

@end

