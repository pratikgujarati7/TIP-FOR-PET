//
//  User_PetCareReminderListViewController.m
//  Tip for Pet
//
//  Created by Pratik Gujarati on 03/08/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "User_PetCareReminderListViewController.h"
#import "MySingleton.h"

#import "IQKeyboardManager.h"

#import "ScheduledReminderTableViewCell.h"
#import "Reminder.h"

#import "User_AddPetCareRemindeViewController.h"

@interface User_PetCareReminderListViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}

@end

@implementation User_PetCareReminderListViewController

//========== IBOUTLETS ==========//

@synthesize mainScrollView;

@synthesize navigationBarView;
@synthesize imageViewMenu;
@synthesize btnMenu;
@synthesize lblNavigationTitle;
@synthesize imageViewSearch;
@synthesize btnSearch;
@synthesize imageViewAdd;
@synthesize btnAdd;

@synthesize mainContainerView;
@synthesize mainTableView;
@synthesize btnCancelAllReminders;

//========== OTHER VARIABLES ==========//

#pragma mark - View Controller Delegate Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setupNotificationEvent];
    
    [self setNavigationBar];
    [self setupInitialView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNotificationEvent];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if([MySingleton sharedManager].dataManager.boolIsReminderAddedSuccessfully)
    {
        [MySingleton sharedManager].dataManager.boolIsReminderAddedSuccessfully = false;
        
        [[MySingleton sharedManager].dataManager createDatabaseTable];
    }
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
    
    mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, mainScrollView.frame.size.height);
}

#pragma mark - Setup Notification Methods

-(void)setupNotificationEvent
{
    if(boolIsSetupNotificationEventCalledOnce == false)
    {
        boolIsSetupNotificationEventCalledOnce = true;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createdDatabaseTableEvent) name:@"createdDatabaseTableEvent" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_gotAllRemindersFromSqliteDatabaseEvent) name:@"user_gotAllRemindersFromSqliteDatabaseEvent" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_deletedAReminderFromSqliteDatabaseEvent) name:@"user_deletedAReminderFromSqliteDatabaseEvent" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_deletedAllRemindersFromSqliteDatabaseEvent) name:@"user_deletedAllRemindersFromSqliteDatabaseEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)createdDatabaseTableEvent
{
    [[MySingleton sharedManager].dataManager user_getAllRemindersFromSqliteDatabase];
}

-(void)user_gotAllRemindersFromSqliteDatabaseEvent
{
    self.dataRows = [MySingleton sharedManager].dataManager.arrayAllRemindersFromSQLiteDatabase;
    
    mainTableView.hidden = false;
    [mainTableView reloadData];
    
    if(self.dataRows.count <= 0)
    {
        mainTableView.scrollEnabled = false;
        
        btnCancelAllReminders.hidden = true;
    }
    else
    {
        mainTableView.scrollEnabled = true;
        
        btnCancelAllReminders.hidden = false;
    }
}

-(void)user_deletedAReminderFromSqliteDatabaseEvent
{
    self.dataRows = [MySingleton sharedManager].dataManager.arrayAllRemindersFromSQLiteDatabase;
    
    mainTableView.hidden = false;
    [mainTableView reloadData];
    
    if(self.dataRows.count <= 0)
    {
        mainTableView.scrollEnabled = false;
        
        btnCancelAllReminders.hidden = true;
    }
}

-(void)user_deletedAllRemindersFromSqliteDatabaseEvent
{
    self.dataRows = [MySingleton sharedManager].dataManager.arrayAllRemindersFromSQLiteDatabase;
    
    mainTableView.hidden = false;
    [mainTableView reloadData];
    
    if(self.dataRows.count <= 0)
    {
        mainTableView.scrollEnabled = false;
        
        btnCancelAllReminders.hidden = true;
    }
}

#pragma mark - Navigation Bar Methods

