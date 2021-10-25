//
//  AdviceListTableViewCell.h
//  Tip for Pet
//
//  Created by Pratik Gujarati on 29/07/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface AdviceListTableViewCell : UITableViewCell

@property (nonatomic, retain) UIView *mainContainer;

@property (nonatomic, retain) AsyncImageView *imageViewInfo;

@property (nonatomic, retain) UILabel *lblClickHere;
@property (nonatomic, retain) UILabel *lblAdviceTitle;

@property (nonatomic, retain) UIView *separatorView;

@end
