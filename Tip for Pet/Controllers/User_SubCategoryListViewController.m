//
//  User_SubCategoryListViewController.m
//  Tip for Pet
//
//  Created by Pratik Gujarati on 28/07/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "User_SubCategoryListViewController.h"
#import "MySingleton.h"

#import "IQKeyboardManager.h"

#import "SubCategory.h"
#import "SubCategoryTableViewCell.h"

#import "User_AdviceListViewController.h"

@interface User_SubCategoryListViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}

@end

@implementation User_SubCategoryListViewController

//========== IBOUTLETS ==========//

@synthesize mainScrollView;

@synthesize navigationBarView;
@synthesize imageViewBack;
@synthesize btnBack;
@synthesize lblNavigationTitle;

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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotAllSubCategoriesEvent) name:@"gotAllSubCategoriesEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)gotAllSubCategoriesEvent
{
    self.dataRows = [MySingleton sharedManager].dataManager.arraySubCategories;
    
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
    
    imageViewBack.layer.masksToBounds = YES;
    [btnBack addTarget:self action:@selector(btnBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    lblNavigationTitle.text = [NSString stringWithFormat:@"SUBCATEGORY"];
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

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    [[MySingleton sharedManager].dataManager getAllSubCategories:self.objSelectedCategory.strCategoryId];
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
    
    if (self.dataRows.count > 0)
    {
        SubCategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        SubCategory *objSubCategory = [self.dataRows objectAtIndex:indexPath.row];
        
        cell = [[SubCategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        
        if(indexPath.row % 2 == 0)
        {
            cell.mainContainer.backgroundColor = [MySingleton sharedManager].themeGlobalLightGreenColor;
        }
        
        cell.imageViewSubCategoryPicture.imageURL = [NSURL URLWithString:objSubCategory.strSubCategoryImageUrl];
        
        cell.lblSubCategoryName.text = objSubCategory.strSubCategoryName;
        [cell.lblSubCategoryName sizeToFit];
        
        cell.btnFindOutMore.tag = indexPath.row;
        [cell.btnFindOutMore addTarget:self action:@selector(btnFindOutMoreClicked:) forControlEvents:UIControlEventTouchUpInside];
        
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
        lblNoData.text = @"No subcategory found.";
        
        [cell.contentView addSubview:lblNoData];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataRows.count > 0)
    {
        SubCategory *objSubCategory = [self.dataRows objectAtIndex:indexPath.row];
        
        [self subCategoryItemClicked:objSubCategory];
    }
}

#pragma mark - Other Methods
-(IBAction)btnFindOutMoreClicked:(id)sender
{
    UIButton *btnSender = (UIButton *)sender;
    
    if(self.dataRows.count > 0)
    {
        SubCategory *objSubCategory = [self.dataRows objectAtIndex:btnSender.tag];
        
        [self subCategoryItemClicked:objSubCategory];
    }
}

-(void)subCategoryItemClicked:(SubCategory *)objSubCategory
{
    User_AdviceListViewController *viewController;
    
    viewController = [[User_AdviceListViewController alloc] initWithNibName:@"User_AdviceListViewController" bundle:nil];
    
    /*
    if([MySingleton sharedManager].screenHeight == 812)
    {
        viewController = [[User_AdviceListViewController alloc] initWithNibName:@"User_AdviceListViewController_iPhone10" bundle:nil];
    }
    
    else
    {
        viewController = [[User_AdviceListViewController alloc] initWithNibName:@"User_AdviceListViewController" bundle:nil];
    }
    */
    
    viewController.objSelectedSubCategory = objSubCategory;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
