//
//  MyPetListTableViewCell.m
//  Tip for Pet
//
//  Created by Pratik Gujarati on 02/08/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "MyPetListTableViewCell.h"
#import "MySingleton.h"

#define CellHeight 120

@implementation MyPetListTableViewCell

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
        float cellWidth = [MySingleton sharedManager].screenWidth;
        float cellHeight = CellHeight;
        
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
        self.lblPetName = [[UILabel alloc] initWithFrame:CGRectMake((self.imageViewPetImage.frame.origin.x + self.imageViewPetImage.frame.size.width + 10), 10, self.mainContainer.frame.size.width - (self.imageViewPetImage.frame.origin.x + self.imageViewPetImage.frame.size.width + 10) - 10, 30)];
        self.lblPetName.font = [MySingleton sharedManager].themeFontTwentySizeBold;
        self.lblPetName.textColor = [MySingleton sharedManager].themeGlobalDarkGreenColor;
        self.lblPetName.textAlignment = NSTextAlignmentLeft;
        self.lblPetName.layer.masksToBounds = YES;
        [self.mainContainer addSubview:self.lblPetName];
        
        //======= ADD LABEL PET TYPE NAME INTO MAIN CONTAINER VIEW =======//
        self.lblPetType = [[UILabel alloc] initWithFrame:CGRectMake((self.imageViewPetImage.frame.origin.x + self.imageViewPetImage.frame.size.width + 10), 45, (self.mainContainer.frame.size.width - (self.imageViewPetImage.frame.origin.x + self.imageViewPetImage.frame.size.width + 10) - 15)/2, 20)];
        self.lblPetType.font = [MySingleton sharedManager].themeFontTenSizeLight;        ;
        self.lblPetType.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
        self.lblPetType.textAlignment = NSTextAlignmentLeft;
        self.lblPetType.layer.masksToBounds = YES;
        [self.mainContainer addSubview:self.lblPetType];
        
        //======= ADD LABEL PET BREED INTO MAIN CONTAINER VIEW =======//
        self.lblPetBreed = [[UILabel alloc] initWithFrame:CGRectMake((self.lblPetType.frame.origin.x + self.lblPetType.frame.size.width + 5), 45, (self.mainContainer.frame.size.width - (self.imageViewPetImage.frame.origin.x + self.imageViewPetImage.frame.size.width + 10) - 15)/2, 20)];
        self.lblPetBreed.font = [MySingleton sharedManager].themeFontTenSizeLight;
        self.lblPetBreed.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
        self.lblPetBreed.textAlignment = NSTextAlignmentRight;
        self.lblPetBreed.layer.masksToBounds = YES;
        [self.mainContainer addSubview:self.lblPetBreed];
        
        //======= ADD LABEL PET BIRTHDATE INTO MAIN CONTAINER VIEW =======//
        self.lblPetBirthdate = [[UILabel alloc] initWithFrame:CGRectMake(self.imageViewPetImage.frame.origin.x, (self.imageViewPetImage.frame.origin.y + self.imageViewPetImage.frame.size.height + 10), (self.mainContainer.frame.size.width - 120), 15)];
        self.lblPetBirthdate.font = [MySingleton sharedManager].themeFontTenSizeLight;
        self.lblPetBirthdate.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
        self.lblPetBirthdate.textAlignment = NSTextAlignmentLeft;
        self.lblPetBirthdate.layer.masksToBounds = YES;
        [self.mainContainer addSubview:self.lblPetBirthdate];
        
        //======= ADD LABEL PET GENDER INTO MAIN CONTAINER VIEW =======//
        self.lblPetGender = [[UILabel alloc] initWithFrame:CGRectMake(self.imageViewPetImage.frame.origin.x, (self.lblPetBirthdate.frame.origin.y + self.lblPetBirthdate.frame.size.height + 3), (self.mainContainer.frame.size.width - 120), 15)];
        self.lblPetGender.font = [MySingleton sharedManager].themeFontTenSizeLight;
        self.lblPetGender.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
        self.lblPetGender.textAlignment = NSTextAlignmentLeft;
        self.lblPetGender.layer.masksToBounds = YES;
        [self.mainContainer addSubview:self.lblPetGender];
        
        //======== ADD BUTTON GET MORE DETAILS INTO MAIN CONTAINER VIEW  ========//
        self.btnUpdateDetails = [[UIButton alloc]initWithFrame:CGRectMake(self.mainContainer.frame.size.width - 110, self.mainContainer.frame.size.height - 40, 100, 30)];
        self.btnUpdateDetails.titleLabel.font = [MySingleton sharedManager].themeFontTenSizeMedium;
        [self.btnUpdateDetails setTitleColor:[MySingleton sharedManager].themeGlobalDarkGreenColor forState:UIControlStateNormal];
        self.btnUpdateDetails.layer.masksToBounds = YES;
        self.btnUpdateDetails.layer.cornerRadius = 10.0f;
        self.btnUpdateDetails.backgroundColor = [MySingleton sharedManager].themeGlobalGreenColor;
        [self.btnUpdateDetails setBackgroundImage:[self imageWithColor:[MySingleton sharedManager].themeGlobalGreenColor] forState:UIControlStateHighlighted];
        [self.btnUpdateDetails setTitle:@"UPDATE DETAILS" forState:UIControlStateNormal];
        [self.mainContainer addSubview:self.btnUpdateDetails];
        
        //========ADD SEPERATOR INTO BOX ========//
        self.separatorView = [[UIView alloc]initWithFrame:CGRectMake(20, self.mainContainer.frame.size.height-1, cellWidth - 40, 0.5)];
        self.separatorView.backgroundColor = [MySingleton sharedManager].themeGlobalSeperatorGreyColor;
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
