//
//  SubCategoryTableViewCell.m
//  Tip for Pet
//
//  Created by Pratik Gujarati on 28/07/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "SubCategoryTableViewCell.h"
#import "MySingleton.h"

#define CellHeight 120

@implementation SubCategoryTableViewCell

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
        
        //======= ADD SUBCATEGORY IMAGE VIEW INTO MAIN CONTAINER VIEW =======//
        self.imageViewSubCategoryPicture = [[AsyncImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 100)];
        self.imageViewSubCategoryPicture.backgroundColor = [MySingleton sharedManager].themeGlobalWhiteColor;
        self.imageViewSubCategoryPicture.contentMode = UIViewContentModeScaleAspectFit;
        self.imageViewSubCategoryPicture.layer.masksToBounds = YES;
        self.imageViewSubCategoryPicture.layer.cornerRadius = 10.0f;
        self.imageViewSubCategoryPicture.layer.borderWidth = 1.0f;
        self.imageViewSubCategoryPicture.layer.borderColor = [MySingleton sharedManager].themeGlobalDarkGreenColor.CGColor;
        [self.mainContainer addSubview:self.imageViewSubCategoryPicture];
        
        //======= ADD LABEL SUBCATEGORY NAME INTO MAIN CONTAINER VIEW =======//
        self.lblSubCategoryName = [[UILabel alloc] initWithFrame:CGRectMake((self.imageViewSubCategoryPicture.frame.origin.x + self.imageViewSubCategoryPicture.frame.size.width + 10), 10, self.mainContainer.frame.size.width - (self.imageViewSubCategoryPicture.frame.origin.x + self.imageViewSubCategoryPicture.frame.size.width + 10) - 10, 60)];
        self.lblSubCategoryName.font = [MySingleton sharedManager].themeFontTwentySizeBold;
        self.lblSubCategoryName.textColor = [MySingleton sharedManager].themeGlobalDarkGreenColor;
        self.lblSubCategoryName.numberOfLines = 3;
        self.lblSubCategoryName.textAlignment = NSTextAlignmentLeft;
        self.lblSubCategoryName.layer.masksToBounds = YES;
        [self.mainContainer addSubview:self.lblSubCategoryName];
        
        //======== ADD BUTTON FIND OUT MORE INTO MAIN CONTAINER VIEW  ========//
        self.btnFindOutMore = [[UIButton alloc]initWithFrame:CGRectMake((self.imageViewSubCategoryPicture.frame.origin.x + self.imageViewSubCategoryPicture.frame.size.width + 10), (self.lblSubCategoryName.frame.origin.y + self.lblSubCategoryName.frame.size.height + 10), self.mainContainer.frame.size.width - (self.imageViewSubCategoryPicture.frame.origin.x + self.imageViewSubCategoryPicture.frame.size.width + 10) - 10, 30)];
        self.btnFindOutMore.titleLabel.font = [MySingleton sharedManager].themeFontTenSizeMedium;
        [self.btnFindOutMore setTitleColor:[MySingleton sharedManager].themeGlobalDarkGreenColor forState:UIControlStateNormal];
        self.btnFindOutMore.layer.masksToBounds = YES;
        self.btnFindOutMore.layer.cornerRadius = 10.0f;
        self.btnFindOutMore.backgroundColor = [MySingleton sharedManager].themeGlobalGreenColor;
        [self.btnFindOutMore setBackgroundImage:[self imageWithColor:[MySingleton sharedManager].themeGlobalGreenColor] forState:UIControlStateHighlighted];
        [self.btnFindOutMore setTitle:@"FIND OUT MORE" forState:UIControlStateNormal];
        [self.mainContainer addSubview:self.btnFindOutMore];
        
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
