//
//  User_AddPetCareRemindeViewController.m
//  Tip for Pet
//
//  Created by Pratik Gujarati on 03/08/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "User_AddPetCareRemindeViewController.h"
#import "MySingleton.h"

#import "IQKeyboardManager.h"

#define kUnlimitedRemindersProductID @"innovativeiteration.tipforpet.unlimitedreminders"

@interface User_AddPetCareRemindeViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}

@end

@implementation User_AddPetCareRemindeViewController

//========== IBOUTLETS ==========//

@synthesize mainScrollView;

@synthesize navigationBarView;
@synthesize imageViewBack;
@synthesize btnBack;
@synthesize lblNavigationTitle;

@synthesize mainContainerView;

@synthesize txtPetName;
@synthesize txtPetNameBottomSeparatorView;

@synthesize txtMedicineName;
@synthesize txtMedicineNameBottomSeparatorView;

@synthesize txtMedicineQuantity;
@synthesize txtMedicineQuantityBottomSeparatorView;

@synthesize txtMedicineTime;
@synthesize txtMedicineTimeBottomSeparatorView;

@synthesize txtMedicineTillDate;
@synthesize txtMedicineTillDateBottomSeparatorView;

@synthesize btnSetReminder;

//========== OTHER VARIABLES ==========//

@synthesize petPickerView;

@synthesize quantityPickerView;

@synthesize timePicker;
@synthesize tillDatePicker;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
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

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    [self removeNotificationEventObserver];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:true];
    [[IQKeyboardManager sharedManager] setEnable:true];
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
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_addedReminderToSqliteDatabaseEvent) name:@"user_addedReminderToSqliteDatabaseEvent" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createdDatabaseTableEvent) name:@"createdDatabaseTableEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)user_gotAllMyPetsByUserIdEvent
{
    [[MySingleton sharedManager].dataManager createDatabaseTable];
    
    self.arrayPet = [MySingleton sharedManager].dataManager.arrayMyPets;
}

-(void)user_addedReminderToSqliteDatabaseEvent
{
    [MySingleton sharedManager].dataManager.boolIsReminderAddedSuccessfully = true;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegate showErrorAlertViewWithTitle:@"" withDetails:@"You have successfully set reminder(s)."];
    });
}

-(void)createdDatabaseTableEvent
{
    [self fetchAvailableProducts];
}

#pragma mark - Navigation Bar Methods

