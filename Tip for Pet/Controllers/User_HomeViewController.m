//
//  User_HomeViewController.m
//  ENZYM
//
//  Created by Pratik Gujarati on 05/05/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "User_HomeViewController.h"
#import "MySingleton.h"

#import "IQKeyboardManager.h"

#import "PetType.h"
#import "PetTypeTableViewCell.h"

#import "User_CategoryListViewController.h"

#define kUnlimitedRemindersProductID @"innovativeiteration.tipforpet.unlimitedreminders"

@interface User_HomeViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}

@end

@implementation User_HomeViewController

//========== IBOUTLETS ==========//

@synthesize mainScrollView;

@synthesize navigationBarView;
@synthesize imageViewMenu;
@synthesize btnMenu;
@synthesize lblNavigationTitle;
@synthesize imageViewOptions;
@synthesize btnOptions;

@synthesize mainContainerView;
@synthesize mainTableView;

//========== OTHER VARIABLES ==========//

#pragma mark - View Controller Delegate Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    for(NSString *familyName in [UIFont familyNames]) {
//        for(NSString *fontName in [UIFont fontNamesForFamilyName:familyName]) {
//            NSLog(@"%@", fontName);
//        }
//    }
    
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
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotAllPetTypesEvent) name:@"gotAllPetTypesEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)gotAllPetTypesEvent
{
    self.dataRows = [MySingleton sharedManager].dataManager.arrayPetTypes;
    
    if(self.dataRows.count > 0)
    {
        self.arrayInAppPurchaseProductIdentifiers = [[NSMutableArray alloc] init];
        self.arrayInAppPurchaseProductFlagNames = [[NSMutableArray alloc] init];
        
        for(int i = 0; i < self.dataRows.count; i++)
        {
            PetType *objPetType = [self.dataRows objectAtIndex:i];
            
            if(objPetType.boolPetTypeIsPaid && objPetType.strPetTypeInAppPurchaseProductIdentifier.length > 0 && objPetType.strPetTypeInAppPurchaseProductFlagName.length > 0)
            {
                [self.arrayInAppPurchaseProductIdentifiers addObject:objPetType.strPetTypeInAppPurchaseProductIdentifier];
                [self.arrayInAppPurchaseProductFlagNames addObject:objPetType.strPetTypeInAppPurchaseProductFlagName];
            }
        }
        
        [self fetchAvailableProducts];
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
    
    imageViewOptions.layer.masksToBounds = YES;
    [btnOptions addTarget:self action:@selector(btnOptionsClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    lblNavigationTitle.text = [NSString stringWithFormat:@"SELECT YOUR PET"];
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

-(IBAction)btnOptionsClicked:(id)sender
{
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:@"Options" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Dismiss button tappped.
        
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Restore Purchases" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
        [self restoreInAppPurchases];
    }]];
    
    [self presentViewController:actionSheet animated:YES completion:nil];
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
    
//    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
//    
//    NSString *strUserId = [prefs objectForKey:@"userid"];
//    NSString *strAutoLogin = [prefs objectForKey:@"autologin"];
//    
//    if((strUserId != nil && strUserId.length > 0) && ([strAutoLogin isEqualToString:@"1"]))
//    {
//        NSLog(@"User Logged In.");
//    }
//    else
//    {
//        NSLog(@"User Not Logged In.");
//        
//        imageViewMenu.hidden = true;
//        btnMenu.hidden = true;
//        
//        imageViewOptions.hidden = true;
//        btnOptions.hidden = true;
//    }
    
    [[MySingleton sharedManager].dataManager getAllPetTypes];
}

#pragma mark - In-App Purchase Methods

-(void)fetchAvailableProducts
{
    //FIXME:- Remove after issues found
    [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
    
    NSArray *arrayInAppPurchaseProductIdentifiersLocal = [self.arrayInAppPurchaseProductIdentifiers copy];
    
    NSSet *productIdentifiers = [NSSet setWithArray:arrayInAppPurchaseProductIdentifiersLocal];
    
    productsRequest = [[SKProductsRequest alloc]
                       initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}

- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

- (void)purchaseItem:(SKProduct*)product
{
    if ([self canMakePurchases])
    {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showErrorAlertViewWithTitle:@"" withDetails:@"Purchases are disabled on your device"];
        });
    }
}

- (void)restoreInAppPurchases
{
    if ([self canMakePurchases])
    {
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showErrorAlertViewWithTitle:@"" withDetails:@"Purchases are disabled on your device"];
        });
    }
}

