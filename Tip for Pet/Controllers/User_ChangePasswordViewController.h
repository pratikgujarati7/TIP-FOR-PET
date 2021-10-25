//
//  User_ChangePasswordViewController.h
//  Tip for Pet
//
//  Created by Pratik Gujarati on 01/08/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "JVFloatLabeledTextField.h"

@interface User_ChangePasswordViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIView *mainContainerView;

@property (nonatomic,retain) IBOutlet UIView *topContainerView;
@property (nonatomic,retain) IBOutlet AsyncImageView *imageViewBack;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet AsyncImageView *imageViewLogo;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtOldPassword;
@property (nonatomic,retain) IBOutlet UIView *txtOldPasswordBottomSeparatorView;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtNewPassword;
@property (nonatomic,retain) IBOutlet UIView *txtNewPasswordBottomSeparatorView;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtRepeatPassword;
@property (nonatomic,retain) IBOutlet UIView *txtRepeatPasswordBottomSeparatorView;

@property (nonatomic,retain) IBOutlet UIButton *btnChangePassword;

//========== OTHER VARIABLES ==========//

@end
