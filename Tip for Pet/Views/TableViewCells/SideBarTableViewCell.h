//
//  SideBarTableViewCell.h
//  PRATIK GUJARATI
//
//  Created by Pratik Gujarati on 00/00/00.
//  Copyright © 2017 accreteit. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "CustomLabel.h"

@interface SideBarTableViewCell : UITableViewCell

@property (nonatomic, retain) UIView *mainContainer;

@property (nonatomic, retain) AsyncImageView *imageViewMain;
@property (nonatomic, retain) CustomLabel *lblMain;

@property (nonatomic, retain) UIView *separatorView;

- (id)initWithTwoLinesStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
