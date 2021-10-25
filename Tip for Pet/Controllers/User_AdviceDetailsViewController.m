//
//  User_AdviceDetailsViewController.m
//  Tip for Pet
//
//  Created by Pratik Gujarati on 29/07/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "User_AdviceDetailsViewController.h"
#import "MySingleton.h"

#import "IQKeyboardManager.h"

#import "AsyncImageView.h"

@interface User_AdviceDetailsViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
    
    NSTimer *advertisementTimer;
    int pageNumber;
    int numberOfPages;
    
    int pageNumberAdvertisementDetails;
    int numberOfPagesAdvertisementDetails;
}

@end

@implementation User_AdviceDetailsViewController

//========== IBOUTLETS ==========//

@synthesize mainScrollView;

@synthesize navigationBarView;
@synthesize imageViewBack;
@synthesize btnBack;
@synthesize lblNavigationTitle;
@synthesize imageViewShare;
@synthesize btnShare;

@synthesize mainContainerView;

@synthesize advertisementScrollView;
@synthesize mainPageControl;

@synthesize lblAdviceTitle;
@synthesize lblAdviceDetails;

//========== OTHER VARIABLES ==========//

#pragma mark - View Controller Delegate Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNotificationEvent];
    
    [self setNavigationBar];
    [self setupInitialView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNotificationEvent];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:true];
    [[IQKeyboardManager sharedManager] setEnable:true];
    
    numberOfPages = self.objSelectedAdvice.arrayAdviceImageUrls.count;
    advertisementScrollView.contentSize = CGSizeMake(advertisementScrollView.frame.size.width * numberOfPages, advertisementScrollView.frame.size.height);
    
    [self setUpAdvertisementSlider];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    [self removeNotificationEventObserver];
    
    [advertisementTimer invalidate];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layout Subviews Methods

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    lblAdviceTitle.text = self.objSelectedAdvice.strAdviceTitle;
    [lblAdviceTitle sizeToFit];
    
    lblAdviceDetails.text = self.objSelectedAdvice.strAdviceText;
    [lblAdviceDetails sizeToFit];
    
    CGFloat lblAdviceTitleHeight;
    
    CGRect lblAdviceTitleTextRect = [lblAdviceTitle.text boundingRectWithSize:lblAdviceTitle.frame.size
                                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                                   attributes:@{NSFontAttributeName:lblAdviceTitle.font}
                                                                      context:nil];
    
    CGSize lblAdviceTitleSize = lblAdviceTitleTextRect.size;
    
    lblAdviceTitleHeight = lblAdviceTitleSize.height;
    
    
    CGFloat lblAdviceDetailsHeight;
    
    CGRect lblAdviceDetailsTextRect = [lblAdviceDetails.text boundingRectWithSize:lblAdviceDetails.frame.size
                                                                          options:NSStringDrawingUsesLineFragmentOrigin
                                                                       attributes:@{NSFontAttributeName:lblAdviceDetails.font}
                                                                          context:nil];
    
    CGSize lblAdviceDetailsSize = lblAdviceDetailsTextRect.size;
    
    lblAdviceDetailsHeight = lblAdviceDetailsSize.height;
    
    
    CGRect lblAdviceTitleFrame = lblAdviceTitle.frame;
    lblAdviceTitleFrame.size.height = lblAdviceTitleHeight;
    lblAdviceTitle.frame = lblAdviceTitleFrame;
    
    CGRect lblAdviceDetailsFrame = lblAdviceDetails.frame;
    lblAdviceDetailsFrame.origin.y = lblAdviceTitle.frame.origin.y + lblAdviceTitleHeight + 20;
    lblAdviceDetailsFrame.size.height = lblAdviceDetailsHeight;
    lblAdviceDetails.frame = lblAdviceDetailsFrame;
    
    mainContainerView.autoresizesSubviews = false;
    
    CGRect mainContainerViewFrame = mainContainerView.frame;
    mainContainerViewFrame.size.height = lblAdviceDetails.frame.origin.y + lblAdviceDetailsHeight + 20;
    mainContainerView.frame = mainContainerViewFrame;
    
    mainContainerView.autoresizesSubviews = true;
    
    mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, (mainContainerView.frame.origin.y + mainContainerView.frame.size.height));
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

#pragma mark - Navigation Bar Methods

