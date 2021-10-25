//
//  MyPetListTableViewCell.h
//  Tip for Pet
//
//  Created by Pratik Gujarati on 02/08/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"

@interface MyPetListTableViewCell : UITableViewCell

@property (nonatomic, retain) UIView *mainContainer;

@property (nonatomic, retain) AsyncImageView *imageViewPetImage;

@property (nonatomic, retain) UILabel *lblPetName;
@property (nonatomic, retain) UILabel *lblPetType;
@property (nonatomic, retain) UILabel *lblPetBreed;
@property (nonatomic, retain) UILabel *lblPetBirthdate;
@property (nonatomic, retain) UILabel *lblPetGender;

@property (nonatomic, retain) UIButton *btnUpdateDetails;

@property (nonatomic, retain) UIView *separatorView;

@end
