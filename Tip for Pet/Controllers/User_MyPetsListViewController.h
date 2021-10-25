//
//  User_MyPetsListViewController.h
//  Tip for Pet
//
//  Created by Pratik Gujarati on 02/08/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface User_MyPetsListViewController : UIViewController<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewMenu;
@property (nonatomic,retain) IBOutlet UIButton *btnMenu;
@property (nonatomic,retain) IBOutlet UILabel *lblNavigationTitle;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewSearch;
@property (nonatomic,retain) IBOutlet UIButton *btnSearch;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewAdd;
@property (nonatomic,retain) IBOutlet UIButton *btnAdd;

@property (nonatomic,retain) IBOutlet UIView *mainContainerView;
@property (nonatomic,retain) IBOutlet UITableView *mainTableView;

//========== OTHER VARIABLES ==========//

@property (nonatomic,retain) NSMutableArray *dataRows;

@end
