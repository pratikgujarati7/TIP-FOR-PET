//
//  User_MyProfileViewController.m
//  Tip for Pet
//
//  Created by Pratik Gujarati on 31/07/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "User_MyProfileViewController.h"

#import "MySingleton.h"

#import "IQKeyboardManager.h"

#import "User_ChangePasswordViewController.h"

@interface User_MyProfileViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}

@end

@implementation User_MyProfileViewController

//========== IBOUTLETS ==========//

@synthesize mainScrollView;

@synthesize mainContainerView;

@synthesize profilePictureContainerView;
@synthesize imageViewMenu;
@synthesize btnMenu;
@synthesize imageViewOptions;
@synthesize btnOptions;
@synthesize imageViewProfilePicture;
@synthesize imageViewLogo;
@synthesize uploadPhotoContainerView;
@synthesize imageViewUploadPhoto;
@synthesize btnUploadPhoto;

@synthesize txtName;
@synthesize txtNameBottomSeparatorView;

@synthesize txtEmail;
@synthesize txtEmailBottomSeparatorView;

@synthesize txtPhoneNumber;
@synthesize txtPhoneNumberBottomSeparatorView;

@synthesize btnUpdate;

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
    
    mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, btnUpdate.frame.origin.y + btnUpdate.frame.size.height + 20);
}

#pragma mark - Setup Notification Methods

-(void)setupNotificationEvent
{
    if(boolIsSetupNotificationEventCalledOnce == false)
    {
        boolIsSetupNotificationEventCalledOnce = true;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_gotProfileDetailsByUserIdEvent) name:@"user_gotProfileDetailsByUserIdEvent" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_updatedProfileEvent) name:@"user_updatedProfileEvent" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_changedProfilePictureEvent) name:@"user_changedProfilePictureEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)user_gotProfileDetailsByUserIdEvent
{
    imageViewProfilePicture.imageURL = [NSURL URLWithString:[MySingleton sharedManager].dataManager.objLoggedInUser.strProfilePictureImageUrl];
    
    txtEmail.text = [MySingleton sharedManager].dataManager.objLoggedInUser.strEmail;
    
    txtName.text = [MySingleton sharedManager].dataManager.objLoggedInUser.strName;
    txtPhoneNumber.text = [MySingleton sharedManager].dataManager.objLoggedInUser.strPhoneNumber;
}

-(void)user_updatedProfileEvent
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegate showErrorAlertViewWithTitle:@"Profile Updated" withDetails:@"Your profile information has been updated successfully."];
    });
}

-(void)user_changedProfilePictureEvent
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegate showErrorAlertViewWithTitle:@"Profile Picture Updated" withDetails:@"Your profile picture has been changed successfully."];
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
    
    imageViewMenu.layer.masksToBounds = YES;
    [btnMenu addTarget:self action:@selector(btnMenuClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    imageViewOptions.layer.masksToBounds = YES;
    [btnOptions addTarget:self action:@selector(btnOptionsClicked:) forControlEvents:UIControlEventTouchUpInside];
    
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
    txtEmail.textColor = [MySingleton sharedManager].textfieldDisabledTextColor;
    txtEmail.tintColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtEmail.floatingLabelFont = txtFieldFont;
    txtEmail.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtEmail.keepBaseline = NO;
    [txtEmail setAutocorrectionType:UITextAutocorrectionTypeNo];
    txtEmail.keyboardType = UIKeyboardTypeEmailAddress;
    txtEmail.userInteractionEnabled = false;
    
    txtEmailBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    
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
    
    btnUpdate.backgroundColor = [MySingleton sharedManager].themeGlobalGreenColor;
    btnUpdate.layer.masksToBounds = true;
    btnUpdate.layer.cornerRadius = [MySingleton sharedManager].floatButtonCornerRadius;
    btnUpdate.titleLabel.font = btnFont;
    [btnUpdate setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    [btnUpdate addTarget:self action:@selector(btnUpdateClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [[MySingleton sharedManager].dataManager user_getProfileDetailsByUserId:[prefs objectForKey:@"userid"]];
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
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [[MySingleton sharedManager].dataManager user_changeProfilePicture:[prefs objectForKey:@"userid"] withProfilePictureData:selectedImageData];
         
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

-(IBAction)btnMenuClicked:(id)sender
{
    if(self.sideMenuController.isLeftViewVisible)
    {
        [self.sideMenuController hideLeftViewAnimated];
    }
    else
    {
        [self.sideMenuController showLeftViewAnimated:YES completionHandler:nil];
    }
}

-(IBAction)btnOptionsClicked:(id)sender
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Dismiss button tappped.
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Change Password" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [self redirectToChangePasswordViewController];
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
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

-(IBAction)btnUpdateClicked:(id)sender
{
    [self.view endEditing:true];
    
    if(txtName.text.length > 0 && txtPhoneNumber.text.length > 0)
    {
        NSMutableDictionary *dictParameters = [[NSMutableDictionary alloc] init];
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [dictParameters setObject:[prefs objectForKey:@"userid"] forKey:@"user_id"];
        [dictParameters setObject:txtName.text forKey:@"name"];
        [dictParameters setObject:txtPhoneNumber.text forKey:@"phone_number"];
        
        [[MySingleton sharedManager].dataManager user_updateProfile:dictParameters];
    }
    else
    {
        if(txtName.text.length <= 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate showErrorAlertViewWithTitle:nil withDetails:@"Please enter your name"];
            });
        }
        else if(txtPhoneNumber.text.length <= 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate showErrorAlertViewWithTitle:nil withDetails:@"Please enter your phone number"];
            });
        }
    }
}

-(void)redirectToChangePasswordViewController
{
    [self.view endEditing:YES];
    
    User_ChangePasswordViewController *viewController;
    
    viewController = [[User_ChangePasswordViewController alloc] initWithNibName:@"User_ChangePasswordViewController" bundle:nil];
    
    /*
    if([MySingleton sharedManager].screenHeight == 812)
    {
        viewController = [[User_ChangePasswordViewController alloc] initWithNibName:@"User_ChangePasswordViewController_iPhone10" bundle:nil];
    }
    
    else
    {
        viewController = [[User_ChangePasswordViewController alloc] initWithNibName:@"User_ChangePasswordViewController" bundle:nil];
    }
    */
    
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
