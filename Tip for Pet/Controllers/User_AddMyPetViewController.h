//
//  User_AddMyPetViewController.h
//  Tip for Pet
//
//  Created by Pratik Gujarati on 02/08/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AsyncImageView.h"
#import "JVFloatLabeledTextField.h"

#import "Pet.h"
#import "PetType.h"

@interface User_AddMyPetViewController : UIViewController<UIScrollViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

//========== IBOUTLETS ==========//

@property (nonatomic,retain) IBOutlet UIScrollView *mainScrollView;

@property (nonatomic,retain) IBOutlet UIView *mainContainerView;

@property (nonatomic,retain) IBOutlet UIView *petImageContainerView;
@property (nonatomic,retain) IBOutlet UIImageView *imageViewBack;
@property (nonatomic,retain) IBOutlet UIButton *btnBack;
@property (nonatomic,retain) IBOutlet AsyncImageView *imageViewPetImage;
@property (nonatomic,retain) IBOutlet AsyncImageView *imageViewLogo;
@property (nonatomic,retain) IBOutlet UIView *uploadPhotoContainerView;
@property (nonatomic,retain) IBOutlet AsyncImageView *imageViewUploadPhoto;
@property (nonatomic,retain) IBOutlet UIButton *btnUploadPhoto;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtPetName;
@property (nonatomic,retain) IBOutlet UIView *txtPetNameBottomSeparatorView;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtPetType;
@property (nonatomic,retain) IBOutlet UIView *txtPetTypeBottomSeparatorView;
@property (nonatomic,retain) IBOutlet AsyncImageView *imageViewPetTypeDropDownArrow;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtPetBreed;
@property (nonatomic,retain) IBOutlet UIView *txtPetBreedBottomSeparatorView;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtPetBirthdate;
@property (nonatomic,retain) IBOutlet UIView *txtPetBirthdateBottomSeparatorView;
@property (nonatomic,retain) IBOutlet AsyncImageView *imageViewPetBirthdateDropDownArrow;

@property (nonatomic,retain) IBOutlet JVFloatLabeledTextField *txtPetGender;
@property (nonatomic,retain) IBOutlet UIView *txtPetGenderBottomSeparatorView;
@property (nonatomic,retain) IBOutlet AsyncImageView *imageViewPetGenderDropDownArrow;

@property (nonatomic,retain) IBOutlet UIButton *btnAdd;

//========== OTHER VARIABLES ==========//

@property (nonatomic,retain) Pet *objPetToBeAdded;

@property (nonatomic,retain) NSMutableArray *arrayPetTypes;
@property (nonatomic,retain) UIPickerView *petTypePickerView;

@property (nonatomic,retain) PetType *objSelectedPetType;

@property (nonatomic,retain) NSMutableArray *arrayPetGender;
@property (nonatomic,retain) UIPickerView *petGenderPickerView;

@property (nonatomic,retain) UIDatePicker *petBirthdatePicker;

@end
