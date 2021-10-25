//
//  User_RegistrationViewController.h
//  Tip for Pet
//
//  Created by Pratik Gujarati on 26/07/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "JVFloatLabeledTextField.h"

#import "LGSideMenuController.h"
#import "UIViewController+LGSideMenuController.h"
#import "Common_SideMenuViewController.h"

@interface User_RegistrationViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIView *mainContainerView;

@property (nonatomic,retain) IBOutlet UIView *profilePictureContainerView;
@property (nonatomic,retain) IBOutlet UIButton *btnSkip;
@property (nonatomic,retain) IBOutlet AsyncImageView *imageViewProfilePicture;
@property (nonatomic,retain) IBOutlet AsyncImageView *imageViewLogo;
@property (nonatomic,retain) IBOutlet UIView *uploadPhotoContainerView;
@property (nonatomic,retain) IBOutlet AsyncImageView *imageViewUploadPhoto;
@property (nonatomic,retain) IBOutlet UIButton *btnUploadPhoto;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtName;
@property (nonatomic,retain) IBOutlet UIView *txtNameBottomSeparatorView;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtEmail;
@property (nonatomic,retain) IBOutlet UIView *txtEmailBottomSeparatorView;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtPassword;
@property (nonatomic,retain) IBOutlet UIView *txtPasswordBottomSeparatorView;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtPhoneNumber;
@property (nonatomic,retain) IBOutlet UIView *txtPhoneNumberBottomSeparatorView;

@property (nonatomic,retain) IBOutlet UILabel *lblBySigningUp;
@property (nonatomic,retain) IBOutlet UIButton *btnSignup;

@property (nonatomic,retain) IBOutlet UILabel *lblAlreadyHaveAnAccount;
@property (nonatomic,retain) IBOutlet UIButton *btnLogin;

//========== OTHER VARIABLES ==========//

@end
