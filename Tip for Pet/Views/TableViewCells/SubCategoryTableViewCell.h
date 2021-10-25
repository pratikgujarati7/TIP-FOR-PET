//
//  SubCategoryTableViewCell.h
//  Tip for Pet
//
//  Created by Pratik Gujarati on 28/07/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface SubCategoryTableViewCell : UITableViewCell

@property (nonatomic, retain) UIView *mainContainer;

@property (nonatomic, retain) AsyncImageView *imageViewSubCategoryPicture;

@property (nonatomic, retain) UILabel *lblSubCategoryName;

@property (nonatomic, retain) UIButton *btnFindOutMore;

@property (nonatomic, retain) UIView *separatorView;


@end