-(void)setNavigationBar
{
    navigationBarView.backgroundColor = [MySingleton sharedManager].navigationBarBackgroundColor;
    
    imageViewMenu.layer.masksToBounds = YES;
    [btnMenu addTarget:self action:@selector(btnMenuClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    imageViewSearch.layer.masksToBounds = YES;
    [btnSearch addTarget:self action:@selector(btnSearchClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    imageViewAdd.layer.masksToBounds = YES;
    [btnAdd addTarget:self action:@selector(btnAddClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    lblNavigationTitle.text = [NSString stringWithFormat:@"REMINDERS"];
    lblNavigationTitle.textColor = [MySingleton sharedManager].navigationBarTitleColor;
    lblNavigationTitle.font = [MySingleton sharedManager].navigationBarTitleFont;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        if(lblNavigationTitle.text.length > 32)
        {
            lblNavigationTitle.font = [MySingleton sharedManager].navigationBarTitleSmallFont;
        }
    }
    else
    {
        if(([MySingleton sharedManager].screenHeight == 480 || [MySingleton sharedManager].screenHeight == 568) && lblNavigationTitle.text.length > 18)
        {
            lblNavigationTitle.font = [MySingleton sharedManager].navigationBarTitleSmallFont;
        }
        else if([MySingleton sharedManager].screenHeight == 667 && lblNavigationTitle.text.length > 20)
        {
            lblNavigationTitle.font = [MySingleton sharedManager].navigationBarTitleSmallFont;
        }
        else if([MySingleton sharedManager].screenHeight >= 736 && lblNavigationTitle.text.length > 22)
        {
            lblNavigationTitle.font = [MySingleton sharedManager].navigationBarTitleSmallFont;
        }
    }
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

-(IBAction)btnAddClicked:(id)sender
{
    [self.view endEditing:YES];
    
    User_AddPetCareRemindeViewController *viewController;
    
    viewController = [[User_AddPetCareRemindeViewController alloc] initWithNibName:@"User_AddPetCareRemindeViewController" bundle:nil];
    
    /*
    if([MySingleton sharedManager].screenHeight == 812)
    {
        viewController = [[User_AddPetCareRemindeViewController alloc] initWithNibName:@"User_AddPetCareRemindeViewController_iPhone10" bundle:nil];
    }
    
    else
    {
        viewController = [[User_AddPetCareRemindeViewController alloc] initWithNibName:@"User_AddPetCareRemindeViewController" bundle:nil];
    }
    */
    
    if(self.dataRows.count > 0)
    {
        viewController.intAlreadyAddedNumberOfReminders = self.dataRows.count;
    }
    else
    {
        viewController.intAlreadyAddedNumberOfReminders = 0;
    }
    
    [self.navigationController pushViewController:viewController animated:YES];
}

-(IBAction)btnSearchClicked:(id)sender
{
    [self.view endEditing:YES];
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
    
    UIFont *btnCancelAllRemindersFont;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        btnCancelAllRemindersFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
    }
    else
    {
        if([MySingleton sharedManager].screenHeight == 480)
        {
            btnCancelAllRemindersFont = [MySingleton sharedManager].themeFontFourteenSizeBold;
        }
        else if([MySingleton sharedManager].screenHeight == 568)
        {
            btnCancelAllRemindersFont = [MySingleton sharedManager].themeFontFourteenSizeBold;
        }
        else if([MySingleton sharedManager].screenHeight == 667)
        {
            btnCancelAllRemindersFont = [MySingleton sharedManager].themeFontFifteenSizeBold;
        }
        else if([MySingleton sharedManager].screenHeight >= 736)
        {
            btnCancelAllRemindersFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
        }
    }
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.backgroundColor = [UIColor whiteColor];
    mainTableView.hidden = true;
    
    [btnCancelAllReminders setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    btnCancelAllReminders.backgroundColor = [MySingleton sharedManager].themeGlobalGreenColor;
    btnCancelAllReminders.titleLabel.font = btnCancelAllRemindersFont;
    [btnCancelAllReminders addTarget:self action:@selector(btnCancelAllRemindersClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [[MySingleton sharedManager].dataManager createDatabaseTable];
}

#pragma mark - UITableViewController Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == mainTableView)
    {
        return 1;
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == mainTableView)
    {
        if(self.dataRows.count > 0)
        {
            return self.dataRows.count;
        }
        else
        {
            return 1;
        }
    }
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == mainTableView)
    {
        if(self.dataRows.count > 0)
        {
            return 120;
        }
        else
        {
            return 44;
        }
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Cell";
    
    if(tableView == mainTableView)
    {
        if(self.dataRows.count > 0)
        {
            ScheduledReminderTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
            
            cell = [[ScheduledReminderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
            
            Reminder *objReminder = [self.dataRows objectAtIndex:indexPath.row];
            
            [[AsyncImageLoader sharedLoader].cache removeAllObjects];
            cell.imageViewPetImage.imageURL = [NSURL URLWithString:objReminder.strReminderPetImageUrl];
            
            cell.lblPetName.text = [NSString stringWithFormat:@"%@", objReminder.strReminderPetName];
            cell.lblPetType.text = [NSString stringWithFormat:@"TYPE : %@", objReminder.strReminderPetType];
            
            cell.lblMedicineName.text = [NSString stringWithFormat:@"Medicine Name : %@", objReminder.strReminderMedicineName];
            cell.lblMedicineQuantity.text = [NSString stringWithFormat:@"Quantity : %@", objReminder.strReminderQuantity];
            cell.lblMedicineDateAndTime.text = [NSString stringWithFormat:@"Date and Time : %@", objReminder.strReminderDateAndTime];
            
            cell.btnCancelReminder.tag = indexPath.row;
            [cell.btnCancelReminder addTarget:self action:@selector(btnCancelReminderClicked:) forControlEvents:UIControlEventTouchUpInside];
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            
            return cell;
        }
        else
        {
            UIFont *lblNoDataFont;
            
            if([MySingleton sharedManager].screenHeight == 480)
            {
                lblNoDataFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
            }
            else if([MySingleton sharedManager].screenHeight == 568)
            {
                lblNoDataFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
            }
            else if([MySingleton sharedManager].screenHeight == 667)
            {
                lblNoDataFont = [MySingleton sharedManager].themeFontFifteenSizeRegular;
            }
            else
            {
                lblNoDataFont = [MySingleton sharedManager].themeFontSixteenSizeRegular;
            }
            
            UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:MyIdentifier];
            
            UILabel *lblNoData = [[UILabel alloc] initWithFrame:CGRectMake(0.0f, 0.0f, mainTableView.frame.size.width, cell.frame.size.height)];
            lblNoData.textAlignment = NSTextAlignmentCenter;
            lblNoData.font = lblNoDataFont;
            lblNoData.textColor = [MySingleton sharedManager].themeGlobalLightGreyColor;
            lblNoData.text = @"No Reminder Added.";
            
            [cell.contentView addSubview:lblNoData];
            
            return cell;
        }
    }
    
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.view endEditing:true];
    
//    if(tableView == mainTableView)
//    {
//        if(self.dataRows.count > 0)
//        {
//            Reminder *objReminder = [self.dataRows objectAtIndex:indexPath.row];
//            
//            NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
//            alertViewController.title = @"";
//            alertViewController.message = @"Are you sure you want to cancel this reminded?";
//            
//            alertViewController.view.tintColor = [UIColor whiteColor];
//            alertViewController.backgroundTapDismissalGestureEnabled = YES;
//            alertViewController.swipeDismissalGestureEnabled = YES;
//            alertViewController.transitionStyle = NYAlertViewControllerTransitionStyleFade;
//            
//            alertViewController.titleFont = [MySingleton sharedManager].alertViewTitleFont;
//            alertViewController.messageFont = [MySingleton sharedManager].alertViewMessageFont;
//            alertViewController.buttonTitleFont = [MySingleton sharedManager].alertViewButtonTitleFont;
//            alertViewController.cancelButtonTitleFont = [MySingleton sharedManager].alertViewCancelButtonTitleFont;
//            
//            [alertViewController addAction:[NYAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action){
//                
//                [alertViewController dismissViewControllerAnimated:YES completion:nil];
//                
//                [self cancelParticularNotificationWithKey:objReminder.strReminderUniqueID];
//            }]];
//            
//            [alertViewController addAction:[NYAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(NYAlertAction *action){
//                
//                [alertViewController dismissViewControllerAnimated:YES completion:nil];
//                
//            }]];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self presentViewController:alertViewController animated:YES completion:nil];
//            });
//        }
//    }
}

#pragma mark - Other Methods

-(void)doneClicked:(id)sender
{
    [self.view endEditing:YES];
}

-(IBAction)btnCancelAllRemindersClicked:(id)sender
{
    [self.view endEditing:YES];
    
    [self cancelAllNotifications];
}

-(IBAction)btnCancelReminderClicked:(id)sender
{
    UIButton *btnSender = (UIButton *)sender;
    
    if(self.dataRows.count > 0)
    {
        Reminder *objReminder = [self.dataRows objectAtIndex:btnSender.tag];
        
        NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
        alertViewController.title = @"";
        alertViewController.message = @"Are you sure you want to cancel this reminded?";
        
        alertViewController.view.tintColor = [UIColor whiteColor];
        alertViewController.backgroundTapDismissalGestureEnabled = YES;
        alertViewController.swipeDismissalGestureEnabled = YES;
        alertViewController.transitionStyle = NYAlertViewControllerTransitionStyleFade;
        
        alertViewController.titleFont = [MySingleton sharedManager].alertViewTitleFont;
        alertViewController.messageFont = [MySingleton sharedManager].alertViewMessageFont;
        alertViewController.buttonTitleFont = [MySingleton sharedManager].alertViewButtonTitleFont;
        alertViewController.cancelButtonTitleFont = [MySingleton sharedManager].alertViewCancelButtonTitleFont;
        
        [alertViewController addAction:[NYAlertAction actionWithTitle:@"YES" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action){
            
            [alertViewController dismissViewControllerAnimated:YES completion:nil];
            
            [self cancelParticularNotificationWithKey:objReminder.strReminderUniqueID];
        }]];
        
        [alertViewController addAction:[NYAlertAction actionWithTitle:@"NO" style:UIAlertActionStyleCancel handler:^(NYAlertAction *action){
            
            [alertViewController dismissViewControllerAnimated:YES completion:nil];
            
        }]];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:alertViewController animated:YES completion:nil];
        });
    }
}

-(void)cancelParticularNotificationWithKey:(NSString *)strReminderUniqueId
{
//    NSArray *arrayLocalNotifications = [[[UIApplication sharedApplication] scheduledLocalNotifications] copy];
//    NSLog(@"arrayLocalNotifications.count : %d", arrayLocalNotifications.count);
//    NSLog(@"self.dataRows.count : %d", self.dataRows.count);
//
//    for (UILocalNotification *notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy])
//    {
//        NSDictionary *userInfo = notification.userInfo;
//
//        NSString *strUniqueId = [userInfo objectForKey:@"UniqueId"];
//        NSLog(@"strUniqueId : %@", strUniqueId);
//    }
    
    for (UILocalNotification *notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if ([[userInfo objectForKey:@"UniqueId"] isEqualToString:strReminderUniqueId])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
            
            [[MySingleton sharedManager].dataManager user_deleteAReminderFromSqliteDatabase:strReminderUniqueId];
        }
    }
}

-(void)cancelAllNotifications
{
    //========== Cancelling All Scheduled Notifications ==========//
//    UIApplication *app = [UIApplication sharedApplication];
//    NSArray *oldNotifications = [app scheduledLocalNotifications];
//
//    if ([oldNotifications count] > 0)
//        [app cancelAllLocalNotifications];
    
    for (UILocalNotification *notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy])
    {
        NSDictionary *userInfo = notification.userInfo;
        NSString *strUniqueId = [userInfo objectForKey:@"UniqueId"];
        
        if (strUniqueId != nil && strUniqueId.length > 0)
        {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
    
    [[MySingleton sharedManager].dataManager user_deleteAllRemindersFromSqliteDatabase];
}

@end
