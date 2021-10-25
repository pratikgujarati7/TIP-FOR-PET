//
//  AdviceListTableViewCell.m
//  Tip for Pet
//
//  Created by Pratik Gujarati on 29/07/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "AdviceListTableViewCell.h"
#import "MySingleton.h"

#define CellHeight 95

@implementation AdviceListTableViewCell

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
        self.mainContainer.backgroundColor =  [MySingleton sharedManager].themeGlobalLightGreenColor;
        
        //======= ADD INFO IMAGE VIEW INTO MAIN CONTAINER VIEW =======//
        self.imageViewInfo = [[AsyncImageView alloc]initWithFrame:CGRectMake(10, 10, 60, 60)];
        self.imageViewInfo.contentMode = UIViewContentModeScaleAspectFit;
        self.imageViewInfo.layer.masksToBounds = YES;
        self.imageViewInfo.image = [UIImage imageNamed:@"advice_info.png"];
        [self.mainContainer addSubview:self.imageViewInfo];
        
        //======= ADD LABEL CLICK HERE INTO MAIN CONTAINER VIEW =======//
        self.lblClickHere = [[UILabel alloc] initWithFrame:CGRectMake((self.imageViewInfo.frame.origin.x + self.imageViewInfo.frame.size.width + 10), 10, self.mainContainer.frame.size.width - (self.imageViewInfo.frame.origin.x + self.imageViewInfo.frame.size.width + 10)- 10, 10)];
        self.lblClickHere.font = [MySingleton sharedManager].themeFontTenSizeRegular;
        self.lblClickHere.textColor = [MySingleton sharedManager].themeGlobalDarkGreyColor;
        self.lblClickHere.numberOfLines = 1;
        self.lblClickHere.textAlignment = NSTextAlignmentRight;
        self.lblClickHere.layer.masksToBounds = YES;
        self.lblClickHere.text = @"CLICK HERE";
        [self.mainContainer addSubview:self.lblClickHere];
        
        //======= ADD LABEL ADVICE TITLE INTO MAIN CONTAINER VIEW =======//
        self.lblAdviceTitle = [[UILabel alloc] initWithFrame:CGRectMake((self.imageViewInfo.frame.origin.x + self.imageViewInfo.frame.size.width + 10), 25, self.mainContainer.frame.size.width - (self.imageViewInfo.frame.origin.x + self.imageViewInfo.frame.size.width + 10)- 10, 60)];
        self.lblAdviceTitle.font = [MySingleton sharedManager].themeFontTwentySizeRegular;
        self.lblAdviceTitle.textColor = [MySingleton sharedManager].themeGlobalDarkGreenColor;
        self.lblAdviceTitle.numberOfLines = 0;
        self.lblAdviceTitle.textAlignment = NSTextAlignmentLeft;
        self.lblAdviceTitle.layer.masksToBounds = YES;
        [self.mainContainer addSubview:self.lblAdviceTitle];
        
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
