//
//  User_RegistrationViewController.m
//  Tip for Pet
//
//  Created by Pratik Gujarati on 26/07/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "User_RegistrationViewController.h"
#import "MySingleton.h"

#import "IQKeyboardManager.h"

#import "User_HomeViewController.h"
#import "User_LoginViewController.h"

@interface User_RegistrationViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}

@end

@implementation User_RegistrationViewController

//========== IBOUTLETS ==========//

@synthesize mainScrollView;

@synthesize mainContainerView;

@synthesize profilePictureContainerView;
@synthesize btnSkip;
@synthesize imageViewProfilePicture;
@synthesize imageViewLogo;
@synthesize uploadPhotoContainerView;
@synthesize imageViewUploadPhoto;
@synthesize btnUploadPhoto;

@synthesize txtName;
@synthesize txtNameBottomSeparatorView;

@synthesize txtEmail;
@synthesize txtEmailBottomSeparatorView;

@synthesize txtPassword;
@synthesize txtPasswordBottomSeparatorView;

@synthesize txtPhoneNumber;
@synthesize txtPhoneNumberBottomSeparatorView;

@synthesize lblBySigningUp;
@synthesize btnSignup;

@synthesize lblAlreadyHaveAnAccount;
@synthesize btnLogin;

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
    
    uploadPhotoContainerView.layer.cornerRadius = uploadPhotoContainerView.frame.size.height/2;
    
    mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, btnLogin.frame.origin.y + btnLogin.frame.size.height + 20);
}

#pragma mark - Setup Notification Methods

