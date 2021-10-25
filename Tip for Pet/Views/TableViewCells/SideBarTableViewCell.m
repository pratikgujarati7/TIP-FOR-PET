//
//  SideBarTableViewCell.m
//  PRATIK GUJARATI
//
//  Created by Pratik Gujarati on 00/00/00.
//  Copyright © 2017 accreteit. All rights reserved.
//

#import "SideBarTableViewCell.h"
#import "MySingleton.h"

#define CellHeight 50
#define CellTwoLinesHeight 70

@implementation SideBarTableViewCell

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
        float cellWidth = [MySingleton sharedManager].floatLeftSideMenuWidth;
        
        //======= ADD MAIN CONTAINER VIEW =======//
        self.mainContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
        self.mainContainer.backgroundColor =  [UIColor clearColor];
        
        //======= ADD MAIN IMAGE VIEW INTO BOX =======//
        self.imageViewMain = [[AsyncImageView alloc]initWithFrame:CGRectMake(30, 15, 20, 20)];
        self.imageViewMain.contentMode = UIViewContentModeScaleAspectFit;
        self.imageViewMain.layer.masksToBounds = YES;
        [self.mainContainer addSubview:self.imageViewMain];
        
        //======= ADD LABEL MAIN INTO BOX =======//
        self.lblMain = [[CustomLabel alloc] initWithFrame:CGRectMake((self.imageViewMain.frame.origin.x + self.imageViewMain.frame.size.width + 20), 10, (self.mainContainer.frame.size.width - (self.imageViewMain.frame.origin.x + self.imageViewMain.frame.size.width + 20))-10, 30)];
        self.lblMain.font = [MySingleton sharedManager].themeFontEighteenSizeBold;
        self.lblMain.textColor = [MySingleton sharedManager].themeGlobalGreenColor;
        self.lblMain.textBorderColor = [MySingleton sharedManager].themeGlobalDarkGreenColor;
        self.lblMain.floatBorderWidth = 1.0f;
        self.lblMain.textAlignment = NSTextAlignmentLeft;
        self.lblMain.numberOfLines = 1;
        self.lblMain.layer.masksToBounds = YES;
        [self.mainContainer addSubview:self.lblMain];
        
        //========ADD SEPERATOR INTO BOX ========//
        self.separatorView = [[UIView alloc]initWithFrame:CGRectMake(self.lblMain.frame.origin.x, self.mainContainer.frame.size.height-1, self.lblMain.frame.size.width, 0.5)];
        self.separatorView.backgroundColor = [MySingleton sharedManager].themeGlobalSideMenuSeperatorGreyColor;
        self.separatorView.alpha = 0.5f;
        [self.mainContainer addSubview:self.separatorView];
        
        [self addSubview:self.mainContainer];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (id)initWithTwoLinesStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        float cellHeight = CellTwoLinesHeight;
        float cellWidth = [MySingleton sharedManager].floatLeftSideMenuWidth;
        
        //======= ADD MAIN CONTAINER VIEW =======//
        self.mainContainer = [[UIView alloc]initWithFrame:CGRectMake(0, 0, cellWidth, cellHeight)];
        self.mainContainer.backgroundColor =  [UIColor clearColor];
        
        //======= ADD MAIN IMAGE VIEW INTO BOX =======//
        self.imageViewMain = [[AsyncImageView alloc]initWithFrame:CGRectMake(30, 25, 20, 20)];
        self.imageViewMain.contentMode = UIViewContentModeScaleAspectFit;
        self.imageViewMain.layer.masksToBounds = YES;
        [self.mainContainer addSubview:self.imageViewMain];
        
        //======= ADD LABEL MAIN INTO BOX =======//
        self.lblMain = [[CustomLabel alloc] initWithFrame:CGRectMake((self.imageViewMain.frame.origin.x + self.imageViewMain.frame.size.width + 20), 10, (self.mainContainer.frame.size.width - (self.imageViewMain.frame.origin.x + self.imageViewMain.frame.size.width + 20))-10, 50)];
        self.lblMain.font = [MySingleton sharedManager].themeFontEighteenSizeBold;
        self.lblMain.textColor = [MySingleton sharedManager].themeGlobalGreenColor;
        self.lblMain.textAlignment = NSTextAlignmentLeft;
        self.lblMain.textBorderColor = [MySingleton sharedManager].themeGlobalDarkGreenColor;
        self.lblMain.floatBorderWidth = 1.0f;
        self.lblMain.numberOfLines = 2;
        self.lblMain.layer.masksToBounds = YES;
        [self.mainContainer addSubview:self.lblMain];
        
        //========ADD SEPERATOR INTO BOX ========//
        self.separatorView = [[UIView alloc]initWithFrame:CGRectMake(self.lblMain.frame.origin.x, self.mainContainer.frame.size.height-1, self.lblMain.frame.size.width, 0.5)];
        self.separatorView.backgroundColor = [MySingleton sharedManager].themeGlobalSideMenuSeperatorGreyColor;
        self.separatorView.alpha = 0.5f;
        [self.mainContainer addSubview:self.separatorView];
        
        [self addSubview:self.mainContainer];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end
