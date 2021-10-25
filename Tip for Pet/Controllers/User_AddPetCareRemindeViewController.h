//
//  User_AddPetCareRemindeViewController.h
//  Tip for Pet
//
//  Created by Pratik Gujarati on 03/08/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <StoreKit/StoreKit.h>

#import "JVFloatLabeledTextField.h"

#import "Pet.h"

@interface User_AddPetCareRemindeViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, SKProductsRequestDelegate,SKPaymentTransactionObserver>
{
    SKProductsRequest *productsRequest;
    NSArray *validProducts;
}

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIView *navigationBarView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewBack;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet UILabel *lblNavigationTitle;

@property (nonatomic,retain) IBOutlet UIView *mainContainerView;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtPetName;
@property (nonatomic,retain) IBOutlet UIView *txtPetNameBottomSeparatorView;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtMedicineName;
@property (nonatomic,retain) IBOutlet UIView *txtMedicineNameBottomSeparatorView;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtMedicineQuantity;
@property (nonatomic,retain) IBOutlet UIView *txtMedicineQuantityBottomSeparatorView;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtMedicineTime;
@property (nonatomic,retain) IBOutlet UIView *txtMedicineTimeBottomSeparatorView;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtMedicineTillDate;
@property (nonatomic,retain) IBOutlet UIView *txtMedicineTillDateBottomSeparatorView;

@property (nonatomic,retain) IBOutlet UIButton *btnSetReminder;

//========== OTHER VARIABLES ==========//

@property (nonatomic,retain) NSMutableArray *arrayPet;
@property (nonatomic,retain) UIPickerView *petPickerView;

@property (nonatomic,retain) Pet *objSelectedPet;

@property (nonatomic,retain) NSMutableArray *arrayQuantity;
@property (nonatomic,retain) UIPickerView *quantityPickerView;

@property (nonatomic,retain) UIDatePicker *timePicker;
@property (nonatomic,retain) UIDatePicker *tillDatePicker;

@property (nonatomic,assign) int intAlreadyAddedNumberOfReminders;

@end