-(void)setNavigationBar
{
    navigationBarView.backgroundColor = [MySingleton sharedManager].navigationBarBackgroundColor;
    
    imageViewBack.layer.masksToBounds = YES;
    [btnBack addTarget:self action:@selector(btnBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    imageViewShare.layer.masksToBounds = YES;
    [btnShare addTarget:self action:@selector(btnShareClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    lblNavigationTitle.text = [NSString stringWithFormat:@"DETAILS"];
    lblNavigationTitle.textColor = [MySingleton sharedManager].navigationBarTitleColor;
    lblNavigationTitle.font = [MySingleton sharedManager].navigationBarTitleFont;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(lblNavigationTitle.text.length > 32)
        {
            lblNavigationTitle.font = [MySingleton sharedManager].navigationBarTitleSmallFont;
        }
    }
    else
    {
        if(([MySingleton sharedManager].screenHeight == 480 || [MySingleton sharedManager].screenHeight == 568) && lblNavigationTitle.text.length > 18)
        {
            lblNavigationTitle.font = [MySingleton sharedManager].navigationBarTitleSmallFont;
        }
        else if([MySingleton sharedManager].screenHeight == 667 && lblNavigationTitle.text.length > 20)
        {
            lblNavigationTitle.font = [MySingleton sharedManager].navigationBarTitleSmallFont;
        }
        else if([MySingleton sharedManager].screenHeight >= 736 && lblNavigationTitle.text.length > 22)
        {
            lblNavigationTitle.font = [MySingleton sharedManager].navigationBarTitleSmallFont;
        }
    }
}

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnShareClicked:(id)sender
{
    [self.view endEditing:YES];
    
    NSString *strShareMessage = [NSString stringWithFormat:@"%@.\n\n%@.\n\nClick on the following link to download TIP FOR PET for iOS : %@", self.objSelectedAdvice.strAdviceTitle, self.objSelectedAdvice.strAdviceText, [MySingleton sharedManager].striOSAppUrlForUsers];
    
//    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:[MySingleton sharedManager].strSocialMediaShareContent, nil] applicationActivities:nil];
    UIActivityViewController *activityVC = [[UIActivityViewController alloc] initWithActivityItems:[NSArray arrayWithObjects:strShareMessage, nil] applicationActivities:nil];
    [activityVC setValue:[MySingleton sharedManager].strSocialMediaShareSubject forKey:@"subject"];
    activityVC.excludedActivityTypes = @[UIActivityTypePrint, UIActivityTypeCopyToPasteboard, UIActivityTypeAssignToContact, UIActivityTypeSaveToCameraRoll];
    [activityVC setCompletionHandler:^(NSString *act, BOOL done)
     {
         NSLog(@"act type %@",act);
         
         NSString *ServiceMsg = nil;
         if ( [act isEqualToString:UIActivityTypeMail] )
             ServiceMsg = @"Email Sent";
         if ( [act isEqualToString:UIActivityTypePostToTwitter] )
             ServiceMsg = @"Shared on Twitter!";
         if ( [act isEqualToString:UIActivityTypePostToFacebook] )
             ServiceMsg = @"Shared on Facebook!";
         
         if(done)
         {
             NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
             alertViewController.title = @"";
             alertViewController.message = @"You have shared this content on social media successfully.";
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
                 
                 [self dismissViewControllerAnimated:YES completion:nil];
             }]];
             
             dispatch_async(dispatch_get_main_queue(), ^{
                 [self presentViewController:alertViewController animated:YES completion:nil];
             });
         }
         else
         {
             // didn't succeed.
         }
     }];
    [self presentViewController:activityVC animated:YES completion:nil];
}

#pragma mark - UI Setup Method

