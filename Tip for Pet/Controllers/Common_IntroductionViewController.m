//
//  Common_IntroductionViewController.m
//  ENZYM
//
//  Created by Pratik Gujarati on 22/03/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "Common_IntroductionViewController.h"
#import "MySingleton.h"

#import "IQKeyboardManager.h"

#import "User_HomeViewController.h"

@interface Common_IntroductionViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
    
    int pageNumber;
    int numberOfPages;
}

@end

@implementation Common_IntroductionViewController

//========== IBOUTLETS ==========//

@synthesize mainScrollView;
@synthesize mainContainerView;

@synthesize imageViewMainLogo;

@synthesize AdvertisementScrollView;

@synthesize lblAdvertisementTitle1;
@synthesize lblAdvertisementDetails1;

@synthesize lblAdvertisementTitle2;
@synthesize lblAdvertisementDetails2;

@synthesize mainPageControl;

@synthesize lblSkip;
@synthesize btnSkip;

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
        
    AdvertisementScrollView.contentSize = CGSizeMake(AdvertisementScrollView.frame.size.width * numberOfPages, AdvertisementScrollView.frame.size.height);
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
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    UIFont *lblInspiringFeatureFont, *lblDetailsFont, *btnFont;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        lblInspiringFeatureFont = [MySingleton sharedManager].themeFontTwentyTwoSizeBold;
        lblDetailsFont = [MySingleton sharedManager].themeFontSixteenSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontTwentySixSizeMedium;
    }
    else
    {
        if([MySingleton sharedManager].screenHeight == 480)
        {
            lblInspiringFeatureFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
            lblDetailsFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontTwentyTwoSizeMedium;
        }
        else if([MySingleton sharedManager].screenHeight == 568)
        {
            lblInspiringFeatureFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
            lblDetailsFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontTwentyTwoSizeMedium;
        }
        else if([MySingleton sharedManager].screenHeight == 667)
        {
            lblInspiringFeatureFont = [MySingleton sharedManager].themeFontNineteenSizeBold;
            lblDetailsFont = [MySingleton sharedManager].themeFontFifteenSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontTwentyThreeSizeMedium;
        }
        else if([MySingleton sharedManager].screenHeight >= 736)
        {
            lblInspiringFeatureFont = [MySingleton sharedManager].themeFontTwentySizeBold;
            lblDetailsFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontTwentyFourSizeMedium;
        }
    }
    
    AdvertisementScrollView.backgroundColor = [MySingleton sharedManager].themeGlobalGreenColor;
    
    lblAdvertisementTitle1.font = lblInspiringFeatureFont;
    lblAdvertisementTitle1.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    lblAdvertisementTitle1.textBorderColor = [MySingleton sharedManager].themeGlobalDarkGreenColor;
    lblAdvertisementTitle1.floatBorderWidth = 3.0f;
    lblAdvertisementTitle1.text = [NSString stringWithFormat:@"Pet Care Advice"];
    
    lblAdvertisementDetails1.font = lblDetailsFont;
    lblAdvertisementDetails1.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    lblAdvertisementDetails1.text = [NSString stringWithFormat:@"You will find everything here you need to take care of your pet"];
    
    lblAdvertisementTitle2.font = lblInspiringFeatureFont;
    lblAdvertisementTitle2.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    lblAdvertisementTitle2.textBorderColor = [MySingleton sharedManager].themeGlobalDarkGreenColor;
    lblAdvertisementTitle2.floatBorderWidth = 3.0f;
    lblAdvertisementTitle2.text = [NSString stringWithFormat:@"Happy Pet Parenting"];
    
    lblAdvertisementDetails2.font = lblDetailsFont;
    lblAdvertisementDetails2.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    lblAdvertisementDetails2.text = [NSString stringWithFormat:@"We offer a vast range of advices and information which will help you to look after your pet"];
    
    lblSkip.font = btnFont;
    lblSkip.textColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    lblSkip.textBorderColor = [MySingleton sharedManager].themeGlobalDarkGreenColor;
    lblSkip.floatBorderWidth = 3.0f;
    lblSkip.text = @"EXPLORE NOW";
    
    [btnSkip addTarget:self action:@selector(btnSkipClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [self setUpSlider];
}

-(void)setUpSlider
{
    numberOfPages = 2;
    pageNumber = 0;
    
    mainPageControl.userInteractionEnabled = FALSE;
    mainPageControl.numberOfPages = numberOfPages;
    mainPageControl.currentPageIndicatorTintColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    mainPageControl.pageIndicatorTintColor = [MySingleton sharedManager].themeGlobalLightGreyColor;
    
    [AdvertisementScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    AdvertisementScrollView.delegate = self;
}

#pragma mark - UIScrollView Delegate Methods

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == AdvertisementScrollView)
    {
        int scrollEndPoint;
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            scrollEndPoint = [MySingleton sharedManager].screenWidth * (numberOfPages - 1);
        }
        else
        {
            if([MySingleton sharedManager].screenHeight == 480 || [MySingleton sharedManager].screenHeight == 568)
            {
                scrollEndPoint = [MySingleton sharedManager].screenWidth * (numberOfPages - 1);
            }
            else if([MySingleton sharedManager].screenHeight == 667)
            {
                scrollEndPoint = [MySingleton sharedManager].screenWidth * (numberOfPages - 1);
            }
            else if([MySingleton sharedManager].screenHeight >= 736)
            {
                scrollEndPoint = [MySingleton sharedManager].screenWidth * (numberOfPages - 1);
            }
        }
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == AdvertisementScrollView)
    {
        CGFloat pageWidth = AdvertisementScrollView.frame.size.width;
        
        float fractionalPage = AdvertisementScrollView.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        mainPageControl.currentPage = page;
        pageNumber = page;
        [mainPageControl reloadInputViews];
    }
}

#pragma mark - Other Method

- (void)btnSkipClicked
{
    [self.view endEditing:YES];
    
    User_HomeViewController *viewController;
    
    viewController = [[User_HomeViewController alloc] initWithNibName:@"User_HomeViewController" bundle:nil];
    
    /*
    if([MySingleton sharedManager].screenHeight >= 812)
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

@end