-(void)setNavigationBar
{
    navigationBarView.backgroundColor = [MySingleton sharedManager].navigationBarBackgroundColor;
    
    imageViewBack.layer.masksToBounds = YES;
    [btnBack addTarget:self action:@selector(btnBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    lblNavigationTitle.text = [NSString stringWithFormat:@"ADD REMINDER"];
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
    if (@available(iOS 11.0, *))
    {
        mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    mainScrollView.delegate = self;
    
    UIFont *txtFieldFont, *btnFont;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        txtFieldFont = [MySingleton sharedManager].themeFontSixteenSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
    }
    else
    {
        if([MySingleton sharedManager].screenHeight == 480)
        {
            txtFieldFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontFourteenSizeBold;
        }
        else if([MySingleton sharedManager].screenHeight == 568)
        {
            txtFieldFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontFourteenSizeBold;
        }
        else if([MySingleton sharedManager].screenHeight == 667)
        {
            txtFieldFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontFifteenSizeBold;
        }
        else if([MySingleton sharedManager].screenHeight >= 736)
        {
            txtFieldFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
        }
    }
    
    petPickerView = [[UIPickerView alloc] init];
    petPickerView.delegate = self;
    petPickerView.dataSource = self;
    petPickerView.showsSelectionIndicator = YES;
    petPickerView.tag = 2;
    petPickerView.backgroundColor = [UIColor whiteColor];
    
    txtPetName.font = txtFieldFont;
    txtPetName.delegate = self;
    txtPetName.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Pet"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtPetName.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtPetName.tintColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtPetName.floatingLabelFont = txtFieldFont;
    txtPetName.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtPetName.keepBaseline = NO;
    [txtPetName setInputView:petPickerView];
    [txtPetName setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    txtPetNameBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    txtMedicineName.font = txtFieldFont;
    txtMedicineName.delegate = self;
    txtMedicineName.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Medicine Name"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtMedicineName.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtMedicineName.tintColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtMedicineName.floatingLabelFont = txtFieldFont;
    txtMedicineName.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtMedicineName.keepBaseline = NO;
    [txtMedicineName setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    txtMedicineNameBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    self.arrayQuantity = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", @"13", @"14", @"15", @"16", @"17", @"18", @"19", @"20", nil];
    quantityPickerView = [[UIPickerView alloc] init];
    quantityPickerView.delegate = self;
    quantityPickerView.dataSource = self;
    quantityPickerView.showsSelectionIndicator = YES;
    quantityPickerView.tag = 1;
    quantityPickerView.backgroundColor = [UIColor whiteColor];
    
    txtMedicineQuantity.font = txtFieldFont;
    txtMedicineQuantity.delegate = self;
    txtMedicineQuantity.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Quantity"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtMedicineQuantity.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtMedicineQuantity.tintColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtMedicineQuantity.floatingLabelFont = txtFieldFont;
    txtMedicineQuantity.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtMedicineQuantity.keepBaseline = NO;
    [txtMedicineQuantity setInputView:quantityPickerView];
    [txtMedicineQuantity setAutocorrectionType:UITextAutocorrectionTypeNo];
    
    txtMedicineQuantityBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    //TIME PICKER
    timePicker = [[UIDatePicker alloc] init];
    timePicker.datePickerMode = UIDatePickerModeTime;
    if (@available(iOS 13.4, *)) {
        timePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    timePicker.backgroundColor = [UIColor whiteColor];
    [timePicker addTarget:self action:@selector(timeSelected:) forControlEvents:UIControlEventValueChanged];
    
    txtMedicineTime.font = txtFieldFont;
    txtMedicineTime.delegate = self;
    txtMedicineTime.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Time"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtMedicineTime.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtMedicineTime.tintColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtMedicineTime.floatingLabelFont = txtFieldFont;
    txtMedicineTime.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtMedicineTime.keepBaseline = NO;
    [txtMedicineTime setAutocorrectionType:UITextAutocorrectionTypeNo];
    [txtMedicineTime setInputView:timePicker];
    
    txtMedicineTimeBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    //TILL DATE PICKER
    tillDatePicker = [[UIDatePicker alloc] init];
    tillDatePicker.datePickerMode = UIDatePickerModeDate;
    if (@available(iOS 13.4, *)) {
        tillDatePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    [tillDatePicker setMinimumDate: [NSDate date]];
    tillDatePicker.backgroundColor = [UIColor whiteColor];
    [tillDatePicker addTarget:self action:@selector(tillDateSelected:) forControlEvents:UIControlEventValueChanged];
    
    txtMedicineTillDate.font = txtFieldFont;
    txtMedicineTillDate.delegate = self;
    txtMedicineTillDate.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Till Date"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtMedicineTillDate.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtMedicineTillDate.tintColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtMedicineTillDate.floatingLabelFont = txtFieldFont;
    txtMedicineTillDate.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtMedicineTillDate.keepBaseline = NO;
    [txtMedicineTillDate setAutocorrectionType:UITextAutocorrectionTypeNo];
    [txtMedicineTillDate setInputView:tillDatePicker];
    
    txtMedicineTillDateBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    btnSetReminder.backgroundColor = [MySingleton sharedManager].themeGlobalGreenColor;
    btnSetReminder.layer.masksToBounds = true;
    btnSetReminder.layer.cornerRadius = [MySingleton sharedManager].floatButtonCornerRadius;
    btnSetReminder.titleLabel.font = btnFont;
    [btnSetReminder setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    [btnSetReminder addTarget:self action:@selector(btnSetReminderClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [[MySingleton sharedManager].dataManager user_getAllMyPetsByUserId:[prefs objectForKey:@"userid"]];
    
    //========== PRATIK GUJARATI TEMP DATA ==========//
//    txtMedicineName.text = @"Crocin";
//    txtMedicineQuantity.text = @"1";
//    txtMedicineTime.text = @"5.30 PM";
//    txtMedicineTillDate.text = @"19 Aug, 17";
    //========== PRATIK GUJARATI TEMP DATA ==========//
}

#pragma mark - UITextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == txtPetName)
    {
        if(txtPetName.text.length == 0)
        {
            self.objSelectedPet = [self.arrayPet objectAtIndex:0];
            txtPetName.text = self.objSelectedPet.strPetName;
            [quantityPickerView selectRow:0 inComponent:0 animated:YES];
        }
    }
    else if(textField == txtMedicineQuantity)
    {
        if(txtMedicineQuantity.text.length == 0)
        {
            txtMedicineQuantity.text = [self.arrayQuantity objectAtIndex:0];
            [quantityPickerView selectRow:0 inComponent:0 animated:YES];
        }
    }
    else if(textField == txtMedicineTime)
    {
        if(txtMedicineTime.text.length == 0)
        {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
            [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
            dateFormat.dateStyle = NSDateFormatterMediumStyle;
            if([appDelegate isClock24Hour])
            {
                [dateFormat setDateFormat:@"HH:mm"];
            }
            else
            {
                [dateFormat setDateFormat:@"hh:mm a"];
            }
            NSString *strSelectedStartDate = [NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:timePicker.date]];
            txtMedicineTime.text = strSelectedStartDate;
        }
    }
    else if(textField == txtMedicineTillDate)
    {
        if(txtMedicineTillDate.text.length == 0)
        {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
            [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
            dateFormat.dateStyle = NSDateFormatterMediumStyle;
            [dateFormat setDateFormat:@"dd MMM, yy"];
            NSString *strSelectedDate = [NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:tillDatePicker.date]];
            txtMedicineTillDate.text = strSelectedDate;
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

#pragma mark - UIPickerView Delegate Methods

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rowsInComponent;
    
    if(pickerView.tag == 1)
    {
        rowsInComponent = [self.arrayQuantity count];
    }
    else if(pickerView.tag == 2)
    {
        rowsInComponent = [self.arrayPet count];
    }
    
    return rowsInComponent;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* lblMain = (UILabel*)view;
    if (!lblMain){
        lblMain = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
    }
    
    if (pickerView.tag == 1)
    {
        lblMain.text = self.arrayQuantity[row];
        lblMain.font = [MySingleton sharedManager].themeFontSixteenSizeRegular;
    }
    else if (pickerView.tag == 2)
    {
        Pet *objPet = self.arrayPet[row];
        lblMain.text = objPet.strPetName;
        lblMain.font = [MySingleton sharedManager].themeFontSixteenSizeRegular;
    }
    
    lblMain.textAlignment = NSTextAlignmentCenter;
    return lblMain;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [MySingleton sharedManager].screenWidth;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView.tag == 1)
    {
        txtMedicineQuantity.text = [self.arrayQuantity objectAtIndex:row];
    }
    else if(pickerView.tag == 2)
    {
        self.objSelectedPet = [self.arrayPet objectAtIndex:row];
        txtPetName.text = self.objSelectedPet.strPetName;
    }
}

#pragma mark - In-App Purchase Methods

-(void)fetchAvailableProducts
{
    
    //FIXME:- Remove after issues found
    [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
    
    NSSet *productIdentifiers = [NSSet
                                 setWithObjects:kUnlimitedRemindersProductID,nil];
    productsRequest = [[SKProductsRequest alloc]
                       initWithProductIdentifiers:productIdentifiers];
    productsRequest.delegate = self;
    [productsRequest start];
}

- (BOOL)canMakePurchases
{
    return [SKPaymentQueue canMakePayments];
}

- (void)purchaseUnlimitedRemindersIAP:(SKProduct*)product
{
    if ([self canMakePurchases])
    {
        SKPayment *payment = [SKPayment paymentWithProduct:product];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:self];
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else
    {
        [appDelegate showErrorAlertViewWithTitle:@"" withDetails:@"Purchases are disabled on your device"];
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
        [appDelegate showErrorAlertViewWithTitle:@"" withDetails:@"Purchases are disabled on your device"];
    }
}

- (void)btnPurchaseUnlimitedRemindersClicked
{
    [self.view endEditing:YES];
    
    if(validProducts.count > 0)
    {
        [self purchaseUnlimitedRemindersIAP:[validProducts objectAtIndex:0]];
    }
    else
    {
        [appDelegate showErrorAlertViewWithTitle:@"" withDetails:@"No products to purchase"];
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
                
                if ([transaction.payment.productIdentifier
                     isEqualToString:kUnlimitedRemindersProductID])
                {
                    NSLog(@"Purchased ");
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:@"1" forKey:@"reminderspurchased"];
                    [userDefaults synchronize];
                    
                    [appDelegate showErrorAlertViewWithTitle:@"" withDetails:@"You have successfully purchased unlimited reminders."];
                }
                
                [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
                break;
                
            case SKPaymentTransactionStateRestored:
                [appDelegate dismissGlobalHUD];
                
                if ([transaction.payment.productIdentifier
                     isEqualToString:kUnlimitedRemindersProductID])
                {
                    NSLog(@"Restored ");
                    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                    [userDefaults setObject:@"1" forKey:@"reminderspurchased"];
                    [userDefaults synchronize];
                    
                    [appDelegate showErrorAlertViewWithTitle:@"" withDetails:@"You have successfully purchased unlimited reminders."];
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
        validProduct = [response.products objectAtIndex:0];
        if ([validProduct.productIdentifier
             isEqualToString:kUnlimitedRemindersProductID])
        {
            NSLog(@"Product Title : %@", [NSString stringWithFormat:
                                          @"Product Title: %@",validProduct.localizedTitle]);
            NSLog(@"Product Desc : %@", [NSString stringWithFormat:
                                         @"Product Desc: %@",validProduct.localizedDescription]);
            NSLog(@"Product Price : %@", [NSString stringWithFormat:
                                          @"Product Price: %@",validProduct.price]);
        }
    }
    else
    {
        [appDelegate showErrorAlertViewWithTitle:@"Not Available" withDetails:@"No products to purchase"];
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
        
        // here put an if/then statement to write files based on previously purchased items
        // example if ([productID isEqualToString: @"youruniqueproductidentifier]){write files} else { nslog sorry}
        
        if ([productID isEqualToString:kUnlimitedRemindersProductID])
        {
            NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
            [userDefaults setObject:@"1" forKey:@"reminderspurchased"];
            [userDefaults synchronize];
            
            [appDelegate showErrorAlertViewWithTitle:@"" withDetails:@"You have successfully purchased unlimited reminders."];
        }
    }
}

#pragma mark - Other Methods

-(void)doneClicked:(id)sender
{
    [self.view endEditing:YES];
}

-(void)timeSelected:(id)sender
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    dateFormat.dateStyle = NSDateFormatterMediumStyle;
    if([appDelegate isClock24Hour])
    {
        [dateFormat setDateFormat:@"HH:mm"];
    }
    else
    {
        [dateFormat setDateFormat:@"hh:mm a"];
    }
    NSString *strSelectedStartDate = [NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:timePicker.date]];
    txtMedicineTime.text = strSelectedStartDate;
}

-(void)tillDateSelected:(id)sender
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    dateFormat.dateStyle = NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"dd MMM, yy"];
    NSString *strSelectedDate = [NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:tillDatePicker.date]];
    txtMedicineTillDate.text = strSelectedDate;
}

- (IBAction)btnSetReminderClicked:(id)sender
{
    [self.view endEditing:true];
    
    if(self.objSelectedPet != nil && txtMedicineName.text.length > 0 && txtMedicineQuantity.text.length > 0 && txtMedicineTime.text.length > 0 && txtMedicineTillDate.text.length > 0)
    {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
        [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        dateFormat.dateStyle = NSDateFormatterMediumStyle;
        [dateFormat setDateFormat:@"dd MMM, yy"];
        
        NSString *strCurrentDate = [dateFormat  stringFromDate:[NSDate date]];
        NSString *strSelectedTime = txtMedicineTime.text;
        NSString *strCurrentDateWithSelectedTime = [NSString stringWithFormat:@"%@ %@", strCurrentDate, strSelectedTime];
        
        NSDateFormatter *fullDateFormat = [[NSDateFormatter alloc]init];
        [fullDateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
        fullDateFormat.dateStyle = NSDateFormatterMediumStyle;
        if([appDelegate isClock24Hour])
        {
            [fullDateFormat setDateFormat:@"dd MMM, yy HH:mm"];
        }
        else
        {
            [fullDateFormat setDateFormat:@"dd MMM, yy hh:mm a"];
        }
        NSDate *currentDateWithSelectedTime = [fullDateFormat dateFromString:strCurrentDateWithSelectedTime];
        
        int numberOfDays;
        BOOL boolIsMedicineToBeTakenToday = false;
        
        if ([currentDateWithSelectedTime timeIntervalSinceNow] < 0.0)
        {
            NSLog(@"Medicine not to be taken today");
            
            NSString *strTillDate = txtMedicineTillDate.text;
            NSString *strTillDateWithSelectedTime = [NSString stringWithFormat:@"%@ %@", strTillDate, strSelectedTime];
            NSDate *tillDateWithSelectedTime = [fullDateFormat dateFromString:strTillDateWithSelectedTime];
            
            NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                                fromDate:currentDateWithSelectedTime
                                                                  toDate:tillDateWithSelectedTime
                                                                 options:0];
            
            numberOfDays = [components day];
            boolIsMedicineToBeTakenToday = false;
        }
        else
        {
            NSLog(@"Medicine to be taken today");
            
            NSString *strTillDate = txtMedicineTillDate.text;
            NSString *strTillDateWithSelectedTime = [NSString stringWithFormat:@"%@ %@", strTillDate, strSelectedTime];
            NSDate *tillDateWithSelectedTime = [fullDateFormat dateFromString:strTillDateWithSelectedTime];
            
            NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
            NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                                fromDate:currentDateWithSelectedTime
                                                                  toDate:tillDateWithSelectedTime
                                                                 options:0];
            
            numberOfDays = [components day] + 1;
            boolIsMedicineToBeTakenToday = true;
        }
        
        NSLog(@"numberOfDays : %d", numberOfDays);
        NSLog(@"boolIsMedicineToBeTakenToday : %d", boolIsMedicineToBeTakenToday);
        
        bool boolIsExecutable = false;
        
        if((self.intAlreadyAddedNumberOfReminders + numberOfDays) > 10)
        {
            NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
            
            if([[prefs objectForKey:@"reminderspurchased"] isEqualToString:@"1"])
            {
                boolIsExecutable = true;
            }
            else
            {
                boolIsExecutable = false;
            }
        }
        else
        {
            boolIsExecutable = true;
        }
        
        if(boolIsExecutable)
        {
            NSMutableArray *arrayReminderDictionaries = [[NSMutableArray alloc] init];
            
            if(numberOfDays > 0)
            {
                if(boolIsMedicineToBeTakenToday)
                {
                    for(int i = 0; i < numberOfDays; i++)
                    {
                        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
                        dayComponent.day = i;
                        
                        NSCalendar *theCalendar = [NSCalendar currentCalendar];
                        NSDate *alertDateAndTime = [theCalendar dateByAddingComponents:dayComponent toDate:currentDateWithSelectedTime options:0];
                        
                        NSString *strMedicineName = txtMedicineName.text;
                        strMedicineName = [strMedicineName stringByReplacingOccurrencesOfString:@" " withString:@""];
                        strMedicineName = [strMedicineName uppercaseString];
                        
                        int timestamp = [alertDateAndTime timeIntervalSince1970];
                        
                        NSString *strUniqueId = [NSString stringWithFormat:@"%@%@%d", txtMedicineQuantity.text, strMedicineName, timestamp];
                        NSString *strAlertDateAndTime = [fullDateFormat stringFromDate:alertDateAndTime];
                        
                        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:txtMedicineName.text, @"MedicineName",txtMedicineQuantity.text, @"Quantity", strUniqueId, @"UniqueId", strAlertDateAndTime, @"AlertDateAndTime", self.objSelectedPet.strPetID, @"PetId", self.objSelectedPet.strPetTypeName, @"PetType", self.objSelectedPet.strPetName, @"PetName", self.objSelectedPet.strPetImageUrl, @"PetImageUrl", nil];
                        [arrayReminderDictionaries addObject:userInfo];
                    }
                }
                else
                {
                    for(int i = 1; i <= numberOfDays; i++)
                    {
                        NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
                        dayComponent.day = i;
                        
                        NSCalendar *theCalendar = [NSCalendar currentCalendar];
                        NSDate *alertDateAndTime = [theCalendar dateByAddingComponents:dayComponent toDate:currentDateWithSelectedTime options:0];
                        
                        NSString *strMedicineName = txtMedicineName.text;
                        strMedicineName = [strMedicineName stringByReplacingOccurrencesOfString:@" " withString:@""];
                        strMedicineName = [strMedicineName uppercaseString];
                        
                        int timestamp = [alertDateAndTime timeIntervalSince1970];
                        
                        NSString *strUniqueId = [NSString stringWithFormat:@"%@%@%d", txtMedicineQuantity.text, strMedicineName, timestamp];
                        NSString *strAlertDateAndTime = [fullDateFormat stringFromDate:alertDateAndTime];
                        
                        NSDictionary *userInfo = [NSDictionary dictionaryWithObjectsAndKeys:txtMedicineName.text, @"MedicineName",txtMedicineQuantity.text, @"Quantity", strUniqueId, @"UniqueId", strAlertDateAndTime, @"AlertDateAndTime", self.objSelectedPet.strPetID, @"PetId", self.objSelectedPet.strPetTypeName, @"PetType", self.objSelectedPet.strPetName, @"PetName", self.objSelectedPet.strPetImageUrl, @"PetImageUrl", nil];
                        [arrayReminderDictionaries addObject:userInfo];
                    }
                }
                
                for(int i = 0; i < arrayReminderDictionaries.count; i ++)
                {
                    NSDictionary *userInfo = [arrayReminderDictionaries objectAtIndex:i];
                    
                    UIApplication* app = [UIApplication sharedApplication];
                    UILocalNotification* notifyAlarm = [[UILocalNotification alloc] init];
                    if (notifyAlarm)
                    {
                        //FOLLOWING LINE IS TO CANCEL DUPLICATE NOTIFICATION IF EXIST WITH SAME UNIQUEID
                        [self cancelParticularNotificationWithUniqueId:[userInfo objectForKey:@"UniqueId"]];
                        
                        NSDate *alertDateAndTime = [fullDateFormat dateFromString:[userInfo objectForKey:@"AlertDateAndTime"]];
                        
                        notifyAlarm.fireDate = alertDateAndTime;
                        notifyAlarm.timeZone = [NSTimeZone defaultTimeZone];
                        notifyAlarm.repeatInterval = 0;
                        notifyAlarm.soundName = @"notification_sound.mp3";
                        notifyAlarm.alertBody = [NSString stringWithFormat:@"TIP FOR PET - MEDICINE REMINDER :\nPet Name : %@\nPet Type : %@\nMedicine Name : %@\nQuantity : %@",self.objSelectedPet.strPetName, self.objSelectedPet.strPetTypeName, txtMedicineName.text, txtMedicineQuantity.text];
                        notifyAlarm.userInfo = userInfo;
                        [app scheduleLocalNotification:notifyAlarm];
                        NSLog(@"Local Notification scheduled");
                    }
                }
                
                [[MySingleton sharedManager].dataManager user_addReminderToSqliteDatabase:arrayReminderDictionaries];
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [appDelegate showErrorAlertViewWithTitle:@"" withDetails:@"We need atleast one day to set a reminder."];
                });
            }
        }
        else
        {
            NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
            alertViewController.title = @"";
            alertViewController.message = @"We provide first 10 reminders for free. You can set unlimited reminders after purchasing our reminders pack.";
            
            alertViewController.view.tintColor = [UIColor whiteColor];
            alertViewController.backgroundTapDismissalGestureEnabled = YES;
            alertViewController.swipeDismissalGestureEnabled = YES;
            alertViewController.transitionStyle = NYAlertViewControllerTransitionStyleFade;
            
            alertViewController.titleFont = [MySingleton sharedManager].alertViewTitleFont;
            alertViewController.messageFont = [MySingleton sharedManager].alertViewMessageFont;
            alertViewController.buttonTitleFont = [MySingleton sharedManager].alertViewButtonTitleFont;
            alertViewController.cancelButtonTitleFont = [MySingleton sharedManager].alertViewCancelButtonTitleFont;
            
            [alertViewController addAction:[NYAlertAction actionWithTitle:@"Purchase" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action){
                
                [alertViewController dismissViewControllerAnimated:YES completion:nil];
                
                [self btnPurchaseUnlimitedRemindersClicked];
            }]];
            
            [alertViewController addAction:[NYAlertAction actionWithTitle:@"Restore" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action){
                
                [alertViewController dismissViewControllerAnimated:YES completion:nil];
                
                [self restoreInAppPurchases];
            }]];
            
            [alertViewController addAction:[NYAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(NYAlertAction *action){
                
                [alertViewController dismissViewControllerAnimated:YES completion:nil];
                
            }]];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:alertViewController animated:YES completion:nil];
            });
        }
    }
    else
    {
        if(self.objSelectedPet == nil)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate showErrorAlertViewWithTitle:@"" withDetails:@"Please select a pet."];
            });
        }
        else if(txtMedicineName.text.length <= 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate showErrorAlertViewWithTitle:@"" withDetails:@"Medicine Name can not be empty."];
            });
        }
        else if(txtMedicineQuantity.text.length <= 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate showErrorAlertViewWithTitle:@"" withDetails:@"Quantity can not be empty."];
            });
        }
        else if(txtMedicineTime.text.length <= 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate showErrorAlertViewWithTitle:@"" withDetails:@"Time can not be empty."];
            });
        }
        else if(txtMedicineTillDate.text.length <= 0)
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate showErrorAlertViewWithTitle:@"" withDetails:@"Till date can not be empty."];
            });
        }
    }
}

-(void)cancelParticularNotificationWithUniqueId:(NSString *)strReminderUniqueId
{
    for (UILocalNotification *notification in [[[UIApplication sharedApplication] scheduledLocalNotifications] copy])
    {
        NSDictionary *userInfo = notification.userInfo;
        
        if ([[userInfo objectForKey:@"UniqueId"] isEqualToString:strReminderUniqueId])
        {
            [[UIApplication sharedApplication] cancelLocalNotification:notification];
        }
    }
}

@end