-(void)setupNotificationEvent
{
    if(boolIsSetupNotificationEventCalledOnce == false)
    {
        boolIsSetupNotificationEventCalledOnce = true;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_signedupEvent) name:@"user_signedupEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)user_signedupEvent
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
    
    UIFont *btnSkipFont, *txtFieldFont, *lblBySigningUpFont, *btnFont, *lblAlreadyHaveAnAccountFont, *btnLoginFont;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        btnSkipFont = [MySingleton sharedManager].themeFontTwentySizeBold;
        txtFieldFont = [MySingleton sharedManager].themeFontSixteenSizeRegular;
        lblBySigningUpFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
        lblAlreadyHaveAnAccountFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
        btnLoginFont = [MySingleton sharedManager].themeFontThirteenSizeBold;
    }
    else
    {
        if([MySingleton sharedManager].screenHeight == 480)
        {
            btnSkipFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
            txtFieldFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
            lblBySigningUpFont = [MySingleton sharedManager].themeFontTenSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontFourteenSizeBold;
            lblAlreadyHaveAnAccountFont = [MySingleton sharedManager].themeFontTenSizeRegular;
            btnLoginFont = [MySingleton sharedManager].themeFontElevenSizeBold;
        }
        else if([MySingleton sharedManager].screenHeight == 568)
        {
            btnSkipFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
            txtFieldFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
            lblBySigningUpFont = [MySingleton sharedManager].themeFontTenSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontFourteenSizeBold;
            lblAlreadyHaveAnAccountFont = [MySingleton sharedManager].themeFontTenSizeRegular;
            btnLoginFont = [MySingleton sharedManager].themeFontElevenSizeBold;
        }
        else if([MySingleton sharedManager].screenHeight == 667)
        {
            btnSkipFont = [MySingleton sharedManager].themeFontSeventeenSizeBold;
            txtFieldFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
            lblBySigningUpFont = [MySingleton sharedManager].themeFontElevenSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontFifteenSizeBold;
            lblAlreadyHaveAnAccountFont = [MySingleton sharedManager].themeFontElevenSizeRegular;
            btnLoginFont = [MySingleton sharedManager].themeFontTwelveSizeBold;
        }
        else
        {
            btnSkipFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
            txtFieldFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
            lblBySigningUpFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
            lblAlreadyHaveAnAccountFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
            btnLoginFont = [MySingleton sharedManager].themeFontThirteenSizeBold;
        }
    }
    
    btnSkip.titleLabel.font = btnSkipFont;
    [btnSkip setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    [btnSkip addTarget:self action:@selector(btnSkipClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    profilePictureContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalGreenColor;
    
    imageViewProfilePicture.layer.masksToBounds = true;
    imageViewProfilePicture.contentMode = UIViewContentModeScaleAspectFill;
    
    imageViewLogo.layer.masksToBounds = true;
    imageViewLogo.contentMode = UIViewContentModeScaleAspectFit;
    
    uploadPhotoContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    uploadPhotoContainerView.layer.masksToBounds = false;
    
    // border
    [uploadPhotoContainerView.layer setBorderColor:[MySingleton sharedManager].themeGlobalDarkGreenColor.CGColor];
    [uploadPhotoContainerView.layer setBorderWidth:1.5f];
    
    // drop shadow
    [uploadPhotoContainerView.layer setShadowColor:[MySingleton sharedManager].themeGlobalBlackColor.CGColor];
    [uploadPhotoContainerView.layer setShadowOpacity:0.8];
    [uploadPhotoContainerView.layer setShadowRadius:3.0];
    [uploadPhotoContainerView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    imageViewUploadPhoto.layer.masksToBounds = true;
    imageViewUploadPhoto.contentMode = UIViewContentModeScaleAspectFit;
    
    [btnUploadPhoto addTarget:self action:@selector(btnUploadPhotoClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    txtName.font = txtFieldFont;
    txtName.delegate = self;
    txtName.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Name"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtName.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtName.tintColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtName.floatingLabelFont = txtFieldFont;
    txtName.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtName.keepBaseline = NO;
    [txtName setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    txtNameBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    
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
    
    
    txtPhoneNumber.font = txtFieldFont;
    txtPhoneNumber.delegate = self;
    txtPhoneNumber.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Phone Number"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtPhoneNumber.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtPhoneNumber.tintColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtPhoneNumber.floatingLabelFont = txtFieldFont;
    txtPhoneNumber.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtPhoneNumber.keepBaseline = NO;
    [txtPhoneNumber setAutocorrectionType:UITextAutocorrectionTypeNo];
    txtPhoneNumber.keyboardType = UIKeyboardTypePhonePad;
    
    txtPhoneNumberBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    lblBySigningUp.font = lblBySigningUpFont;
    lblBySigningUp.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
    
    btnSignup.backgroundColor = [MySingleton sharedManager].themeGlobalGreenColor;
    btnSignup.layer.masksToBounds = true;
    btnSignup.layer.cornerRadius = [MySingleton sharedManager].floatButtonCornerRadius;
    btnSignup.titleLabel.font = btnFont;
    [btnSignup setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    [btnSignup addTarget:self action:@selector(btnSignupClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    lblAlreadyHaveAnAccount.font = lblAlreadyHaveAnAccountFont;
    lblBySigningUp.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
    
    NSMutableAttributedString *btnLoginTitleString = [[NSMutableAttributedString alloc] initWithString:@"LOGIN"];
    [btnLoginTitleString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(0, [btnLoginTitleString length])];
    [btnLoginTitleString addAttribute:NSFontAttributeName value:btnFont range:NSMakeRange(0, [btnLoginTitleString length])];
    [btnLoginTitleString addAttribute:NSForegroundColorAttributeName value:[MySingleton sharedManager].themeGlobalGreenColor range:NSMakeRange(0, [btnLoginTitleString length])];
    [btnLogin setAttributedTitle:btnLoginTitleString forState:UIControlStateNormal];
    [btnLogin addTarget:self action:@selector(btnLoginClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //========== PRATIK GUJARATI TEMP DATA ==========//
//    txtName.text = @"Pratik Gujarati";
//    txtEmail.text = @"pratikgujarati7@gmail.com";
//    txtPassword.text = @"123456";
//    txtPhoneNumber.text = @"1231231231";
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

#pragma mark - UIImagePickerController Delegate Method

-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    @try
    {
        UIImage *image = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage* smaller = [self imageWithImage:image scaledToWidth:320];
        
        //SEND IMAGE DATA TO SERVER
        NSData *selectedImageData = UIImagePNGRepresentation(smaller);
        NSString *selectedImageBase64Data = [selectedImageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        
        UIGraphicsEndImageContext();
        
        [picker dismissViewControllerAnimated:NO completion:NULL];
        
        if([MySingleton sharedManager].dataManager.objLoggedInUser == nil)
        {
            [MySingleton sharedManager].dataManager.objLoggedInUser = [[User alloc]init];
        }
        
        [MySingleton sharedManager].dataManager.objLoggedInUser.profilePictureData = selectedImageData;
        
        imageViewProfilePicture.image = image;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in imagePickerController's didFinishPickingMediaWithInfo Method, Exception : %@",exception);
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Image Selection Methods

-(void)takeAPhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.allowsEditing = YES;
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [imagePickerController setModalPresentationStyle:UIModalPresentationPopover];
            UIPopoverPresentationController *popPresenter = [imagePickerController
                                                             popoverPresentationController];
            popPresenter.sourceView = uploadPhotoContainerView;
            popPresenter.sourceRect = uploadPhotoContainerView.bounds;
            popPresenter.permittedArrowDirections = UIPopoverArrowDirectionAny;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:imagePickerController animated:YES completion:nil];
            });
        }
        else
        {
            if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
            {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self presentViewController:imagePickerController animated:YES completion:nil];
                }];
            }
            else
            {
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showErrorAlertViewWithTitle:@"Camera Unavailable" withDetails:@"Unable to find a camera on your device."];
        });
    }
}

-(void)chooseFromGallery
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.allowsEditing = YES;
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [imagePickerController setModalPresentationStyle:UIModalPresentationPopover];
            UIPopoverPresentationController *popPresenter = [imagePickerController
                                                             popoverPresentationController];
            popPresenter.sourceView = uploadPhotoContainerView;
            popPresenter.sourceRect = uploadPhotoContainerView.bounds;
            popPresenter.permittedArrowDirections = UIPopoverArrowDirectionAny;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:imagePickerController animated:YES completion:nil];
            });
        }
        else
        {
            if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
            {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self presentViewController:imagePickerController animated:YES completion:nil];
                }];
            }
            else
            {
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showErrorAlertViewWithTitle:@"Photo library Unavailable" withDetails:@"Unable to find photo library on your device."];
        });
    }
}

