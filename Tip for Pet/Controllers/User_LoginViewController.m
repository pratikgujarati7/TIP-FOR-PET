//
//  User_LoginViewController.m
//  Tip for Pet
//
//  Created by Pratik Gujarati on 26/07/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "User_LoginViewController.h"
#import "MySingleton.h"

#import "IQKeyboardManager.h"

#import "User_HomeViewController.h"
#import "User_RegistrationViewController.h"
#import "User_ForgetPasswordViewController.h"

@interface User_LoginViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}

@end

@implementation User_LoginViewController

//========== IBOUTLETS ==========//

@synthesize mainScrollView;

@synthesize mainContainerView;

@synthesize topContainerView;
@synthesize btnSkip;
@synthesize imageViewLogo;

@synthesize txtEmail;
@synthesize txtEmailBottomSeparatorView;

@synthesize txtPassword;
@synthesize txtPasswordBottomSeparatorView;

@synthesize btnForgetPassword;

@synthesize lblByLogginIn;
@synthesize btnLogin;

@synthesize lblNotAMemberYet;
@synthesize btnRegisterNow;

//========== OTHER VARIABLES ==========//

#pragma mark - View Controller Delegate Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNotificationEvent];
    
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
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    [self removeNotificationEventObserver];
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
    
    mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, btnRegisterNow.frame.origin.y + btnRegisterNow.frame.size.height + 20);
}

#pragma mark - Setup Notification Methods

