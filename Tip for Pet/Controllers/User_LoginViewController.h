//
//  User_LoginViewController.h
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

@interface User_LoginViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIView *mainContainerView;

@property (nonatomic,retain) IBOutlet UIView *topContainerView;
@property (nonatomic,retain) IBOutlet UIButton *btnSkip;
@property (nonatomic,retain) IBOutlet AsyncImageView *imageViewLogo;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtEmail;
@property (nonatomic,retain) IBOutlet UIView *txtEmailBottomSeparatorView;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtPassword;
@property (nonatomic,retain) IBOutlet UIView *txtPasswordBottomSeparatorView;

@property (nonatomic,retain) IBOutlet UIButton *btnForgetPassword;

@property (nonatomic,retain) IBOutlet UILabel *lblByLogginIn;
@property (nonatomic,retain) IBOutlet UIButton *btnLogin;

@property (nonatomic,retain) IBOutlet UILabel *lblNotAMemberYet;
@property (nonatomic,retain) IBOutlet UIButton *btnRegisterNow;

//========== OTHER VARIABLES ==========//

@end
