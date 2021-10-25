//
//  User_ChangePasswordViewController.m
//  Tip for Pet
//
//  Created by Pratik Gujarati on 01/08/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "User_ChangePasswordViewController.h"
#import "MySingleton.h"

#import "IQKeyboardManager.h"

@interface User_ChangePasswordViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}

@end

@implementation User_ChangePasswordViewController

//========== IBOUTLETS ==========//

@synthesize mainScrollView;

@synthesize mainContainerView;

@synthesize topContainerView;
@synthesize imageViewBack;
@synthesize btnBack;
@synthesize imageViewLogo;

@synthesize txtOldPassword;
@synthesize txtOldPasswordBottomSeparatorView;

@synthesize txtNewPassword;
@synthesize txtNewPasswordBottomSeparatorView;

@synthesize txtRepeatPassword;
@synthesize txtRepeatPasswordBottomSeparatorView;

@synthesize btnChangePassword;

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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_changedPasswordEvent) name:@"user_changedPasswordEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)user_changedPasswordEvent
{
    [self.view endEditing:YES];
    
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    alertViewController.title = @"";
    alertViewController.message = @"Your password has been changed successfully.";
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
        
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertViewController animated:YES completion:nil];
    });
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
    
    UIFont *txtFieldFont, *btnFont;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        txtFieldFont = [MySingleton sharedManager].themeFontSixteenSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
    }
    else
    {
        if([MySingleton sharedManager].screenHeight == 480)
        {
            txtFieldFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontFourteenSizeBold;
        }
        else if([MySingleton sharedManager].screenHeight == 568)
        {
            txtFieldFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontFourteenSizeBold;
        }
        else if([MySingleton sharedManager].screenHeight == 667)
        {
            txtFieldFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontFifteenSizeBold;
        }
        else if([MySingleton sharedManager].screenHeight >= 736)
        {
            txtFieldFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
        }
    }
    
    imageViewBack.layer.masksToBounds = true;
    [btnBack addTarget:self action:@selector(btnBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    topContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalGreenColor;
    
    imageViewLogo.layer.masksToBounds = true;
    imageViewLogo.contentMode = UIViewContentModeScaleAspectFit;
    
    txtOldPassword.font = txtFieldFont;
    txtOldPassword.delegate = self;
    txtOldPassword.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Old Password"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtOldPassword.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtOldPassword.tintColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtOldPassword.floatingLabelFont = txtFieldFont;
    txtOldPassword.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtOldPassword.keepBaseline = NO;
    [txtOldPassword setAutocorrectionType:UITextAutocorrectionTypeNo];
    txtOldPassword.secureTextEntry = true;
    
    txtOldPasswordBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    txtNewPassword.font = txtFieldFont;
    txtNewPassword.delegate = self;
    txtNewPassword.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"New Password"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtNewPassword.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtNewPassword.tintColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtNewPassword.floatingLabelFont = txtFieldFont;
    txtNewPassword.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtNewPassword.keepBaseline = NO;
    [txtNewPassword setAutocorrectionType:UITextAutocorrectionTypeNo];
    txtNewPassword.keyboardType = UIKeyboardTypeEmailAddress;
    txtNewPassword.secureTextEntry = true;
    
    txtNewPasswordBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    txtRepeatPassword.font = txtFieldFont;
    txtRepeatPassword.delegate = self;
    txtRepeatPassword.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Confirm Password"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtRepeatPassword.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtRepeatPassword.tintColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtRepeatPassword.floatingLabelFont = txtFieldFont;
    txtRepeatPassword.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtRepeatPassword.keepBaseline = NO;
    [txtRepeatPassword setAutocorrectionType:UITextAutocorrectionTypeNo];
    txtRepeatPassword.keyboardType = UIKeyboardTypeEmailAddress;
    txtRepeatPassword.secureTextEntry = true;
    
    txtRepeatPasswordBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    btnChangePassword.backgroundColor = [MySingleton sharedManager].themeGlobalGreenColor;
    btnChangePassword.layer.masksToBounds = true;
    btnChangePassword.layer.cornerRadius = [MySingleton sharedManager].floatButtonCornerRadius;
    btnChangePassword.titleLabel.font = btnFont;
    [btnChangePassword setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    [btnChangePassword addTarget:self action:@selector(btnChangePasswordClicked:) forControlEvents:UIControlEventTouchUpInside];
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

-(IBAction)btnChangePasswordClicked:(id)sender
{
    [self.view endEditing:true];
    
    if(txtOldPassword.text.length > 0 && txtNewPassword.text.length > 0 && txtRepeatPassword.text.length > 0 && [txtNewPassword.text isEqualToString:txtRepeatPassword.text])
    {
        NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [dictParameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        [dictParameters setObject:txtOldPassword.text forKey:@"strOldPassword"];
        [dictParameters setObject:txtNewPassword.text forKey:@"strNewPassword"];
        [dictParameters setObject:txtRepeatPassword.text forKey:@"strRepeatPassword"];
        
        [[MySingleton sharedManager].dataManager user_changePassword:dictParameters];
    }
    else
    {
        if(txtOldPassword.text.length <= 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate showErrorAlertViewWithTitle:nil withDetails:@"Please enter old password"];
            });
        }
        else if(txtNewPassword.text.length <= 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate showErrorAlertViewWithTitle:nil withDetails:@"Please enter new password"];
            });
        }
        else if(txtRepeatPassword.text.length <= 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate showErrorAlertViewWithTitle:nil withDetails:@"Please enter repeat password"];
            });
        }
        else if(![txtNewPassword.text isEqualToString:txtRepeatPassword.text])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate showErrorAlertViewWithTitle:@"" withDetails:@"Password and repeat password must match."];
            });
        }
    }
}

@end