-(void)setupNotificationEvent
{
    if(boolIsSetupNotificationEventCalledOnce == false)
    {
        boolIsSetupNotificationEventCalledOnce = true;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_loggedinEvent) name:@"user_loggedinEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)user_loggedinEvent
{
    [self navigateToUserHomeViewController];
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
    
    UIFont *btnSkipFont, *txtFieldFont, *btnForgetPasswordFont, *lblByLogginInFont, *btnFont, *lblNotAMemberYetFont, *btnRegisterNowFont;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        btnSkipFont = [MySingleton sharedManager].themeFontTwentySizeBold;
        txtFieldFont = [MySingleton sharedManager].themeFontSixteenSizeRegular;
        btnForgetPasswordFont = [MySingleton sharedManager].themeFontTwelveSizeBold;
        lblByLogginInFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
        lblNotAMemberYetFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        btnRegisterNowFont = [MySingleton sharedManager].themeFontThirteenSizeBold;
    }
    else
    {
        if([MySingleton sharedManager].screenHeight == 480)
        {
            btnSkipFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
            txtFieldFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
            btnForgetPasswordFont = [MySingleton sharedManager].themeFontTenSizeBold;
            lblByLogginInFont = [MySingleton sharedManager].themeFontTenSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontFourteenSizeBold;
            lblNotAMemberYetFont = [MySingleton sharedManager].themeFontTenSizeRegular;
            btnRegisterNowFont = [MySingleton sharedManager].themeFontElevenSizeBold;
        }
        else if([MySingleton sharedManager].screenHeight == 568)
        {
            btnSkipFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
            txtFieldFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
            btnForgetPasswordFont = [MySingleton sharedManager].themeFontTenSizeBold;
            lblByLogginInFont = [MySingleton sharedManager].themeFontTenSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontFourteenSizeBold;
            lblNotAMemberYetFont = [MySingleton sharedManager].themeFontTenSizeRegular;
            btnRegisterNowFont = [MySingleton sharedManager].themeFontElevenSizeBold;
        }
        else if([MySingleton sharedManager].screenHeight == 667)
        {
            btnSkipFont = [MySingleton sharedManager].themeFontSeventeenSizeBold;
            txtFieldFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
            btnForgetPasswordFont = [MySingleton sharedManager].themeFontElevenSizeBold;
            lblByLogginInFont = [MySingleton sharedManager].themeFontElevenSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontFifteenSizeBold;
            lblNotAMemberYetFont = [MySingleton sharedManager].themeFontElevenSizeRegular;
            btnRegisterNowFont = [MySingleton sharedManager].themeFontTwelveSizeBold;
        }
        else if([MySingleton sharedManager].screenHeight >= 736)
        {
            btnSkipFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
            txtFieldFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
            btnForgetPasswordFont = [MySingleton sharedManager].themeFontTwelveSizeBold;
            lblByLogginInFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
            lblNotAMemberYetFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
            btnRegisterNowFont = [MySingleton sharedManager].themeFontThirteenSizeBold;
        }
    }
    
    btnSkip.titleLabel.font = btnSkipFont;
    [btnSkip setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    [btnSkip addTarget:self action:@selector(btnSkipClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    topContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalGreenColor;
    
    imageViewLogo.layer.masksToBounds = true;
    imageViewLogo.contentMode = UIViewContentModeScaleAspectFit;
    
    txtEmail.font = txtFieldFont;
    txtEmail.delegate = self;
    txtEmail.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Email"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtEmail.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtEmail.tintColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtEmail.floatingLabelFont = txtFieldFont;
    txtEmail.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtEmail.keepBaseline = NO;
    [txtEmail setAutocorrectionType:UITextAutocorrectionTypeNo];
    txtEmail.keyboardType = UIKeyboardTypeEmailAddress;
    
    txtEmailBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    
    txtPassword.font = txtFieldFont;
    txtPassword.delegate = self;
    txtPassword.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Password"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtPassword.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtPassword.tintColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtPassword.floatingLabelFont = txtFieldFont;
    txtPassword.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtPassword.keepBaseline = NO;
    [txtPassword setAutocorrectionType:UITextAutocorrectionTypeNo];
    txtPassword.secureTextEntry = true;
    
    txtPasswordBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    NSMutableAttributedString *btnForgetPasswordTitleString = [[NSMutableAttributedString alloc] initWithString:@"Forget Password?"];
    [btnForgetPasswordTitleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [btnForgetPasswordTitleString length])];
    [btnForgetPasswordTitleString addAttribute:NSFontAttributeName value:btnForgetPasswordFont range:NSMakeRange(0, [btnForgetPasswordTitleString length])];
    [btnForgetPasswordTitleString addAttribute:NSForegroundColorAttributeName value:[MySingleton sharedManager].themeGlobalDarkGreyColor range:NSMakeRange(0, [btnForgetPasswordTitleString length])];
    [btnForgetPassword setAttributedTitle:btnForgetPasswordTitleString forState:UIControlStateNormal];
    [btnForgetPassword addTarget:self action:@selector(btnForgetPasswordClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    lblByLogginIn.font = lblByLogginInFont;
    lblByLogginIn.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
    
    btnLogin.backgroundColor = [MySingleton sharedManager].themeGlobalGreenColor;
    btnLogin.layer.masksToBounds = true;
    btnLogin.layer.cornerRadius = [MySingleton sharedManager].floatButtonCornerRadius;
    btnLogin.titleLabel.font = btnFont;
    [btnLogin setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    [btnLogin addTarget:self action:@selector(btnLoginClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    lblNotAMemberYet.font = lblNotAMemberYetFont;
    lblNotAMemberYet.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
    
    NSMutableAttributedString *btnRegisterNowTitleString = [[NSMutableAttributedString alloc] initWithString:@"REGISTER NOW"];
    [btnRegisterNowTitleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [btnRegisterNowTitleString length])];
    [btnRegisterNowTitleString addAttribute:NSFontAttributeName value:btnRegisterNowFont range:NSMakeRange(0, [btnRegisterNowTitleString length])];
    [btnRegisterNowTitleString addAttribute:NSForegroundColorAttributeName value:[MySingleton sharedManager].themeGlobalGreenColor range:NSMakeRange(0, [btnRegisterNowTitleString length])];
    [btnRegisterNow setAttributedTitle:btnRegisterNowTitleString forState:UIControlStateNormal];
    [btnRegisterNow addTarget:self action:@selector(btnRegisterNowClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //========== PRATIK GUJARATI TEMP DATA ==========//
//    txtEmail.text = @"pratikgujarati7@gmail.com";
//    txtPassword.text = @"123456";
    //========== PRATIK GUJARATI TEMP DATA ==========//
}

#pragma mark - UITextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

#pragma mark - Other Methods

-(void)doneClicked:(id)sender
{
    [self.view endEditing:YES];
}

-(IBAction)btnForgetPasswordClicked:(id)sender
{
    [self.view endEditing:true];
    
    User_ForgetPasswordViewController *viewController;
    
    viewController = [[User_ForgetPasswordViewController alloc] initWithNibName:@"User_ForgetPasswordViewController" bundle:nil];
    
    /*
    if([MySingleton sharedManager].screenHeight == 812)
    {
        viewController = [[User_ForgetPasswordViewController alloc] initWithNibName:@"User_ForgetPasswordViewController_iPhone10" bundle:nil];
    }
    
    else
    {
        viewController = [[User_ForgetPasswordViewController alloc] initWithNibName:@"User_ForgetPasswordViewController" bundle:nil];
    }
    */
    
    [self.navigationController pushViewController:viewController animated:YES];
}

-(IBAction)btnSkipClicked:(id)sender
{
    [self.view endEditing:true];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:@"1" forKey:@"loginskipped"];
        [prefs synchronize];
        
        [self navigateToUserHomeViewController];
    });
}

-(void)bindUserDataToObject
{
    if([MySingleton sharedManager].dataManager.objLoggedInUser == nil)
    {
        [MySingleton sharedManager].dataManager.objLoggedInUser = [[User alloc]init];
    }
    
    [MySingleton sharedManager].dataManager.objLoggedInUser.strEmail = txtEmail.text;
    [MySingleton sharedManager].dataManager.objLoggedInUser.strPassword = txtPassword.text;
}

-(IBAction)btnLoginClicked:(id)sender
{
    [self.view endEditing:true];
    
    [self bindUserDataToObject];
    
    if([[MySingleton sharedManager].dataManager.objLoggedInUser isValidateUserForLogin])
    {
        [[MySingleton sharedManager].dataManager user_login:[MySingleton sharedManager].dataManager.objLoggedInUser];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showErrorAlertViewWithTitle:@"" withDetails:[MySingleton sharedManager].dataManager.objLoggedInUser.strValidationMessage];
        });
    }
}

- (IBAction)btnRegisterNowClicked:(id)sender
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

@end
