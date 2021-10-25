//
//  Common_SplashViewController.m
//  HungerE
//
//  Created by Pratik Gujarati on 23/09/16.
//  Copyright © 2016 accereteinfotech. All rights reserved.
//

#import "Common_SplashViewController.h"
#import "MySingleton.h"

#import "IQKeyboardManager.h"

#import "Common_IntroductionViewController.h"
#import "User_HomeViewController.h"
#import "User_RegistrationViewController.h"

@interface Common_SplashViewController ()
{
    AppDelegate *appDelegate;
    BOOL boolIsRedirected;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
    
    BOOL boolIsExecuteRedirectionCalledOnce;
}

@end

@implementation Common_SplashViewController

//========== IBOUTLETS ==========//

@synthesize mainScrollView;

@synthesize mainContainerView;

@synthesize mainSplashBackgroundImageView;
@synthesize mainLogoImageView;
@synthesize lblMain;

//========== OTHER VARIABLES ==========//

#pragma mark - View Controller Delegate Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNotificationEvent];
    
    [self setupInitialView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNotificationEvent];
    
    [[self navigationController] setNavigationBarHidden:YES animated:NO];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:false];
    [[IQKeyboardManager sharedManager] setEnable:false];
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
}

#pragma mark - Setup Notification Methods

-(void)setupNotificationEvent
{
    if(boolIsSetupNotificationEventCalledOnce == false)
    {
        boolIsSetupNotificationEventCalledOnce = true;
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
    
    mainSplashBackgroundImageView.layer.masksToBounds = true;
    
    mainLogoImageView.layer.masksToBounds = true;
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIFont *lblMainFont;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        lblMainFont = [MySingleton sharedManager].themeFontTwentyTwoSizeBold;
    }
    else
    {
        if([MySingleton sharedManager].screenHeight == 480)
        {
            lblMainFont = [MySingleton sharedManager].themeFontFourtyFourSizeBold;
        }
        else if([MySingleton sharedManager].screenHeight == 568)
        {
            lblMainFont = [MySingleton sharedManager].themeFontFourtyFourSizeBold;
        }
        else if([MySingleton sharedManager].screenHeight == 667)
        {
            lblMainFont = [MySingleton sharedManager].themeFontNineteenSizeBold;
        }
        else if([MySingleton sharedManager].screenHeight >= 736)
        {
            lblMainFont = [MySingleton sharedManager].themeFontTwentySizeBold;
        }
    }
    
    lblMain.font = lblMainFont;
    lblMain.textColor = [MySingleton sharedManager].themeGlobalGreenColor;
    lblMain.layer.borderColor = [MySingleton sharedManager].themeGlobalGreenColor.CGColor;
    lblMain.layer.borderWidth = 3.0;
    lblMain.textBorderColor = [MySingleton sharedManager].themeGlobalDarkGreenColor;
    lblMain.floatBorderWidth = 3.0f;
    
    [self executeRedirection];
}

-(void)executeRedirection
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if(![[prefs objectForKey:@"isAppLoadedForFirstTime"] isEqualToString:@"1"])
    {
        //========== APPLICATION IS OPENED FOR THE FIRST TIME ==========//
        dispatch_async(dispatch_get_main_queue(), ^{
            [prefs setObject:@"1" forKey:@"isAppLoadedForFirstTime"];
            [prefs synchronize];
            
            boolIsRedirected = TRUE;
            
            [self performSelector:@selector(navigateToIntroductionScreen) withObject:self afterDelay:1.0];
        });
    }
    else
    {
        NSString *strLoginSkipped = [prefs objectForKey:@"loginskipped"];
        NSString *strUserId = [prefs objectForKey:@"userid"];
        NSString *strAutoLogin = [prefs objectForKey:@"autologin"];
        
        if([strLoginSkipped isEqualToString:@"1"])
        {
            boolIsRedirected = TRUE;
            
            [self performSelector:@selector(navigateToUserHomeViewController) withObject:self afterDelay:1.0];
        }
        else if((strUserId != nil && strUserId.length > 0) && ([strAutoLogin isEqualToString:@"1"]))
        {
            boolIsRedirected = TRUE;
            
            [self performSelector:@selector(navigateToUserHomeViewController) withObject:self afterDelay:1.0];
        }
        else
        {
            boolIsRedirected = TRUE;
            
            [self performSelector:@selector(navigateToRegistrationScreen) withObject:self afterDelay:1.0];
        }
    }
}

