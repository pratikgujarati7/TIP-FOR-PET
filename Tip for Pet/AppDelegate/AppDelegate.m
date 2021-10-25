//
//  AppDelegate.m
//  ENZYM
//
//  Created by Pratik Gujarati on 24/05/17.
//  Copyright © 2017 accreteit. All rights reserved.
//

#import "AppDelegate.h"
#import "MySingleton.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

NSString *const kGCMMessageIDKey = @"gcm.message_id";

@synthesize splashVC,navC;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        UNAuthorizationOptions authOptions =
        UNAuthorizationOptionAlert
        | UNAuthorizationOptionSound
        | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
#endif
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    [FIRApp configure];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:) name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
    /*
    if (@available(iOS 14, *)) {
          UIDatePicker *picker = [UIDatePicker appearance];
        picker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    */
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.splashVC = [[Common_SplashViewController alloc] init];
    self.navC = [[UINavigationController alloc]initWithRootViewController:self.splashVC];
    self.window.rootViewController = self.navC;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    [self.window endEditing:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"applicationDidEnterBackground" object:nil];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    [self connectToFcm];
    
    application.applicationIconBadgeNumber = 0;
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Firebase Push Notification Methods

- (void)tokenRefreshNotification:(NSNotification *)notification
{
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    
    NSString *strDeviceToken = refreshedToken;
//    NSString *strDeviceToken = [[[deviceToken description]
//                                     stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
//                                    stringByReplacingOccurrencesOfString:@" "
//                                    withString:@""];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:strDeviceToken forKey:@"deviceToken"];
        [prefs synchronize];
    });
    
    // Connect to FCM since connection may have failed when attempted before having a token.
    [self connectToFcm];
    
    // TODO: If necessary send token to application server.
}

- (void)connectToFcm
{
    [[FIRMessaging messaging] connectWithCompletion:^(NSError * _Nullable error) {
        if (error != nil) {
            NSLog(@"Unable to connect to FCM. %@", error);
        } else {
            NSLog(@"Connected to FCM.");
        }
    }];
}

- (void)messaging:(nonnull FIRMessaging *)messaging didRefreshRegistrationToken:(nonnull NSString *)fcmToken
{
    // Note that this callback will be fired everytime a new token is generated, including the first
    // time. So if you need to retrieve the token as soon as it is available this is where that
    // should be done.
    NSLog(@"FCM registration token: %@", fcmToken);
    
    NSString *strDeviceToken = fcmToken;
//    NSString *strDeviceToken = [[[deviceToken description]
//                                 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
//                                stringByReplacingOccurrencesOfString:@" "
//                                withString:@""];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:strDeviceToken forKey:@"deviceToken"];
        [prefs synchronize];
    });
    
    // TODO: If necessary send token to application server.
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error
{
    NSLog(@"Unable to register for remote notifications: %@", error);
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:@"" forKey:@"deviceToken"];
        [prefs synchronize];
    });
}

// This function is added here only for debugging purposes, and can be removed if swizzling is enabled.
// If swizzling is disabled then this function must be implemented so that the APNs token can be paired to
// the InstanceID token.
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSLog(@"APNs token retrieved: %@", deviceToken);
    
    NSString *strDeviceToken = [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding];
//    NSString *strDeviceToken = [[[deviceToken description]
//                                 stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]]
//                                stringByReplacingOccurrencesOfString:@" "
//                                withString:@""];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:strDeviceToken forKey:@"deviceToken"];
        [prefs synchronize];
    });
    
    // With swizzling disabled you must set the APNs token here.
// [[FIRInstanceID instanceID] setAPNSToken:deviceToken type:FIRInstanceIDAPNSTokenTypeSandbox];
}