#pragma mark - StoreKit Delegate Methods

-(void)paymentQueue:(SKPaymentQueue *)queue
updatedTransactions:(NSArray *)transactions
{
    for (SKPaymentTransaction *transaction in transactions)
    {
        switch (transaction.transactionState)
        {
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Purchasing");
                [appDelegate showGlobalProgressHUDWithTitle:@"Purchasing..."];
                
                break;
                
            case SKPaymentTransactionStatePurchased:
                [appDelegate dismissGlobalHUD];
                
                NSInteger indexOfObject = [self.arrayInAppPurchaseProductIdentifiers indexOfObject:transaction.payment.productIdentifier];
                
                if(indexOfObject != NSNotFound)
                {
                    NSString *strFlagName = [self.arrayInAppPurchaseProductFlagNames objectAtIndex:indexOfObject];
                    
                    NSLog(@"Purchased");
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:@"1" forKey:strFlagName];
                    [userDefaults synchronize];
                    
                    NSString *strAlertMessage = [NSString stringWithFormat:@"You have successfully purchased tips for %@.", strFlagName];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [appDelegate showErrorAlertViewWithTitle:@"" withDetails:strAlertMessage];
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [appDelegate showErrorAlertViewWithTitle:@"" withDetails:@"Failed to purchase this product. Please try again after some time."];
                    });
                }
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                [appDelegate dismissGlobalHUD];
                
                NSInteger indexOfRestoringObject = [self.arrayInAppPurchaseProductIdentifiers indexOfObject:transaction.payment.productIdentifier];
                
                if(indexOfRestoringObject != NSNotFound)
                {
                    NSString *strFlagName = [self.arrayInAppPurchaseProductFlagNames objectAtIndex:indexOfRestoringObject];
                    
                    NSLog(@"Restored");
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:@"1" forKey:strFlagName];
                    [userDefaults synchronize];
                    
                    NSString *strAlertMessage = [NSString stringWithFormat:@"You have successfully restored your purchases for tips of %@.", strFlagName];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [appDelegate showErrorAlertViewWithTitle:@"" withDetails:strAlertMessage];
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [appDelegate showErrorAlertViewWithTitle:@"" withDetails:@"Failed to restore your purchases. Please try again after some time."];
                    });
                }
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateFailed:
                [appDelegate dismissGlobalHUD];
                
                NSLog(@"Purchase failed ");
                [self failedTransaction:transaction];
                break;
                
            default:
                [appDelegate dismissGlobalHUD];
                break;
        }
    }
}

- (void)failedTransaction:(SKPaymentTransaction *)transaction {
    
    NSLog(@"failedTransaction...");
    if (transaction.error.code != SKErrorPaymentCancelled)
    {
        NSLog(@"Transaction error: %@", transaction.error.localizedDescription);
    }
    
    [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegate showErrorAlertViewWithTitle:@"Transaction error" withDetails:transaction.error.localizedDescription];
    });
}

-(void)productsRequest:(SKProductsRequest *)request
    didReceiveResponse:(SKProductsResponse *)response
{
    [appDelegate dismissGlobalHUD];
    
    SKProduct *validProduct = nil;
    int count = [response.products count];
    if (count > 0)
    {
        validProducts = response.products;
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showErrorAlertViewWithTitle:@"No Products Available" withDetails:@"No products to purchase"];
        });
    }
    
    for (int i = 0; i < validProducts.count; i++)
    {
        SKProduct *validProduct1 = [validProducts objectAtIndex:i];
        
        NSLog(@"Product Title : %@", [NSString stringWithFormat:
                                      @"Product Title: %@",validProduct1.localizedTitle]);
        NSLog(@"Product Desc : %@", [NSString stringWithFormat:
                                     @"Product Desc: %@",validProduct1.localizedDescription]);
        NSLog(@"Product Price : %@", [NSString stringWithFormat:
                                      @"Product Price: %@",validProduct1.price]);
    }
}

