//
//  User_HomeViewController.h
//  ENZYM
//
//  Created by Pratik Gujarati on 05/05/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

@interface User_HomeViewController : UIViewController<UIScrollViewDelegate, UITableViewDelegate, UITableViewDataSource, SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    SKProductsRequest *productsRequest;
    NSArray *validProducts;
}
//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewMenu;
@property (nonatomic,retain) IBOutlet UIButton *btnMenu;
@property (nonatomic,retain) IBOutlet UILabel *lblNavigationTitle;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewOptions;
@property (nonatomic,retain) IBOutlet UIButton *btnOptions;

@property (nonatomic,retain) IBOutlet UIView *mainContainerView;
@property (nonatomic,retain) IBOutlet UITableView *mainTableView;

//========== OTHER VARIABLES ==========//

@property (nonatomic,retain) NSMutableArray *dataRows;

@property (nonatomic,retain) NSMutableArray *arrayInAppPurchaseProductIdentifiers;
@property (nonatomic,retain) NSMutableArray *arrayInAppPurchaseProductFlagNames;

@end