#pragma mark - Methods to handle push notifications when the app is in foreground or when user taps on push notification (These methods are for iOS 9 and previous versions)

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[Messaging messaging] appDidReceiveMessage:userInfo];
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    UIApplicationState state = [application applicationState];
    
    if (state == UIApplicationStateActive)
    {
        NSString *strNotificationTitle, *strNotificationText;
        
        if([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] isKindOfClass:[NSDictionary class]])
        {
            if([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"title"])
            {
                strNotificationTitle = [[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"title"];
            }
            else
            {
                strNotificationTitle = @"";
            }
            
            if([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"])
            {
                strNotificationText = [[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"body"];
            }
            else
            {
                strNotificationText = @"";
            }
        }
        else
        {
            strNotificationText = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"] ;
        }
        
        NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
        alertViewController.title = strNotificationTitle;
        alertViewController.message = strNotificationText;
        
        alertViewController.view.tintColor = [UIColor whiteColor];
        alertViewController.backgroundTapDismissalGestureEnabled = YES;
        alertViewController.swipeDismissalGestureEnabled = YES;
        alertViewController.transitionStyle = NYAlertViewControllerTransitionStyleFade;
        
        alertViewController.titleFont = [MySingleton sharedManager].alertViewTitleFont;
        alertViewController.messageFont = [MySingleton sharedManager].alertViewMessageFont;
        alertViewController.buttonTitleFont = [MySingleton sharedManager].alertViewButtonTitleFont;
        alertViewController.cancelButtonTitleFont = [MySingleton sharedManager].alertViewCancelButtonTitleFont;
        
        [alertViewController addAction:[NYAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action){
            [alertViewController dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertViewController animated:YES completion:nil];
    }
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    // If you are receiving a notification message while your app is in the background,
    // this callback will not be fired till the user taps on the notification launching the application.
    // TODO: Handle data of notification
    
    // With swizzling disabled you must let Messaging know about the message, for Analytics
    // [[Messaging messaging] appDidReceiveMessage:userInfo];
    
    // Print message ID.
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    UIApplicationState state = [application applicationState];
    
    if (state == UIApplicationStateActive)
    {
        NSString *strNotificationTitle, *strNotificationText;
        
        if([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] isKindOfClass:[NSDictionary class]])
        {
            if([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"title"])
            {
                strNotificationTitle = [[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"title"];
            }
            else
            {
                strNotificationTitle = @"";
            }
            
            if([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"])
            {
                strNotificationText = [[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"body"];
            }
            else
            {
                strNotificationText = @"";
            }
        }
        else
        {
            strNotificationText = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"] ;
        }
        
        NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
        alertViewController.title = strNotificationTitle;
        alertViewController.message = strNotificationText;
        
        alertViewController.view.tintColor = [UIColor whiteColor];
        alertViewController.backgroundTapDismissalGestureEnabled = YES;
        alertViewController.swipeDismissalGestureEnabled = YES;
        alertViewController.transitionStyle = NYAlertViewControllerTransitionStyleFade;
        
        alertViewController.titleFont = [MySingleton sharedManager].alertViewTitleFont;
        alertViewController.messageFont = [MySingleton sharedManager].alertViewMessageFont;
        alertViewController.buttonTitleFont = [MySingleton sharedManager].alertViewButtonTitleFont;
        alertViewController.cancelButtonTitleFont = [MySingleton sharedManager].alertViewCancelButtonTitleFont;
        
        [alertViewController addAction:[NYAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action){
            [alertViewController dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertViewController animated:YES completion:nil];
    }
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#pragma mark - Methods to handle push notifications when the app is in foreground or when user taps on push notification (These methods are for iOS 10 and later versions)

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Handle incoming notification messages while app is in the foreground.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    // Print message ID.
    NSDictionary *userInfo = notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
    NSString *strNotificationTitle, *strNotificationText;
    
    if([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] isKindOfClass:[NSDictionary class]])
    {
        if([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"title"])
        {
            strNotificationTitle = [[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"title"];
        }
        else
        {
            strNotificationTitle = @"";
        }
        
        if([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"])
        {
            strNotificationText = [[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"body"];
        }
        else
        {
            strNotificationText = @"";
        }
    }
    else
    {
        strNotificationText = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"] ;
    }
    
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    alertViewController.title = strNotificationTitle;
    alertViewController.message = strNotificationText;
    
    alertViewController.view.tintColor = [UIColor whiteColor];
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    alertViewController.transitionStyle = NYAlertViewControllerTransitionStyleFade;
    
    alertViewController.titleFont = [MySingleton sharedManager].alertViewTitleFont;
    alertViewController.messageFont = [MySingleton sharedManager].alertViewMessageFont;
    alertViewController.buttonTitleFont = [MySingleton sharedManager].alertViewButtonTitleFont;
    alertViewController.cancelButtonTitleFont = [MySingleton sharedManager].alertViewCancelButtonTitleFont;
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action){
        [alertViewController dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertViewController animated:YES completion:nil];
}

// Handle notification messages after display notification is tapped by the user.
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    // Print full message.
    NSLog(@"%@", userInfo);
    
//    NSString *strNotificationTitle, *strNotificationText;
//    
//    if([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] isKindOfClass:[NSDictionary class]])
//    {
//        if([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"title"])
//        {
//            strNotificationTitle = [[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"title"];
//        }
//        else
//        {
//            strNotificationTitle = @"";
//        }
//        
//        if([[[userInfo objectForKey:@"aps"] objectForKey:@"alert"] objectForKey:@"body"])
//        {
//            strNotificationText = [[[userInfo valueForKey:@"aps"] valueForKey:@"alert"] valueForKey:@"body"];
//        }
//        else
//        {
//            strNotificationText = @"";
//        }
//    }
//    else
//    {
//        strNotificationText = [[userInfo valueForKey:@"aps"] valueForKey:@"alert"] ;
//    }
//    
//    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
//    alertViewController.title = strNotificationTitle;
//    alertViewController.message = strNotificationText;
//    
//    alertViewController.view.tintColor = [UIColor whiteColor];
//    alertViewController.backgroundTapDismissalGestureEnabled = YES;
//    alertViewController.swipeDismissalGestureEnabled = YES;
//    alertViewController.transitionStyle = NYAlertViewControllerTransitionStyleFade;
//    
//    alertViewController.titleFont = [MySingleton sharedManager].alertViewTitleFont;
//    alertViewController.messageFont = [MySingleton sharedManager].alertViewMessageFont;
//    alertViewController.buttonTitleFont = [MySingleton sharedManager].alertViewButtonTitleFont;
//    alertViewController.cancelButtonTitleFont = [MySingleton sharedManager].alertViewCancelButtonTitleFont;
//    
//    [alertViewController addAction:[NYAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action){
//        [alertViewController dismissViewControllerAnimated:YES completion:nil];
//    }]];
//    
//    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertViewController animated:YES completion:nil];
}

#endif
// [END ios_10_message_handling]


// [START ios_10_data_message_handling]
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
// Receive data message on iOS 10 devices while app is in the foreground.
- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    // Print full message
    NSLog(@"%@", [remoteMessage appData]);
}
#endif
// [END ios_10_data_message_handling]

#pragma mark - Other Methods

-(MBProgressHUD *)showGlobalProgressHUDWithTitle:(NSString *)title
{
    [self dismissGlobalHUD];
    UIWindow *window = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    hud.label.text = title;
    hud.dimBackground = YES;
    return hud;
}

-(void)dismissGlobalHUD
{
    UIWindow *window = [(AppDelegate *)[[UIApplication sharedApplication] delegate] window];
    [MBProgressHUD hideHUDForView:window animated:YES];
}

//=========================FUNCTION TO SHOW THE HHAlertView ========================//

-(void)showErrorAlertViewWithTitle:(NSString *)title withDetails:(NSString *)detail
{
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    alertViewController.title = title;
    alertViewController.message = detail;
    
    alertViewController.view.tintColor = [UIColor whiteColor];
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    alertViewController.transitionStyle = NYAlertViewControllerTransitionStyleFade;
    
    alertViewController.titleFont = [MySingleton sharedManager].alertViewTitleFont;
    alertViewController.messageFont = [MySingleton sharedManager].alertViewMessageFont;
    alertViewController.buttonTitleFont = [MySingleton sharedManager].alertViewButtonTitleFont;
    alertViewController.cancelButtonTitleFont = [MySingleton sharedManager].alertViewCancelButtonTitleFont;
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action){
        
        [alertViewController dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertViewController animated:YES completion:nil];
    });
}

-(BOOL)isClock24Hour
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setDateStyle:NSDateFormatterNoStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSRange amRange = [dateString rangeOfString:[formatter AMSymbol]];
    NSRange pmRange = [dateString rangeOfString:[formatter PMSymbol]];
    BOOL is24h = (amRange.location == NSNotFound && pmRange.location == NSNotFound);
    
    return is24h;
}

@end
