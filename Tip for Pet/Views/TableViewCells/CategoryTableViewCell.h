//
//  CategoryTableViewCell.h
//  Tip for Pet
//
//  Created by Pratik Gujarati on 28/07/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface CategoryTableViewCell : UITableViewCell

@property (nonatomic, retain) UIView *mainContainer;

@property (nonatomic, retain) AsyncImageView *imageViewCategoryPicture;

@property (nonatomic, retain) UILabel *lblCategoryName;

@property (nonatomic, retain) UIButton *btnFindOutMore;

@property (nonatomic, retain) UIView *separatorView;

@end
