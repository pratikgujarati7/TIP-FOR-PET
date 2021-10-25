//
//  User_MyPetsListViewController.m
//  Tip for Pet
//
//  Created by Pratik Gujarati on 02/08/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "User_MyPetsListViewController.h"
#import "MySingleton.h"

#import "IQKeyboardManager.h"

#import "Pet.h"
#import "MyPetListTableViewCell.h"

#import "User_AddMyPetViewController.h"
#import "User_UpdateMyPetViewController.h"

@interface User_MyPetsListViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}

@end

@implementation User_MyPetsListViewController

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
    
    if([MySingleton sharedManager].dataManager.boolIsPetAddedSuccessfully || [MySingleton sharedManager].dataManager.boolIsPetUpdatedSuccessfully || [MySingleton sharedManager].dataManager.boolIsPetImageChangedSuccessfully)
    {
        if([MySingleton sharedManager].dataManager.boolIsPetAddedSuccessfully)
        {
            [MySingleton sharedManager].dataManager.boolIsPetAddedSuccessfully = false;
        }
        else if([MySingleton sharedManager].dataManager.boolIsPetUpdatedSuccessfully)
        {
            [MySingleton sharedManager].dataManager.boolIsPetUpdatedSuccessfully = false;
        }
        else if([MySingleton sharedManager].dataManager.boolIsPetImageChangedSuccessfully)
        {
            [MySingleton sharedManager].dataManager.boolIsPetImageChangedSuccessfully = false;
        }
        
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [[MySingleton sharedManager].dataManager user_getAllMyPetsByUserId:[prefs objectForKey:@"userid"]];
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_gotAllMyPetsByUserIdEvent) name:@"user_gotAllMyPetsByUserIdEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)user_gotAllMyPetsByUserIdEvent
{
    self.dataRows = [MySingleton sharedManager].dataManager.arrayMyPets;
    
    if(self.dataRows.count <= 0)
    {
        mainTableView.userInteractionEnabled = false;
    }
    
    mainTableView.hidden = false;
    [mainTableView reloadData];
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
    
    lblNavigationTitle.text = [NSString stringWithFormat:@"MY PETS"];
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

-(IBAction)btnSearchClicked:(id)sender
{
    [self.view endEditing:YES];
}

-(IBAction)btnAddClicked:(id)sender
{
    [self.view endEditing:YES];
    
    User_AddMyPetViewController *viewController;
    
    viewController = [[User_AddMyPetViewController alloc] initWithNibName:@"User_AddMyPetViewController" bundle:nil];
    
    /*
    if([MySingleton sharedManager].screenHeight == 812)
    {
        viewController = [[User_AddMyPetViewController alloc] initWithNibName:@"User_AddMyPetViewController_iPhone10" bundle:nil];
    }
    
    else
    {
        viewController = [[User_AddMyPetViewController alloc] initWithNibName:@"User_AddMyPetViewController" bundle:nil];
    }
    */
    
    [self.navigationController pushViewController:viewController animated:YES];
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
    
    mainTableView.delegate = self;
    mainTableView.dataSource = self;
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    mainTableView.backgroundColor = [UIColor whiteColor];
    mainTableView.hidden = true;
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [[MySingleton sharedManager].dataManager user_getAllMyPetsByUserId:[prefs objectForKey:@"userid"]];
}

#pragma mark - UITableViewController Delegate Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
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
    if(self.dataRows.count > 0)
    {
        return self.dataRows.count;
    }
    else
    {
        return 1;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *MyIdentifier = @"Cell";
    
    if(self.dataRows.count > 0)
    {
        MyPetListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        Pet *objPet = [self.dataRows objectAtIndex:indexPath.row];
        
        cell = [[MyPetListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        
        [[AsyncImageLoader sharedLoader].cache removeAllObjects];
        cell.imageViewPetImage.imageURL = [NSURL URLWithString:objPet.strPetImageUrl];
        
        cell.lblPetName.text = objPet.strPetName;
        cell.lblPetType.text = [NSString stringWithFormat:@"TYPE : %@", objPet.strPetTypeName];
        cell.lblPetBreed.text = [NSString stringWithFormat:@"BREED : %@", objPet.strPetBreed];
        cell.lblPetBirthdate.text = [NSString stringWithFormat:@"BIRTHDATE : %@", objPet.strPetBirthdate];
        cell.lblPetGender.text = [NSString stringWithFormat:@"GENDER : %@", objPet.strPetGender];
        
        cell.btnUpdateDetails.tag = indexPath.row;
        [cell.btnUpdateDetails addTarget:self action:@selector(btnUpdateDetailsClicked:) forControlEvents:UIControlEventTouchUpInside];
        
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
        lblNoData.text = @"No pet found.";
        
        [cell.contentView addSubview:lblNoData];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataRows.count > 0)
    {
        Pet *objPet = [self.dataRows objectAtIndex:indexPath.row];
        
        [self petItemClicked:objPet];
    }
}

#pragma mark - Other Methods

-(IBAction)btnUpdateDetailsClicked:(id)sender
{
    UIButton *btnSender = (UIButton *)sender;
    
    if(self.dataRows.count > 0)
    {
        Pet *objPet = [self.dataRows objectAtIndex:btnSender.tag];
        
        [self petItemClicked:objPet];
    }
}

-(void)petItemClicked:(Pet *)objPet
{
    User_UpdateMyPetViewController *viewController;
    
    viewController = [[User_UpdateMyPetViewController alloc] initWithNibName:@"User_UpdateMyPetViewController" bundle:nil];
    
    /*
    if([MySingleton sharedManager].screenHeight == 812)
    {
        viewController = [[User_UpdateMyPetViewController alloc] initWithNibName:@"User_UpdateMyPetViewController_iPhone10" bundle:nil];
    }
    
    else
    {
        viewController = [[User_UpdateMyPetViewController alloc] initWithNibName:@"User_UpdateMyPetViewController" bundle:nil];
    }
    */
    
    viewController.objPetToBeUpdated = objPet;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
