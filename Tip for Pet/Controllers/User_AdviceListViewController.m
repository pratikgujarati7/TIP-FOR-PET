//
//  User_AdviceListViewController.m
//  Tip for Pet
//
//  Created by Pratik Gujarati on 29/07/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "User_AdviceListViewController.h"
#import "MySingleton.h"

#import "IQKeyboardManager.h"

#import "Advice.h"
#import "AdviceListTableViewCell.h"

#import "User_AdviceDetailsViewController.h"

@interface User_AdviceListViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}

@end

@implementation User_AdviceListViewController

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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotAllAdvicesEvent) name:@"gotAllAdvicesEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)gotAllAdvicesEvent
{
    self.dataRows = [MySingleton sharedManager].dataManager.arrayAdvices;
    
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
    
    lblNavigationTitle.text = [NSString stringWithFormat:@"ADVICES"];
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
    
    [[MySingleton sharedManager].dataManager getAllAdvices:self.objSelectedSubCategory.strSubCategoryId];
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
        Advice *objAdvice = [self.dataRows objectAtIndex:indexPath.row];
        
        if(objAdvice.strAdviceTitle.length > 0)
        {
            UILabel *lblAdviceTitle = [[UILabel alloc] initWithFrame:CGRectMake(80, 25, ([MySingleton sharedManager].screenWidth - 90), 60)];
            lblAdviceTitle.font = [MySingleton sharedManager].themeFontTwentySizeRegular;
            lblAdviceTitle.numberOfLines = 0;
            lblAdviceTitle.text = objAdvice.strAdviceTitle;
            [lblAdviceTitle sizeToFit];
            
            CGRect lblAdviceTitleTextRect = [lblAdviceTitle.text boundingRectWithSize:lblAdviceTitle.frame.size
                                                                              options:NSStringDrawingUsesLineFragmentOrigin
                                                                           attributes:@{NSFontAttributeName:lblAdviceTitle.font}
                                                                              context:nil];
            
            CGSize lblAdviceTitleSize = lblAdviceTitleTextRect.size;
            
            CGFloat lblAdviceTitleHeight = lblAdviceTitleSize.height;
            
            CGFloat floatCellHeight = lblAdviceTitle.frame.origin.y + lblAdviceTitleHeight + 10;
            
            if(floatCellHeight > 95)
            {
                return floatCellHeight;
            }
            else
            {
                return 95;
            }
        }
        else
        {
            return 95;
        }
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
        AdviceListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        Advice *objAdvice = [self.dataRows objectAtIndex:indexPath.row];
        
        cell = [[AdviceListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        
        cell.lblAdviceTitle.text = objAdvice.strAdviceTitle;
        //        [cell.lblAdviceTitle sizeToFit];
        
        CGFloat lblAdviceTitleHeight;
        
        if(objAdvice.strAdviceTitle.length > 0)
        {
            CGRect lblAdviceTitleTextRect = [cell.lblAdviceTitle.text boundingRectWithSize:cell.lblAdviceTitle.frame.size
                                                                                   options:NSStringDrawingUsesLineFragmentOrigin
                                                                                attributes:@{NSFontAttributeName:cell.lblAdviceTitle.font}
                                                                                   context:nil];
            
            CGSize lblAdviceTitleSize = lblAdviceTitleTextRect.size;
            
            lblAdviceTitleHeight = lblAdviceTitleSize.height;
        }
        else
        {
            lblAdviceTitleHeight = 0;
        }
        
        CGFloat floatCellHeight = cell.lblAdviceTitle.frame.origin.y + lblAdviceTitleHeight + 10;
        
        CGRect mainContainerFrame = cell.mainContainer.frame;
        
        if(floatCellHeight > 95)
        {
            [cell.lblAdviceTitle sizeToFit];
            
            mainContainerFrame.size.height = floatCellHeight;
            
            CGRect lblAdviceTitleFrame = cell.lblAdviceTitle.frame;
            lblAdviceTitleFrame.size.height = lblAdviceTitleHeight;
            cell.lblAdviceTitle.frame = lblAdviceTitleFrame;
        }
        else
        {
            mainContainerFrame.size.height = 95;
        }
        
        cell.mainContainer.frame = mainContainerFrame;
        
        CGRect imageViewInfoFrame = cell.imageViewInfo.frame;
        imageViewInfoFrame.origin.y = (mainContainerFrame.size.height - cell.imageViewInfo.frame.size.height)/2;
        cell.imageViewInfo.frame = imageViewInfoFrame;
        
        CGRect separatorViewFrame = cell.separatorView.frame;
        separatorViewFrame.origin.y = cell.mainContainer.frame.size.height - 1;
        cell.separatorView.frame = separatorViewFrame;
        
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
        lblNoData.text = @"No advice found.";
        
        [cell.contentView addSubview:lblNoData];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataRows.count > 0)
    {
        Advice *objAdvice = [self.dataRows objectAtIndex:indexPath.row];
        
        [self adviceItemClicked:objAdvice];
    }
}

#pragma mark - Other Methods

-(IBAction)btnFindOutMoreClicked:(id)sender
{
    UIButton *btnSender = (UIButton *)sender;
    
    if(self.dataRows.count > 0)
    {
        Advice *objAdvice = [self.dataRows objectAtIndex:btnSender.tag];
        
        [self adviceItemClicked:objAdvice];
    }
}

-(void)adviceItemClicked:(Advice *)objAdvice
{
    User_AdviceDetailsViewController *viewController;
    
    viewController = [[User_AdviceDetailsViewController alloc] initWithNibName:@"User_AdviceDetailsViewController" bundle:nil];
    
    /*
    if([MySingleton sharedManager].screenHeight == 812)
    {
        viewController = [[User_AdviceDetailsViewController alloc] initWithNibName:@"User_AdviceDetailsViewController_iPhone10" bundle:nil];
    }
    
    else
    {
        viewController = [[User_AdviceDetailsViewController alloc] initWithNibName:@"User_AdviceDetailsViewController" bundle:nil];
    }
    */
    
    viewController.objSelectedAdvice = objAdvice;
    [self.navigationController pushViewController:viewController animated:YES];
}

@end
