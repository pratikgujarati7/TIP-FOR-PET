//
//  CategoryTableViewCell.m
//  Tip for Pet
//
//  Created by Pratik Gujarati on 28/07/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "CategoryTableViewCell.h"
#import "MySingleton.h"

#define CellHeight 120

@implementation CategoryTableViewCell

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
        
        //======= ADD CATEGORY IMAGE VIEW INTO MAIN CONTAINER VIEW =======//
        self.imageViewCategoryPicture = [[AsyncImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 100)];
        self.imageViewCategoryPicture.backgroundColor = [MySingleton sharedManager].themeGlobalWhiteColor;
        self.imageViewCategoryPicture.contentMode = UIViewContentModeScaleAspectFit;
        self.imageViewCategoryPicture.layer.masksToBounds = YES;
        self.imageViewCategoryPicture.layer.cornerRadius = 10.0f;
        self.imageViewCategoryPicture.layer.borderWidth = 1.0f;
        self.imageViewCategoryPicture.layer.borderColor = [MySingleton sharedManager].themeGlobalDarkGreenColor.CGColor;
        [self.mainContainer addSubview:self.imageViewCategoryPicture];
        
        //======= ADD LABEL CATEGORY NAME INTO MAIN CONTAINER VIEW =======//
        self.lblCategoryName = [[UILabel alloc] initWithFrame:CGRectMake((self.imageViewCategoryPicture.frame.origin.x + self.imageViewCategoryPicture.frame.size.width + 10), 10, self.mainContainer.frame.size.width - (self.imageViewCategoryPicture.frame.origin.x + self.imageViewCategoryPicture.frame.size.width + 10) - 10, 60)];
        self.lblCategoryName.font = [MySingleton sharedManager].themeFontTwentySizeBold;
        self.lblCategoryName.textColor = [MySingleton sharedManager].themeGlobalDarkGreenColor;
        self.lblCategoryName.numberOfLines = 3;
        self.lblCategoryName.textAlignment = NSTextAlignmentLeft;
        self.lblCategoryName.layer.masksToBounds = YES;
        [self.mainContainer addSubview:self.lblCategoryName];
        
        //======== ADD BUTTON FIND OUT MORE INTO MAIN CONTAINER VIEW  ========//
        self.btnFindOutMore = [[UIButton alloc]initWithFrame:CGRectMake((self.imageViewCategoryPicture.frame.origin.x + self.imageViewCategoryPicture.frame.size.width + 10), (self.lblCategoryName.frame.origin.y + self.lblCategoryName.frame.size.height + 10), self.mainContainer.frame.size.width - (self.imageViewCategoryPicture.frame.origin.x + self.imageViewCategoryPicture.frame.size.width + 10) - 10, 30)];
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