- (void)setupInitialView
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    mainScrollView.delegate = self;
    
    if (@available(iOS 11.0, *))
    {
        mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    UIFont *lblAdviceTitleFont, *lblAdviceDetailsFont;
    
    if([MySingleton sharedManager].screenHeight == 480)
    {
        lblAdviceTitleFont = [MySingleton sharedManager].themeFontTwentySizeBold;
        lblAdviceDetailsFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
    }
    else if([MySingleton sharedManager].screenHeight == 568)
    {
        lblAdviceTitleFont = [MySingleton sharedManager].themeFontTwentySizeBold;
        lblAdviceDetailsFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
    }
    else if([MySingleton sharedManager].screenHeight == 667)
    {
        lblAdviceTitleFont = [MySingleton sharedManager].themeFontTwentyOneSizeBold;
        lblAdviceDetailsFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
    }
    else
    {
        lblAdviceTitleFont = [MySingleton sharedManager].themeFontTwentyTwoSizeBold;
        lblAdviceDetailsFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
    }

    lblAdviceTitle.text = self.objSelectedAdvice.strAdviceTitle;
    lblAdviceTitle.font = lblAdviceTitleFont;
    lblAdviceTitle.textColor = [MySingleton sharedManager].themeGlobalDarkGreenColor;
    lblAdviceTitle.numberOfLines = 0;
    
    
    lblAdviceDetails.text = self.objSelectedAdvice.strAdviceText;
    lblAdviceDetails.font = lblAdviceDetailsFont;
    lblAdviceDetails.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
    lblAdviceDetails.numberOfLines = 0;
}

#pragma mark - Slider Methods

-(void)advertisementTimerMethod:(NSTimer *)timer
{
    CGFloat pageWidth = advertisementScrollView.frame.size.width;
    
    pageNumber++;
    
    if(pageNumber > (numberOfPages - 1))
    {
        pageNumber = 0;
    }
    
    float fractionalPage = pageNumber;
    NSInteger page = lround(fractionalPage);
    mainPageControl.currentPage = page;
    [mainPageControl reloadInputViews];
    
    if(pageNumber == 0)
    {
        [advertisementScrollView setContentOffset:CGPointMake((pageWidth * pageNumber), 0) animated:NO];
    }
    else
    {
        [advertisementScrollView setContentOffset:CGPointMake((pageWidth * pageNumber), 0) animated:YES];
    }
}

-(void)setUpAdvertisementSlider
{
    numberOfPages = self.objSelectedAdvice.arrayAdviceImageUrls.count;
    pageNumber = 0;
    
    advertisementTimer = [NSTimer scheduledTimerWithTimeInterval:5.0 target:self selector:@selector(advertisementTimerMethod:) userInfo:nil repeats:YES];
    
    mainPageControl.userInteractionEnabled = FALSE;
    mainPageControl.numberOfPages = numberOfPages;
    mainPageControl.currentPageIndicatorTintColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    
    [advertisementScrollView setContentOffset:CGPointMake(0, 0) animated:NO];
    advertisementScrollView.contentSize = CGSizeMake(advertisementScrollView.frame.size.width * numberOfPages, advertisementScrollView.frame.size.height);
    advertisementScrollView.delegate = self;
    
    for(int i = 0; i < self.objSelectedAdvice.arrayAdviceImageUrls.count; i++)
    {
        AsyncImageView *advertisementImageView = [[AsyncImageView alloc] initWithFrame:CGRectMake((advertisementScrollView.frame.size.width*i), 0, (advertisementScrollView.frame.size.width), advertisementScrollView.frame.size.height)];
        
        NSString *strImageUrl = [self.objSelectedAdvice.arrayAdviceImageUrls objectAtIndex:i];
        
//        [[AsyncImageLoader sharedLoader].cache removeAllObjects];
        advertisementImageView.imageURL = [NSURL URLWithString:strImageUrl];
        advertisementImageView.layer.masksToBounds = YES;
        advertisementImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        [advertisementScrollView addSubview:advertisementImageView];
    }
    
    UITapGestureRecognizer *advertisementScrollViewTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(advertisementScrollViewTapped:)];
    advertisementScrollViewTapGestureRecognizer.delegate = self;
    advertisementScrollView.userInteractionEnabled = true;
    [advertisementScrollView addGestureRecognizer:advertisementScrollViewTapGestureRecognizer];
}

- (void) advertisementScrollViewTapped: (UITapGestureRecognizer *)recognizer
{
    
}

#pragma mark - UIScrollView Delegate Methods

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    if(scrollView == advertisementScrollView)
    {
        int scrollEndPoint;
        
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == advertisementScrollView)
    {
        CGFloat pageWidth = advertisementScrollView.frame.size.width;
        
        float fractionalPage = advertisementScrollView.contentOffset.x / pageWidth;
        NSInteger page = lround(fractionalPage);
        mainPageControl.currentPage = page;
        pageNumber = page;
        [mainPageControl reloadInputViews];
    }
}

#pragma mark - Other Methods

@end
