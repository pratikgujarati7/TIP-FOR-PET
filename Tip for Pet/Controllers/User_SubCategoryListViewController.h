//
//  User_SubCategoryListViewController.h
//  Tip for Pet
//
//  Created by Pratik Gujarati on 28/07/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Category.h"

@interface User_SubCategoryListViewController : UIViewController<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewBack;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UILabel *lblNavigationTitle;

@property (nonatomic,retain) IBOutlet UIView *mainContainerView;
@property (nonatomic,retain) IBOutlet UITableView *mainTableView;

//========== OTHER VARIABLES ==========//

@property (nonatomic,retain) NSMutableArray *dataRows;

@property (nonatomic,retain) Category *objSelectedCategory;

@end
