//
//  Common_SideMenuViewController.h
//  SetMyPace
//
//  Created by Pratik Gujarati on 28/01/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

#import "LGSideMenuController.h"
#import "UIViewController+LGSideMenuController.h"

@interface Common_SideMenuViewController : UIViewController<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;
@property (nonatomic,retain) IBOutlet UIView *mainContainerView;

@property (nonatomic,retain) IBOutlet UIImageView *mainImageViewBackground;
@property (nonatomic,retain) IBOutlet UIScrollView *mainTableViewContainerScrollView;
@property (nonatomic,retain) IBOutlet UITableView *mainTableView;

//========== OTHER VARIABLES ==========//

@end