- (void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue
{
    [appDelegate dismissGlobalHUD];
    
    NSLog(@"%@",queue );
    NSLog(@"Restored Transactions are once again in Queue for purchasing %@",[queue transactions]);
    
    NSMutableArray *purchasedItemIDs = [[NSMutableArray alloc] init];
    NSLog(@"received restored transactions: %i", queue.transactions.count);
    
    for (SKPaymentTransaction *transaction in queue.transactions)
    {
        NSString *productID = transaction.payment.productIdentifier;
        [purchasedItemIDs addObject:productID];
        NSLog (@"product id is %@" , productID);
    }
    
    for(int i = 0; i < purchasedItemIDs.count; i++)
    {
        NSString *purchasedProductIdentifier = [purchasedItemIDs objectAtIndex:i];
        
        NSInteger indexOfObject = [self.arrayInAppPurchaseProductIdentifiers indexOfObject:purchasedProductIdentifier];
        
        if(indexOfObject != NSNotFound)
        {
            NSString *strFlagName = [self.arrayInAppPurchaseProductFlagNames objectAtIndex:indexOfObject];
            
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"1" forKey:strFlagName];
            [userDefaults synchronize];
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegate showErrorAlertViewWithTitle:@"" withDetails:@"You have successfully restored your purchases."];
    });
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
        PetType *objPetType = [self.dataRows objectAtIndex:indexPath.row];
        
        if(objPetType.strPetTypeDescription.length > 0)
        {
            UILabel *lblPetTypeDescription = [[UILabel alloc] initWithFrame:CGRectMake(80, 45, ([MySingleton sharedManager].screenWidth - 90), 30)];
            lblPetTypeDescription.font = [MySingleton sharedManager].themeFontTenSizeRegular;
            lblPetTypeDescription.numberOfLines = 0;
            lblPetTypeDescription.text = objPetType.strPetTypeDescription;
            [lblPetTypeDescription sizeToFit];
            
            CGRect lblPetTypeDescriptionTextRect = [lblPetTypeDescription.text boundingRectWithSize:lblPetTypeDescription.frame.size
                                                                                                options:NSStringDrawingUsesLineFragmentOrigin
                                                                                             attributes:@{NSFontAttributeName:lblPetTypeDescription.font}
                                                                                                context:nil];
            
            CGSize lblPetTypeDescriptionSize = lblPetTypeDescriptionTextRect.size;
            
            CGFloat lblPetTypeDescriptionHeight = lblPetTypeDescriptionSize.height;
            
            CGFloat floatCellHeight = lblPetTypeDescription.frame.origin.y + lblPetTypeDescriptionHeight + 45;
            
            if(floatCellHeight > 120)
            {
                return floatCellHeight;
            }
            else
            {
                return 120;
            }
        }
        else
        {
            return 120;
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
        PetTypeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
        
        PetType *objPetType = [self.dataRows objectAtIndex:indexPath.row];
        
        cell = [[PetTypeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:MyIdentifier];
        
        cell.imageViewPetTypePicture.imageURL = [NSURL URLWithString:objPetType.strPetTypePictureImageUrl];
                
        cell.lblPetType.text = objPetType.strPetType;
        
        cell.lblPetTypeDescription.text = objPetType.strPetTypeDescription;
        [cell.lblPetTypeDescription sizeToFit];
        
        cell.btnGetTips.tag = indexPath.row;
        [cell.btnGetTips addTarget:self action:@selector(btnGetTipsClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat lblPetTypeDescriptionHeight;
        
        if(objPetType.strPetTypeDescription.length > 0)
        {
            CGRect lblPetTypeDescriptionTextRect = [cell.lblPetTypeDescription.text boundingRectWithSize:cell.lblPetTypeDescription.frame.size
                                                                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                                                                  attributes:@{NSFontAttributeName:cell.lblPetTypeDescription.font}
                                                                                                     context:nil];
            
            CGSize lblPetTypeDescriptionSize = lblPetTypeDescriptionTextRect.size;
            
            lblPetTypeDescriptionHeight = lblPetTypeDescriptionSize.height;
        }
        else
        {
            lblPetTypeDescriptionHeight = 0;
        }
        
        CGFloat floatCellHeight = cell.lblPetTypeDescription.frame.origin.y + lblPetTypeDescriptionHeight + 45;
        
        CGRect mainContainerFrame = cell.mainContainer.frame;
        
        if(floatCellHeight > 120)
        {
            mainContainerFrame.size.height = floatCellHeight;
        }
        else
        {
            mainContainerFrame.size.height = 120;
        }
        
        cell.mainContainer.frame = mainContainerFrame;
        
        CGRect imageViewPetTypePictureFrame = cell.imageViewPetTypePicture.frame;
        imageViewPetTypePictureFrame.origin.y = (cell.mainContainer.frame.size.height - cell.imageViewPetTypePicture.frame.size.height)/2;
        cell.imageViewPetTypePicture.frame = imageViewPetTypePictureFrame;
        
        CGRect lblPetTypeDescriptionFrame = cell.lblPetTypeDescription.frame;
        lblPetTypeDescriptionFrame.size.height = lblPetTypeDescriptionHeight;
        cell.lblPetTypeDescription.frame = lblPetTypeDescriptionFrame;
        
        if(floatCellHeight > 120)
        {
            CGRect btnGetTipsFrame = cell.btnGetTips.frame;
            btnGetTipsFrame.origin.y = (cell.lblPetTypeDescription.frame.origin.y + lblPetTypeDescriptionHeight + 5);
            cell.btnGetTips.frame = btnGetTipsFrame;
        }
        
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
        lblNoData.text = @"No pet type found.";
        
        [cell.contentView addSubview:lblNoData];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.dataRows.count > 0)
    {
        PetType *objPetType = [self.dataRows objectAtIndex:indexPath.row];
        
        [self petTypeItemClicked:objPetType];
    }
}

#pragma mark - Other Methods

-(IBAction)btnGetTipsClicked:(id)sender
{
    UIButton *btnSender = (UIButton *)sender;
    
    if(self.dataRows.count > 0)
    {
        PetType *objPetType = [self.dataRows objectAtIndex:btnSender.tag];
        
        [self petTypeItemClicked:objPetType];
    }
}

-(void)petTypeItemClicked:(PetType *)objPetType
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
//    NSString *strUserId = [prefs objectForKey:@"userid"];
//    NSString *strAutoLogin = [prefs objectForKey:@"autologin"];
//    
//    if((strUserId != nil && strUserId.length > 0) && ([strAutoLogin isEqualToString:@"1"]))
//    {
        if(objPetType.boolPetTypeIsPaid)
        {
            NSLog(@"Paid");
            
            NSUserDefaults *defaults= [NSUserDefaults standardUserDefaults];
            if([[[defaults dictionaryRepresentation] allKeys] containsObject:objPetType.strPetTypeInAppPurchaseProductFlagName])
            {
                NSLog(@"Purchased");
            
                User_CategoryListViewController *viewController;
                
                viewController = [[User_CategoryListViewController alloc] initWithNibName:@"User_CategoryListViewController" bundle:nil];
                
                /*
                if([MySingleton sharedManager].screenHeight == 812)
                {
                    viewController = [[User_CategoryListViewController alloc] initWithNibName:@"User_CategoryListViewController_iPhone10" bundle:nil];
                }
                
                else
                {
                    viewController = [[User_CategoryListViewController alloc] initWithNibName:@"User_CategoryListViewController" bundle:nil];
                }
                */
                
                viewController.objSelectedPetType = objPetType;
                [self.navigationController pushViewController:viewController animated:YES];
            }
            else
            {
                NSLog(@"Not Purchased");
                
                if(validProducts.count > 0)
                {
                    NSInteger indexOfObject = [self.arrayInAppPurchaseProductIdentifiers indexOfObject:objPetType.strPetTypeInAppPurchaseProductIdentifier];
                    
                    if(indexOfObject != NSNotFound)
                    {
                        [self purchaseItem:[validProducts objectAtIndex:indexOfObject]];
                    }
                    else
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [appDelegate showErrorAlertViewWithTitle:@"" withDetails:@"This product is not available for purchase right now. Please try again after some time."];
                        });
                    }
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [appDelegate showErrorAlertViewWithTitle:@"" withDetails:@"No products to purchase"];
                    });
                }
            }
        }
        else
        {
            NSLog(@"Free");
            
            User_CategoryListViewController *viewController;
            
            viewController = [[User_CategoryListViewController alloc] initWithNibName:@"User_CategoryListViewController" bundle:nil];
            
            /*
            if([MySingleton sharedManager].screenHeight == 812)
            {
                viewController = [[User_CategoryListViewController alloc] initWithNibName:@"User_CategoryListViewController_iPhone10" bundle:nil];
            }
            
            else
            {
                viewController = [[User_CategoryListViewController alloc] initWithNibName:@"User_CategoryListViewController" bundle:nil];
            }
            */
            
            viewController.objSelectedPetType = objPetType;
            [self.navigationController pushViewController:viewController animated:YES];
        }
//    }
//    else
//    {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [appDelegate showErrorAlertViewWithTitle:@"" withDetails:@"Please register or login to view tips."];
//        });
//    }
}

@end
