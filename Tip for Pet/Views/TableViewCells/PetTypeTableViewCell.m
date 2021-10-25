//
//  PetTypeTableViewCell.m
//  Tip for Pet
//
//  Created by Pratik Gujarati on 20/07/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "PetTypeTableViewCell.h"
#import "MySingleton.h"

#define CellHeight 120

@implementation PetTypeTableViewCell

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
        
        //======= ADD PET TYPE PICTURE IMAGE VIEW INTO MAIN CONTAINER VIEW =======//
        self.imageViewPetTypePicture = [[AsyncImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 100)];
        self.imageViewPetTypePicture.contentMode = UIViewContentModeScaleAspectFit;
        self.imageViewPetTypePicture.layer.masksToBounds = YES;
        self.imageViewPetTypePicture.layer.cornerRadius = 10.0f;
        self.imageViewPetTypePicture.layer.borderWidth = 1.0f;
        self.imageViewPetTypePicture.layer.borderColor = [MySingleton sharedManager].themeGlobalDarkGreenColor.CGColor;
        [self.mainContainer addSubview:self.imageViewPetTypePicture];
        
        //======= ADD LABEL PET TYPE INTO MAIN CONTAINER VIEW =======//
        self.lblPetType = [[UILabel alloc] initWithFrame:CGRectMake((self.imageViewPetTypePicture.frame.origin.x + self.imageViewPetTypePicture.frame.size.width + 10), 10, self.mainContainer.frame.size.width - (self.imageViewPetTypePicture.frame.origin.x + self.imageViewPetTypePicture.frame.size.width + 10) - 10, 30)];
        self.lblPetType.font = [MySingleton sharedManager].themeFontTwentySizeBold;
        self.lblPetType.textColor = [MySingleton sharedManager].themeGlobalDarkGreenColor;
        self.lblPetType.textAlignment = NSTextAlignmentLeft;
        self.lblPetType.layer.masksToBounds = YES;
        [self.mainContainer addSubview:self.lblPetType];
        
        //======= ADD LABEL PET TYPE DESCRIPTION INTO MAIN CONTAINER VIEW =======//
        self.lblPetTypeDescription = [[UILabel alloc] initWithFrame:CGRectMake((self.imageViewPetTypePicture.frame.origin.x + self.imageViewPetTypePicture.frame.size.width + 10), (self.lblPetType.frame.origin.y + self.lblPetType.frame.size.height + 5), self.mainContainer.frame.size.width - (self.imageViewPetTypePicture.frame.origin.x + self.imageViewPetTypePicture.frame.size.width + 10) - 10, 30)];
        self.lblPetTypeDescription.font = [MySingleton sharedManager].themeFontTenSizeRegular;
        self.lblPetTypeDescription.numberOfLines = 0;
        self.lblPetTypeDescription.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
        self.lblPetTypeDescription.textAlignment = NSTextAlignmentLeft;
        self.lblPetTypeDescription.layer.masksToBounds = YES;
        [self.mainContainer addSubview:self.lblPetTypeDescription];
        
        //======== ADD BUTTON GET TIPS INTO MAIN CONTAINER VIEW  ========//
        self.btnGetTips = [[UIButton alloc]initWithFrame:CGRectMake(self.mainContainer.frame.size.width - 90, (self.lblPetTypeDescription.frame.origin.y + self.lblPetTypeDescription.frame.size.height + 5), 80, 30)];
        self.btnGetTips.titleLabel.font = [MySingleton sharedManager].themeFontTenSizeMedium;
        [self.btnGetTips setTitleColor:[MySingleton sharedManager].themeGlobalDarkGreenColor forState:UIControlStateNormal];
        self.btnGetTips.layer.masksToBounds = YES;
        self.btnGetTips.layer.cornerRadius = 10.0f;
        self.btnGetTips.backgroundColor = [MySingleton sharedManager].themeGlobalGreenColor;
        [self.btnGetTips setBackgroundImage:[self imageWithColor:[MySingleton sharedManager].themeGlobalGreenColor] forState:UIControlStateHighlighted];
        [self.btnGetTips setTitle:@"GET TIPS" forState:UIControlStateNormal];
        [self.mainContainer addSubview:self.btnGetTips];
        
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
