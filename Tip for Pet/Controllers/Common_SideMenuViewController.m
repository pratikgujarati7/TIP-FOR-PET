//
//  Common_SideMenuViewController.m
//  SetMyPace
//
//  Created by Pratik Gujarati on 28/01/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "Common_SideMenuViewController.h"
#import "MySingleton.h"

#import "IQKeyboardManager.h"

#import "SideBarTableViewCell.h"

#import "User_RegistrationViewController.h"
#import "User_LoginViewController.h"
#import "User_HomeViewController.h"
#import "User_MyProfileViewController.h"
#import "User_MyPetsListViewController.h"
#import "User_PetCareReminderListViewController.h"

@interface Common_SideMenuViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}

@end

@implementation Common_SideMenuViewController

//========== IBOUTLETS ==========//

@synthesize mainScrollView;
@synthesize mainContainerView;

@synthesize mainImageViewBackground;
@synthesize mainTableViewContainerScrollView;
@synthesize mainTableView;

//========== OTHER VARIABLES ==========//

#pragma mark - View Controller Delegate Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupInitialView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNotificationEvent];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:true];
    [[IQKeyboardManager sharedManager] setEnable:true];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    [self removeNotificationEventObserver];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layout Subviews Methods

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    CGSize mainTableViewViewContentSize = mainTableView.contentSize;
    
    if(mainTableViewViewContentSize.height > ([MySingleton sharedManager].screenHeight - 20))
    {
        NSLog(@"side menu table view is bigger");
        
        mainTableViewContainerScrollView.contentSize = CGSizeMake(mainTableViewContainerScrollView.frame.size.width, mainTableViewViewContentSize.height);
        
        CGRect mainTableViewFrame = mainTableView.frame;
        mainTableViewFrame.size.height = mainTableViewViewContentSize.height;
        mainTableView.frame = mainTableViewFrame;
    }
}

#pragma mark - Setup Notification Methods

-(void)setupNotificationEvent
{
    if(boolIsSetupNotificationEventCalledOnce == false)
    {
        boolIsSetupNotificationEventCalledOnce = true;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_loggedoutEvent) name:@"user_loggedoutEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)user_loggedoutEvent
{
//    dispatch_async(dispatch_get_main_queue(), ^{
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs removeObjectForKey:@"autologin"];
        [prefs removeObjectForKey:@"userid"];
        [prefs removeObjectForKey:@"useremail"];
        [prefs removeObjectForKey:@"username"];
        [prefs synchronize];
    
    User_LoginViewController *viewController;
    
    viewController = [[User_LoginViewController alloc] initWithNibName:@"User_LoginViewController" bundle:nil];
    
    /*
    if([MySingleton sharedManager].screenHeight == 812)
    {
        viewController = [[User_LoginViewController alloc] initWithNibName:@"User_LoginViewController_iPhone10" bundle:nil];
    }
    
    else
    {
        viewController = [[User_LoginViewController alloc] initWithNibName:@"User_LoginViewController" bundle:nil];
    }
    */
    
    [self.navigationController pushViewController:viewController animated:YES];
//    });
}


#pragma mark - UI Setup Method

