//
//  User_ForgetPasswordViewController.h
//  Tip for Pet
//
//  Created by Pratik Gujarati on 27/07/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "JVFloatLabeledTextField.h"

#import "LGSideMenuController.h"
#import "UIViewController+LGSideMenuController.h"
#import "Common_SideMenuViewController.h"

@interface User_ForgetPasswordViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIView *mainContainerView;

@property (nonatomic,retain) IBOutlet UIView *topContainerView;
@property (nonatomic,retain) IBOutlet AsyncImageView *imageViewBack;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet AsyncImageView *imageViewLogo;

@property (nonatomic,retain) IBOutlet UILabel *lblInstructions;
@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtEmail;
@property (nonatomic,retain) IBOutlet UIView *txtEmailBottomSeparatorView;

@property (nonatomic,retain) IBOutlet UIButton *btnSubmit;

//========== OTHER VARIABLES ==========//

@end