#pragma mark - Other Method

- (void)navigateToIntroductionScreen
{
    [self.view endEditing:true];
    
    Common_IntroductionViewController *viewController;
    
    viewController = [[Common_IntroductionViewController alloc] initWithNibName:@"Common_IntroductionViewController" bundle:nil];
    
    /*
    if([MySingleton sharedManager].screenHeight == 812)
    {
        viewController = [[Common_IntroductionViewController alloc] initWithNibName:@"Common_IntroductionViewController_iPhone10" bundle:nil];
    }
    else
    {
        viewController = [[Common_IntroductionViewController alloc] initWithNibName:@"Common_IntroductionViewController" bundle:nil];
    }
    */

    
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)navigateToUserHomeViewController
{
    [self.view endEditing:true];
    
    User_HomeViewController *viewController;
    
    viewController = [[User_HomeViewController alloc] initWithNibName:@"User_HomeViewController" bundle:nil];
    
    /*
    if([MySingleton sharedManager].screenHeight == 812)
    {
        viewController = [[User_HomeViewController alloc] initWithNibName:@"User_HomeViewController_iPhone10" bundle:nil];
    }
    else
    {
        viewController = [[User_HomeViewController alloc] initWithNibName:@"User_HomeViewController" bundle:nil];
    }
    */

    Common_SideMenuViewController *common_SideMenuViewController;
    common_SideMenuViewController = [[Common_SideMenuViewController alloc] init];
    
    /*
    if([MySingleton sharedManager].screenHeight == 568)
    {
        common_SideMenuViewController = [[Common_SideMenuViewController alloc] init];
    }
    else if([MySingleton sharedManager].screenHeight == 667)
    {
        common_SideMenuViewController = [[Common_SideMenuViewController alloc] initWithNibName:@"Common_SideMenuViewController_iPhone6" bundle:nil];
    }
    else if([MySingleton sharedManager].screenHeight == 736)
    {
        common_SideMenuViewController = [[Common_SideMenuViewController alloc] initWithNibName:@"Common_SideMenuViewController_iPhone6Plus" bundle:nil];
    }
    else if([MySingleton sharedManager].screenHeight == 812)
    {
        common_SideMenuViewController = [[Common_SideMenuViewController alloc] initWithNibName:@"Common_SideMenuViewController_iPhone10" bundle:nil];
    }
    else
    {
        common_SideMenuViewController = [[Common_SideMenuViewController alloc] initWithNibName:@"Common_SideMenuViewController_iPhone6Plus" bundle:nil];
    }
    */
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    
    LGSideMenuController *sideMenuController = [LGSideMenuController sideMenuControllerWithRootViewController:navigationController
                                                                                           leftViewController:common_SideMenuViewController
                                                                                          rightViewController:nil];
    
    sideMenuController.leftViewWidth = [MySingleton sharedManager].floatLeftSideMenuWidth;
    sideMenuController.leftViewPresentationStyle = [MySingleton sharedManager].leftViewPresentationStyle;
    
    sideMenuController.rightViewWidth = [MySingleton sharedManager].floatRightSideMenuWidth;
    sideMenuController.rightViewPresentationStyle = [MySingleton sharedManager].rightViewPresentationStyle;
    
    [self.navigationController pushViewController:sideMenuController animated:YES];
}

- (void)navigateToRegistrationScreen
{
    [self.view endEditing:true];
    
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

@end
