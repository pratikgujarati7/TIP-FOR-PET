//
//  Common_IntroductionViewController.h
//  ENZYM
//
//  Created by Pratik Gujarati on 22/03/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "LGSideMenuController.h"
#import "UIViewController+LGSideMenuController.h"
#import "Common_SideMenuViewController.h"

#import "CustomLabel.h"

@interface Common_IntroductionViewController : UIViewController<UIScrollViewDelegate>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic,retain) IBOutlet UIView *mainContainerView;

@property (nonatomic,retain) IBOutlet UIImageView *imageViewMainLogo;

@property (nonatomic,retain) IBOutlet UIScrollView *AdvertisementScrollView;

@property (nonatomic,retain) IBOutlet CustomLabel *lblAdvertisementTitle1;
@property (nonatomic,retain) IBOutlet UILabel *lblAdvertisementDetails1;

@property (nonatomic,retain) IBOutlet CustomLabel *lblAdvertisementTitle2;
@property (nonatomic,retain) IBOutlet UILabel *lblAdvertisementDetails2;

@property (nonatomic,retain) IBOutlet UIPageControl *mainPageControl;

@property (nonatomic,retain) IBOutlet CustomLabel *lblSkip;
@property (nonatomic,retain) IBOutlet UIButton *btnSkip;

//========== OTHER VARIABLES ==========//

@end