#pragma mark - Other Methods

-(void)doneClicked:(id)sender
{
    [self.view endEditing:YES];
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

-(IBAction)btnUploadPhotoClicked:(id)sender
{
    [self.view endEditing:true];
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take a Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Take a Photo
        [self dismissViewControllerAnimated:YES completion:nil];
        [self takeAPhoto];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Choose from Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Choose from Gallery
        [self dismissViewControllerAnimated:YES completion:nil];
        [self chooseFromGallery];
    }]];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [actionSheet setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [actionSheet
                                                         popoverPresentationController];
        popPresenter.sourceView = uploadPhotoContainerView;
        popPresenter.sourceRect = uploadPhotoContainerView.bounds;
        popPresenter.permittedArrowDirections = UIPopoverArrowDirectionAny;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:actionSheet animated:YES completion:nil];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:actionSheet animated:YES completion:nil];
        });
    }
}

-(void)bindUserDataToObject
{
    if([MySingleton sharedManager].dataManager.objLoggedInUser == nil)
    {
        [MySingleton sharedManager].dataManager.objLoggedInUser = [[User alloc]init];
    }
    
    [MySingleton sharedManager].dataManager.objLoggedInUser.strName = txtName.text;
    [MySingleton sharedManager].dataManager.objLoggedInUser.strEmail = txtEmail.text;
    [MySingleton sharedManager].dataManager.objLoggedInUser.strPassword = txtPassword.text;
    [MySingleton sharedManager].dataManager.objLoggedInUser.strPhoneNumber = txtPhoneNumber.text;
}

-(IBAction)btnSignupClicked:(id)sender
{
    [self.view endEditing:true];
    
    [self bindUserDataToObject];
    
    if([[MySingleton sharedManager].dataManager.objLoggedInUser isValidateUserForRegistration])
    {
        [[MySingleton sharedManager].dataManager user_signUp:[MySingleton sharedManager].dataManager.objLoggedInUser];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showErrorAlertViewWithTitle:@"" withDetails:[MySingleton sharedManager].dataManager.objLoggedInUser.strValidationMessage];
        });
    }
}

- (IBAction)btnLoginClicked:(id)sender
{
    [self.view endEditing:true];
    
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
