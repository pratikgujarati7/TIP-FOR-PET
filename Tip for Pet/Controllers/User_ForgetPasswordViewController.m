//
//  User_ForgetPasswordViewController.m
//  Tip for Pet
//
//  Created by Pratik Gujarati on 27/07/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "User_ForgetPasswordViewController.h"
#import "MySingleton.h"

#import "IQKeyboardManager.h"

#import "User_LoginViewController.h"

@interface User_ForgetPasswordViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}

@end

@implementation User_ForgetPasswordViewController

//========== IBOUTLETS ==========//

@synthesize mainScrollView;

@synthesize mainContainerView;

@synthesize topContainerView;
@synthesize imageViewBack;
@synthesize btnBack;
@synthesize imageViewLogo;

@synthesize lblInstructions;
@synthesize txtEmail;
@synthesize txtEmailBottomSeparatorView;

@synthesize btnSubmit;

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
    
    mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height);
}

#pragma mark - Setup Notification Methods

-(void)setupNotificationEvent
{
    if(boolIsSetupNotificationEventCalledOnce == false)
    {
        boolIsSetupNotificationEventCalledOnce = true;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_forgetpasswordemailsentEvent) name:@"user_forgetpasswordemailsentEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)user_forgetpasswordemailsentEvent
{
    [self.view endEditing:YES];
    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [appDelegate showErrorAlertViewWithTitle:@"Email Sent" withDetails:@"We have sent you an email containing your new password. Please use that password to login to the application."];
//    });
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
    
    UIFont *lblInstructionsFont, *txtFieldFont, *btnFont;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        lblInstructionsFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        txtFieldFont = [MySingleton sharedManager].themeFontSixteenSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
    }
    else
    {
        if([MySingleton sharedManager].screenHeight == 480)
        {
            lblInstructionsFont = [MySingleton sharedManager].themeFontTenSizeRegular;
            txtFieldFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontFourteenSizeBold;
        }
        else if([MySingleton sharedManager].screenHeight == 568)
        {
            lblInstructionsFont = [MySingleton sharedManager].themeFontTenSizeRegular;
            txtFieldFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontFourteenSizeBold;
        }
        else if([MySingleton sharedManager].screenHeight == 667)
        {
            lblInstructionsFont = [MySingleton sharedManager].themeFontElevenSizeRegular;
            txtFieldFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontFifteenSizeBold;
        }
        else if([MySingleton sharedManager].screenHeight >= 736)
        {
            lblInstructionsFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
            txtFieldFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
        }
    }
    
    imageViewBack.layer.masksToBounds = true;
    [btnBack addTarget:self action:@selector(btnBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    topContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalGreenColor;
    
    imageViewLogo.layer.masksToBounds = true;
    imageViewLogo.contentMode = UIViewContentModeScaleAspectFit;
    
    lblInstructions.font = lblInstructionsFont;
    lblInstructions.textColor = [MySingleton sharedManager].themeGlobalLightGreyColor;
    
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
    
    btnSubmit.backgroundColor = [MySingleton sharedManager].themeGlobalGreenColor;
    btnSubmit.layer.masksToBounds = true;
    btnSubmit.layer.cornerRadius = [MySingleton sharedManager].floatButtonCornerRadius;
    btnSubmit.titleLabel.font = btnFont;
    [btnSubmit setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    [btnSubmit addTarget:self action:@selector(btnSubmitClicked:) forControlEvents:UIControlEventTouchUpInside];
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

-(IBAction)btnBackClicked:(id)sender
{
    [self.view endEditing:true];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnSubmitClicked:(id)sender
{
    [self.view endEditing:true];
    
    if(txtEmail.text.length > 0)
    {
        [[MySingleton sharedManager].dataManager user_forgetPassword:txtEmail.text];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showErrorAlertViewWithTitle:@"" withDetails:@"Please enter your email address"];
        });
    }
}

@end
