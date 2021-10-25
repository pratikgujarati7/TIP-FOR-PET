//
//  ScheduledReminderTableViewCell.m
//  Malabar
//
//  Created by Pratik Gujarati on 01/07/17.
//  Copyright © 2017 accreteit. All rights reserved.
//

#import "ScheduledReminderTableViewCell.h"
#import "MySingleton.h"

#define CellHeight 120

@implementation ScheduledReminderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:NO animated:animated];
    
    UIView *bgColorView = [[UIView alloc] init];
    bgColorView.backgroundColor = [UIColor clearColor];
    [self setSelectedBackgroundView:bgColorView];
    
    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        float cellHeight = CellHeight;
        float cellWidth = [MySingleton sharedManager].screenWidth;
        
        //======= ADD MAIN CONTAINER VIEW =======//
        self.mainContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
        self.mainContainer.backgroundColor =  [UIColor clearColor];
        
        //======= ADD PET IMAGE VIEW INTO MAIN CONTAINER VIEW =======//
        self.imageViewPetImage = [[AsyncImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        self.imageViewPetImage.contentMode = UIViewContentModeScaleAspectFill;
        self.imageViewPetImage.layer.masksToBounds = YES;
        self.imageViewPetImage.layer.cornerRadius = 30.0f;
        self.imageViewPetImage.layer.borderWidth = 1.0f;
        self.imageViewPetImage.layer.borderColor = [MySingleton sharedManager].themeGlobalDarkGreenColor.CGColor;
        [self.mainContainer addSubview:self.imageViewPetImage];
        
        //======= ADD LABEL PET NAME INTO MAIN CONTAINER VIEW =======//
        self.lblPetName = [[UILabel alloc] initWithFrame:CGRectMake((self.imageViewPetImage.frame.origin.x + self.imageViewPetImage.frame.size.width + 10), 10, self.mainContainer.frame.size.width - (self.imageViewPetImage.frame.origin.x + self.imageViewPetImage.frame.size.width + 10) - 10, 25)];
        self.lblPetName.font = [MySingleton sharedManager].themeFontTwentySizeBold;
        self.lblPetName.textColor = [MySingleton sharedManager].themeGlobalDarkGreenColor;
        self.lblPetName.textAlignment = NSTextAlignmentLeft;
        self.lblPetName.layer.masksToBounds = YES;
        [self.mainContainer addSubview:self.lblPetName];
        
        //======= ADD LABEL PET TYPE NAME INTO MAIN CONTAINER VIEW =======//
        self.lblPetType = [[UILabel alloc] initWithFrame:CGRectMake((self.imageViewPetImage.frame.origin.x + self.imageViewPetImage.frame.size.width + 10), 40, self.mainContainer.frame.size.width - (self.imageViewPetImage.frame.origin.x + self.imageViewPetImage.frame.size.width + 10) - 10, 15)];
        self.lblPetType.font = [MySingleton sharedManager].themeFontTenSizeLight;        ;
        self.lblPetType.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
        self.lblPetType.textAlignment = NSTextAlignmentLeft;
        self.lblPetType.layer.masksToBounds = YES;
        [self.mainContainer addSubview:self.lblPetType];
        
        //======= ADD LABEL MEDICINE NAME INTO BOX =======//
        self.lblMedicineName = [[UILabel alloc] initWithFrame:CGRectMake((self.imageViewPetImage.frame.origin.x + self.imageViewPetImage.frame.size.width + 10), 57, self.mainContainer.frame.size.width - (self.imageViewPetImage.frame.origin.x + self.imageViewPetImage.frame.size.width + 10) - 10, 15)];
        self.lblMedicineName.font = [MySingleton sharedManager].themeFontTenSizeBold;
        self.lblMedicineName.textColor = [MySingleton sharedManager].themeGlobalBlackColor;
        self.lblMedicineName.textAlignment = NSTextAlignmentLeft;
        self.lblMedicineName.layer.masksToBounds = YES;
        [self.mainContainer addSubview:self.lblMedicineName];
        
        //======= ADD LABEL MEDICINE QUANTITY INTO BOX =======//
        self.lblMedicineQuantity = [[UILabel alloc] initWithFrame:CGRectMake(self.imageViewPetImage.frame.origin.x, (self.imageViewPetImage.frame.origin.y + self.imageViewPetImage.frame.size.height + 10), (self.mainContainer.frame.size.width - 120), 15)];
        self.lblMedicineQuantity.font = [MySingleton sharedManager].themeFontTenSizeRegular;
        self.lblMedicineQuantity.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
        self.lblMedicineQuantity.textAlignment = NSTextAlignmentLeft;
        self.lblMedicineQuantity.layer.masksToBounds = YES;
        [self.mainContainer addSubview:self.lblMedicineQuantity];
        
        //======= ADD LABEL MEDICINE DATE AND TIME INTO BOX =======//
        self.lblMedicineDateAndTime = [[UILabel alloc] initWithFrame:CGRectMake(self.imageViewPetImage.frame.origin.x, (self.lblMedicineQuantity.frame.origin.y + self.lblMedicineQuantity.frame.size.height + 3), (self.mainContainer.frame.size.width - 120), 15)];
        self.lblMedicineDateAndTime.font = [MySingleton sharedManager].themeFontTenSizeRegular;
        self.lblMedicineDateAndTime.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
        self.lblMedicineDateAndTime.textAlignment = NSTextAlignmentLeft;
        self.lblMedicineDateAndTime.layer.masksToBounds = YES;
        [self.mainContainer addSubview:self.lblMedicineDateAndTime];
        
        //======== ADD BUTTON CANCEL INTO MAIN CONTAINER VIEW  ========//
        self.btnCancelReminder = [[UIButton alloc]initWithFrame:CGRectMake(self.mainContainer.frame.size.width - 110, self.mainContainer.frame.size.height - 40, 100, 30)];
        self.btnCancelReminder.titleLabel.font = [MySingleton sharedManager].themeFontTenSizeMedium;
        [self.btnCancelReminder setTitleColor:[MySingleton sharedManager].themeGlobalDarkGreenColor forState:UIControlStateNormal];
        self.btnCancelReminder.layer.masksToBounds = YES;
        self.btnCancelReminder.layer.cornerRadius = 10.0f;
        self.btnCancelReminder.backgroundColor = [MySingleton sharedManager].themeGlobalGreenColor;
        [self.btnCancelReminder setBackgroundImage:[self imageWithColor:[MySingleton sharedManager].themeGlobalGreenColor] forState:UIControlStateHighlighted];
        [self.btnCancelReminder setTitle:@"CANCEL" forState:UIControlStateNormal];
        [self.mainContainer addSubview:self.btnCancelReminder];
        
        //========ADD SEPERATOR INTO BOX ========//
        self.separatorView = [[UIView alloc]initWithFrame:CGRectMake(0, self.mainContainer.frame.size.height-1, self.mainContainer.frame.size.width, 0.5)];
        self.separatorView.backgroundColor = [MySingleton sharedManager].themeGlobalSideMenuSeperatorGreyColor;
        self.separatorView.alpha = 0.5f;
        [self.mainContainer addSubview:self.separatorView];
        
        [self addSubview:self.mainContainer];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
