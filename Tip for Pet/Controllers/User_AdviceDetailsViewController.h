//
//  User_AdviceDetailsViewController.h
//  Tip for Pet
//
//  Created by Pratik Gujarati on 29/07/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Advice.h"

@interface User_AdviceDetailsViewController : UIViewController<UIScrollViewDelegate, UIGestureRecognizerDelegate>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewBack;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UILabel *lblNavigationTitle;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewShare;
@property (nonatomic,retain) IBOutlet UIButton *btnShare;

@property (nonatomic,retain) IBOutlet UIView *mainContainerView;

@property (nonatomic,retain) IBOutlet UIScrollView *advertisementScrollView;
@property (nonatomic,retain) IBOutlet UIPageControl *mainPageControl;

@property (nonatomic,retain) IBOutlet UILabel *lblAdviceTitle;
@property (nonatomic,retain) IBOutlet UILabel *lblAdviceDetails;

//========== OTHER VARIABLES ==========//

@property (nonatomic,retain) Advice *objSelectedAdvice;

@end