- (void)setupInitialView
{
    if (@available(iOS 11.0, *))
    {
        mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    mainScrollView.delegate = self;
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    mainImageViewBackground.layer.masksToBounds = true;
    mainImageViewBackground.contentMode = UIViewContentModeScaleAspectFill;
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.backgroundColor = [UIColor clearColor];
    
    if([MySingleton sharedManager].screenHeight != 480)
    {
        mainTableView.scrollEnabled = false;
    }
}

#pragma mark - UITableViewController Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == mainTableView)
    {
        return 1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == mainTableView)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSString *strUserId = [prefs objectForKey:@"userid"];
        NSString *strAutoLogin = [prefs objectForKey:@"autologin"];
        
        if((strUserId != nil && strUserId.length > 0) && ([strAutoLogin isEqualToString:@"1"]))
        {
            NSLog(@"User Logged In.");
            
            return 6;
        }
        else
        {
            NSLog(@"User Not Logged In.");
            
            return 1;
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == mainTableView)
    {
        return 50;
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Cell";
    
    if(tableView == mainTableView)
    {
        SideBarTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        cell = [[SideBarTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSString *strUserId = [prefs objectForKey:@"userid"];
        NSString *strAutoLogin = [prefs objectForKey:@"autologin"];
        
        if((strUserId != nil && strUserId.length > 0) && ([strAutoLogin isEqualToString:@"1"]))
        {
            NSLog(@"User Logged In.");
            
            if(indexPath.row == 0)
            {
                cell.imageViewMain.image = [UIImage imageNamed:@"home.png"];
                cell.lblMain.text = @"Home";
            }
            else if(indexPath.row == 1)
            {
                cell.imageViewMain.image = [UIImage imageNamed:@"my_profile.png"];
                cell.lblMain.text = @"My Profile";
            }
            else if(indexPath.row == 2)
            {
                cell.imageViewMain.image = [UIImage imageNamed:@"my_pets.png"];
                cell.lblMain.text = @"My Pets";
            }
            else if(indexPath.row == 3)
            {
                cell.imageViewMain.image = [UIImage imageNamed:@"reminders.png"];
                cell.lblMain.text = @"Pet Care Reminders";
            }
            else if(indexPath.row == 4)
            {
                cell.imageViewMain.image = [UIImage imageNamed:@"share_with_friends.png"];
                cell.lblMain.text = @"Share with friends";
            }
            else if(indexPath.row == 5)
            {
                cell.imageViewMain.image = [UIImage imageNamed:@"logout.png"];
                cell.lblMain.text = @"Logout";
            }
        }
        else
        {
            NSLog(@"User Not Logged In.");
            
            if(indexPath.row == 0)
            {
                cell.imageViewMain.image = [UIImage imageNamed:@"home.png"];
                cell.lblMain.text = @"Register";
            }
        }
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:true];
    
    if(tableView == mainTableView)
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        NSString *strUserId = [prefs objectForKey:@"userid"];
        NSString *strAutoLogin = [prefs objectForKey:@"autologin"];
        
        if((strUserId != nil && strUserId.length > 0) && ([strAutoLogin isEqualToString:@"1"]))
        {
            NSLog(@"User Logged In.");
            
            if(indexPath.row == 0)
            {
                User_HomeViewController *contentViewController;
                
                contentViewController = [[User_HomeViewController alloc] initWithNibName:@"User_HomeViewController" bundle:nil];
                
                /*
                if([MySingleton sharedManager].screenHeight == 812)
                {
                    contentViewController = [[User_HomeViewController alloc] initWithNibName:@"User_HomeViewController_iPhone10" bundle:nil];
                }
                
                else
                {
                    contentViewController = [[User_HomeViewController alloc] initWithNibName:@"User_HomeViewController" bundle:nil];
                }
                */
                self.sideMenuController.rootViewController = contentViewController;
                [self.sideMenuController hideLeftViewAnimated:YES delay:0.0 completionHandler:nil];
            }
            else if(indexPath.row == 1)
            {
                User_MyProfileViewController *contentViewController;
                
                contentViewController = [[User_MyProfileViewController alloc] initWithNibName:@"User_MyProfileViewController" bundle:nil];
                
                /*
                if([MySingleton sharedManager].screenHeight == 812)
                {
                    contentViewController = [[User_MyProfileViewController alloc] initWithNibName:@"User_MyProfileViewController_iPhone10" bundle:nil];
                }
                
                else
                {
                    contentViewController = [[User_MyProfileViewController alloc] initWithNibName:@"User_MyProfileViewController" bundle:nil];
                }
                */
                self.sideMenuController.rootViewController = contentViewController;
                [self.sideMenuController hideLeftViewAnimated:YES delay:0.0 completionHandler:nil];
            }
            else if(indexPath.row == 2)
            {
                User_MyPetsListViewController *contentViewController;
                
                contentViewController = [[User_MyPetsListViewController alloc] initWithNibName:@"User_MyPetsListViewController" bundle:nil];
                /*
                if([MySingleton sharedManager].screenHeight == 812)
                {
                    contentViewController = [[User_MyPetsListViewController alloc] initWithNibName:@"User_MyPetsListViewController_iPhone10" bundle:nil];
                }
                
                else
                {
                    contentViewController = [[User_MyPetsListViewController alloc] initWithNibName:@"User_MyPetsListViewController" bundle:nil];
                }
                */
                self.sideMenuController.rootViewController = contentViewController;
                [self.sideMenuController hideLeftViewAnimated:YES delay:0.0 completionHandler:nil];
            }
            else if(indexPath.row == 3)
            {
                User_PetCareReminderListViewController *contentViewController;
                
                contentViewController = [[User_PetCareReminderListViewController alloc] initWithNibName:@"User_PetCareReminderListViewController" bundle:nil];
                
                /*
                if([MySingleton sharedManager].screenHeight == 812)
                {
                    contentViewController = [[User_PetCareReminderListViewController alloc] initWithNibName:@"User_PetCareReminderListViewController_iPhone10" bundle:nil];
                }
                
                else
                {
                    contentViewController = [[User_PetCareReminderListViewController alloc] initWithNibName:@"User_PetCareReminderListViewController" bundle:nil];
                }
                */
                self.sideMenuController.rootViewController = contentViewController;
                [self.sideMenuController hideLeftViewAnimated:YES delay:0.0 completionHandler:nil];
            }
            else if(indexPath.row == 4)
            {
                NSString *textToShare = [NSString stringWithFormat:@"%@", [MySingleton sharedManager].strSocialMediaShareMessage];
                UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:textToShare, nil] applicationActivities:nil];
                [activityVC setValue:[NSString stringWithFormat:@"%@", [MySingleton sharedManager].strSocialMediaShareSubject] forKey:@"subject"];
                activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
                [self presentViewController:activityVC animated:YES completion:nil];
            }
            else if(indexPath.row == 5)
            {
                [self logout];
            }
        }
        else
        {
            NSLog(@"User Not Logged In.");
            
            if(indexPath.row == 0)
            {
                User_RegistrationViewController *viewController;
                
                viewController = [[User_RegistrationViewController alloc] initWithNibName:@"User_RegistrationViewController" bundle:nil];
                
                /*
                if([MySingleton sharedManager].screenHeight == 812)
                {
                    viewController = [[User_RegistrationViewController alloc] initWithNibName:@"User_RegistrationViewController_iPhone10" bundle:nil];
                }
                
                else
                {
                    viewController = [[User_RegistrationViewController alloc] initWithNibName:@"User_RegistrationViewController" bundle:nil];
                }
                */
                [self.navigationController pushViewController:viewController animated:YES];
            }
        }
    }
}

#pragma mark - Other Method

- (void)logout
{
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    alertViewController.title = @"";
    alertViewController.message = @"Are you sure you want to logout?";
    
    alertViewController.view.tintColor = [UIColor whiteColor];
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    alertViewController.transitionStyle = NYAlertViewControllerTransitionStyleFade;
    
    alertViewController.titleFont = [MySingleton sharedManager].alertViewTitleFont;
    alertViewController.messageFont = [MySingleton sharedManager].alertViewMessageFont;
    alertViewController.buttonTitleFont = [MySingleton sharedManager].alertViewButtonTitleFont;
    alertViewController.cancelButtonTitleFont = [MySingleton sharedManager].alertViewCancelButtonTitleFont;
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action){
        
        [alertViewController dismissViewControllerAnimated:YES completion:nil];
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [[MySingleton sharedManager].dataManager user_logout:[prefs objectForKey:@"userid"]];
    }]];
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(NYAlertAction *action){
        
        [alertViewController dismissViewControllerAnimated:YES completion:nil];
        
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertViewController animated:YES completion:nil];
    });
}

@end
