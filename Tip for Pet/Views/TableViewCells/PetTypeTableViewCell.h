//
//  PetTypeTableViewCell.h
//  Tip for Pet
//
//  Created by Pratik Gujarati on 20/07/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface PetTypeTableViewCell : UITableViewCell

@property (nonatomic, retain) UIView *mainContainer;

@property (nonatomic, retain) AsyncImageView *imageViewPetTypePicture;

@property (nonatomic, retain) UILabel *lblPetType;
@property (nonatomic, retain) UILabel *lblPetTypeDescription;

@property (nonatomic, retain) UIButton *btnGetTips;

@property (nonatomic, retain) UIView *separatorView;

@end
