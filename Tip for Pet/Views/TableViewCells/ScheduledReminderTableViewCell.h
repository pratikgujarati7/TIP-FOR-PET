//
//  ScheduledReminderTableViewCell.h
//  Malabar
//
//  Created by Pratik Gujarati on 01/07/17.
//  Copyright © 2017 accreteit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface ScheduledReminderTableViewCell : UITableViewCell

@property (nonatomic, retain) UIView *mainContainer;

@property (nonatomic, retain) AsyncImageView *imageViewPetImage;

@property (nonatomic, retain) UILabel *lblPetName;
@property (nonatomic, retain) UILabel *lblPetType;
@property (nonatomic, retain) UILabel *lblMedicineName;
@property (nonatomic, retain) UILabel *lblMedicineQuantity;
@property (nonatomic, retain) UILabel *lblMedicineDateAndTime;

@property (nonatomic, retain) UIButton *btnCancelReminder;

@property (nonatomic, retain) UIView *separatorView;

@end
