//
//  User_UpdateMyPetViewController.m
//  Tip for Pet
//
//  Created by Pratik Gujarati on 03/08/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "User_UpdateMyPetViewController.h"
#import "MySingleton.h"

#import "IQKeyboardManager.h"

@interface User_UpdateMyPetViewController ()
{
    AppDelegate *appDelegate;
    
    BOOL boolIsSetupNotificationEventCalledOnce;
}

@end

@implementation User_UpdateMyPetViewController

//========== IBOUTLETS ==========//

@synthesize mainScrollView;

@synthesize mainContainerView;

@synthesize petImageContainerView;
@synthesize imageViewBack;
@synthesize btnBack;
@synthesize imageViewPetImage;
@synthesize imageViewLogo;
@synthesize uploadPhotoContainerView;
@synthesize imageViewUploadPhoto;
@synthesize btnUploadPhoto;

@synthesize txtPetName;
@synthesize txtPetNameBottomSeparatorView;

@synthesize txtPetType;
@synthesize txtPetTypeBottomSeparatorView;
@synthesize imageViewPetTypeDropDownArrow;

@synthesize txtPetBreed;
@synthesize txtPetBreedBottomSeparatorView;

@synthesize txtPetBirthdate;
@synthesize txtPetBirthdateBottomSeparatorView;
@synthesize imageViewPetBirthdateDropDownArrow;

@synthesize txtPetGender;
@synthesize txtPetGenderBottomSeparatorView;
@synthesize imageViewPetGenderDropDownArrow;

@synthesize btnUpdate;

//========== OTHER VARIABLES ==========//

@synthesize petTypePickerView;

@synthesize petGenderPickerView;

@synthesize petBirthdatePicker;

#pragma mark - View Controller Delegate Methods

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupNotificationEvent];
    
    [self setupInitialView];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNotificationEvent];
    
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:true];
    [[IQKeyboardManager sharedManager] setEnable:true];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    
    [self removeNotificationEventObserver];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Layout Subviews Methods

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    uploadPhotoContainerView.layer.cornerRadius = uploadPhotoContainerView.frame.size.height/2;
    
    mainScrollView.contentSize = CGSizeMake(mainScrollView.frame.size.width, btnUpdate.frame.origin.y + btnUpdate.frame.size.height + 20);
}

#pragma mark - Setup Notification Methods

-(void)setupNotificationEvent
{
    if(boolIsSetupNotificationEventCalledOnce == false)
    {
        boolIsSetupNotificationEventCalledOnce = true;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_updatedMyPetEvent) name:@"user_updatedMyPetEvent" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(user_changedMyPetImageEvent) name:@"user_changedMyPetImageEvent" object:nil];
    }
}

-(void)removeNotificationEventObserver
{
    boolIsSetupNotificationEventCalledOnce = false;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)user_updatedMyPetEvent
{
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    alertViewController.title = @"";
    alertViewController.message = @"Your pet has been updated successfully.";
    alertViewController.view.tintColor = [UIColor whiteColor];
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    alertViewController.transitionStyle = NYAlertViewControllerTransitionStyleFade;
    
    alertViewController.titleFont = [MySingleton sharedManager].alertViewTitleFont;
    alertViewController.messageFont = [MySingleton sharedManager].alertViewMessageFont;
    alertViewController.buttonTitleFont = [MySingleton sharedManager].alertViewButtonTitleFont;
    alertViewController.cancelButtonTitleFont = [MySingleton sharedManager].alertViewCancelButtonTitleFont;
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action){
        
        [alertViewController dismissViewControllerAnimated:YES completion:nil];
        
        [MySingleton sharedManager].dataManager.boolIsPetUpdatedSuccessfully = true;
        [self.navigationController popViewControllerAnimated:YES];
    }]];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:alertViewController animated:YES completion:nil];
    });
}

-(void)user_changedMyPetImageEvent
{
    [MySingleton sharedManager].dataManager.boolIsPetUpdatedSuccessfully = true;
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegate showErrorAlertViewWithTitle:@"Pet image changed" withDetails:@"You have successfully changed your pet image."];
    });
}

#pragma mark - UI Setup Method

- (void)setupInitialView
{
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    mainScrollView.delegate = self;
    
    if (@available(iOS 11.0, *))
    {
        mainScrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    }
    else
    {
        self.automaticallyAdjustsScrollViewInsets = false;
    }
    
    self.arrayPetGender = [[NSMutableArray alloc]initWithObjects:@"Male",@"Female",nil];
    
    UIFont *txtFieldFont, *btnFont;
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        txtFieldFont = [MySingleton sharedManager].themeFontSixteenSizeRegular;
        btnFont = [MySingleton sharedManager].themeFontEighteenSizeBold;
    }
    else
    {
        if([MySingleton sharedManager].screenHeight == 480)
        {
            txtFieldFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontFourteenSizeBold;
        }
        else if([MySingleton sharedManager].screenHeight == 568)
        {
            txtFieldFont = [MySingleton sharedManager].themeFontTwelveSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontFourteenSizeBold;
        }
        else if([MySingleton sharedManager].screenHeight == 667)
        {
            txtFieldFont = [MySingleton sharedManager].themeFontThirteenSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontFifteenSizeBold;
        }
        else if([MySingleton sharedManager].screenHeight >= 736)
        {
            txtFieldFont = [MySingleton sharedManager].themeFontFourteenSizeRegular;
            btnFont = [MySingleton sharedManager].themeFontSixteenSizeBold;
        }
    }
    
    petImageContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalGreenColor;
    
    imageViewBack.layer.masksToBounds = YES;
    [btnBack addTarget:self action:@selector(btnBackClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    imageViewPetImage.layer.masksToBounds = true;
    imageViewPetImage.contentMode = UIViewContentModeScaleAspectFill;
    imageViewPetImage.imageURL = [NSURL URLWithString:self.objPetToBeUpdated.strPetImageUrl];
    
    imageViewLogo.layer.masksToBounds = true;
    imageViewLogo.contentMode = UIViewContentModeScaleAspectFit;
    
    uploadPhotoContainerView.backgroundColor = [MySingleton sharedManager].themeGlobalWhiteColor;
    uploadPhotoContainerView.layer.masksToBounds = false;
    
    // border
    [uploadPhotoContainerView.layer setBorderColor:[MySingleton sharedManager].themeGlobalDarkGreenColor.CGColor];
    [uploadPhotoContainerView.layer setBorderWidth:1.5f];
    
    // drop shadow
    [uploadPhotoContainerView.layer setShadowColor:[MySingleton sharedManager].themeGlobalBlackColor.CGColor];
    [uploadPhotoContainerView.layer setShadowOpacity:0.8];
    [uploadPhotoContainerView.layer setShadowRadius:3.0];
    [uploadPhotoContainerView.layer setShadowOffset:CGSizeMake(2.0, 2.0)];
    
    imageViewUploadPhoto.layer.masksToBounds = true;
    imageViewUploadPhoto.contentMode = UIViewContentModeScaleAspectFit;
    
    [btnUploadPhoto addTarget:self action:@selector(btnUploadPhotoClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    txtPetName.font = txtFieldFont;
    txtPetName.delegate = self;
    txtPetName.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Pet Name"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtPetName.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtPetName.tintColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtPetName.floatingLabelFont = txtFieldFont;
    txtPetName.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtPetName.keepBaseline = NO;
    [txtPetName setAutocorrectionType:UITextAutocorrectionTypeNo];
    txtPetName.text = self.objPetToBeUpdated.strPetName;
//    txtPetName.floatingLabelYPadding = 0;
    
    txtPetNameBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    petTypePickerView = [[UIPickerView alloc] init];
    petTypePickerView.delegate = self;
    petTypePickerView.dataSource = self;
    petTypePickerView.showsSelectionIndicator = YES;
    petTypePickerView.tag = 1;
    petTypePickerView.backgroundColor = [UIColor whiteColor];
    
    txtPetType.font = txtFieldFont;
    txtPetType.delegate = self;
    txtPetType.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Pet Type"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtPetType.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtPetType.tintColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtPetType.floatingLabelFont = txtFieldFont;
    txtPetType.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtPetType.keepBaseline = NO;
    [txtPetType setInputView:petTypePickerView];
    [txtPetType setAutocorrectionType:UITextAutocorrectionTypeNo];
    txtPetType.text = self.objPetToBeUpdated.strPetTypeName;
    
    NSMutableArray *arrayPetTypeIds = [[NSMutableArray alloc] init];
    
    for(int i = 0; i < [MySingleton sharedManager].dataManager.arrayPetTypes.count; i++)
    {
        PetType *objPetType = [[MySingleton sharedManager].dataManager.arrayPetTypes objectAtIndex:i];
        [arrayPetTypeIds addObject:objPetType.strPetTypeID];
    }
    
    NSInteger indexOfPetTypeId = [arrayPetTypeIds indexOfObject:self.objPetToBeUpdated.strPetTypeID];
    
    if(NSNotFound != indexOfPetTypeId)
    {
        self.objSelectedPetType = [[MySingleton sharedManager].dataManager.arrayPetTypes objectAtIndex:indexOfPetTypeId];
        [petTypePickerView selectRow:indexOfPetTypeId inComponent:0 animated:NO];
    }
    
    txtPetTypeBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    imageViewPetTypeDropDownArrow.layer.masksToBounds = YES;
    imageViewPetTypeDropDownArrow.userInteractionEnabled = true;
    UITapGestureRecognizer *imageViewPetTypeDropDownArrowTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewPetTypeDropDownArrowTapped:)];
    imageViewPetTypeDropDownArrowTapGesture.delegate = self;
    [imageViewPetTypeDropDownArrow addGestureRecognizer:imageViewPetTypeDropDownArrowTapGesture];
    
    txtPetBreed.font = txtFieldFont;
    txtPetBreed.delegate = self;
    txtPetBreed.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Pet Breed"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtPetBreed.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtPetBreed.tintColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtPetBreed.floatingLabelFont = txtFieldFont;
    txtPetBreed.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtPetBreed.keepBaseline = NO;
    [txtPetBreed setAutocorrectionType:UITextAutocorrectionTypeNo];
    txtPetBreed.text = self.objPetToBeUpdated.strPetBreed;
    
    txtPetBreedBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    //PET BIRTHDATE PICKER
    petBirthdatePicker = [[UIDatePicker alloc] init];
    petBirthdatePicker.datePickerMode = UIDatePickerModeDate;
    if (@available(iOS 13.4, *)) {
        petBirthdatePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    }
    [petBirthdatePicker setMaximumDate: [NSDate date]];
    petBirthdatePicker.backgroundColor = [UIColor whiteColor];
    [petBirthdatePicker addTarget:self action:@selector(petBirthdateSelected:) forControlEvents:UIControlEventValueChanged];
    
    txtPetBirthdate.font = txtFieldFont;
    txtPetBirthdate.delegate = self;
    txtPetBirthdate.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Pet Birthdate"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtPetBirthdate.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtPetBirthdate.tintColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtPetBirthdate.floatingLabelFont = txtFieldFont;
    txtPetBirthdate.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtPetBirthdate.keepBaseline = NO;
    [txtPetBirthdate setInputView:petBirthdatePicker];
    [txtPetBirthdate setAutocorrectionType:UITextAutocorrectionTypeNo];
    txtPetBirthdate.text = self.objPetToBeUpdated.strPetBirthdate;
    
    txtPetBirthdateBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    imageViewPetBirthdateDropDownArrow.layer.masksToBounds = YES;
    imageViewPetBirthdateDropDownArrow.userInteractionEnabled = true;
    UITapGestureRecognizer *imageViewPetBirthdateDropDownArrowTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewPetBirthdateDropDownArrowTapped:)];
    imageViewPetBirthdateDropDownArrowTapGesture.delegate = self;
    [imageViewPetBirthdateDropDownArrow addGestureRecognizer:imageViewPetBirthdateDropDownArrowTapGesture];
    
    petGenderPickerView = [[UIPickerView alloc] init];
    petGenderPickerView.delegate = self;
    petGenderPickerView.dataSource = self;
    petGenderPickerView.showsSelectionIndicator = YES;
    petGenderPickerView.tag = 2;
    petGenderPickerView.backgroundColor = [UIColor whiteColor];
    
    txtPetGender.font = txtFieldFont;
    txtPetGender.delegate = self;
    txtPetGender.attributedPlaceholder =
    [[NSAttributedString alloc] initWithString:@"Pet Gender"
                                    attributes:@{NSForegroundColorAttributeName: [MySingleton sharedManager].textfieldPlaceholderColor}];
    txtPetGender.textColor = [MySingleton sharedManager].textfieldTextColor;
    txtPetGender.tintColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtPetGender.floatingLabelFont = txtFieldFont;
    txtPetGender.floatingLabelTextColor = [MySingleton sharedManager].textfieldFloatingLabelTextColor;
    txtPetGender.keepBaseline = NO;
    [txtPetGender setInputView:petGenderPickerView];
    [txtPetGender setAutocorrectionType:UITextAutocorrectionTypeNo];
    txtPetGender.text = self.objPetToBeUpdated.strPetGender;
    
    if([[txtPetGender.text lowercaseString] isEqualToString:@"male"])
    {
        [petGenderPickerView selectRow:0 inComponent:0 animated:NO];
    }
    else
    {
        [petGenderPickerView selectRow:1 inComponent:0 animated:NO];
    }
    
    txtPetGenderBottomSeparatorView.backgroundColor = [MySingleton sharedManager].textfieldBottomSeparatorColor;
    
    imageViewPetGenderDropDownArrow.layer.masksToBounds = YES;
    imageViewPetGenderDropDownArrow.userInteractionEnabled = true;
    UITapGestureRecognizer *imageViewPetGenderDropDownArrowTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewPetGenderDropDownArrowTapped:)];
    imageViewPetGenderDropDownArrowTapGesture.delegate = self;
    [imageViewPetGenderDropDownArrow addGestureRecognizer:imageViewPetGenderDropDownArrowTapGesture];
    
    btnUpdate.backgroundColor = [MySingleton sharedManager].themeGlobalGreenColor;
    btnUpdate.layer.masksToBounds = true;
    btnUpdate.layer.cornerRadius = [MySingleton sharedManager].floatButtonCornerRadius;
    btnUpdate.titleLabel.font = btnFont;
    [btnUpdate setTitleColor:[MySingleton sharedManager].themeGlobalWhiteColor forState:UIControlStateNormal];
    [btnUpdate addTarget:self action:@selector(btnUpdateClicked:) forControlEvents:UIControlEventTouchUpInside];
}

-(IBAction)btnBackClicked:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imageViewPetTypeDropDownArrowTapped: (UITapGestureRecognizer *)recognizer
{
    [txtPetType becomeFirstResponder];
}

- (void)imageViewPetGenderDropDownArrowTapped: (UITapGestureRecognizer *)recognizer
{
    [txtPetBirthdate becomeFirstResponder];
}

- (void)imageViewPetBirthdateDropDownArrowTapped: (UITapGestureRecognizer *)recognizer
{
    [txtPetGender becomeFirstResponder];
}

#pragma mark - UITextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == txtPetType)
    {
        if(txtPetType.text.length == 0 )
        {
            if([MySingleton sharedManager].dataManager.arrayPetTypes.count > 0)
            {
                self.objSelectedPetType = [[MySingleton sharedManager].dataManager.arrayPetTypes objectAtIndex:0];
                txtPetType.text = self.objSelectedPetType.strPetType;
                [petTypePickerView selectRow:0 inComponent:0 animated:YES];
            }
            else
            {
                [self.view endEditing:true];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [appDelegate showErrorAlertViewWithTitle:@"No Pet Types Added" withDetails:@"Currently we don't have any pet types. Please try again later."];
                });
            }
        }
    }
    else if(textField == txtPetGender)
    {
        if(txtPetGender.text.length == 0 )
        {
            txtPetGender.text = [self.arrayPetGender objectAtIndex:0];
            [petGenderPickerView selectRow:0 inComponent:0 animated:YES];
        }
    }
    else if(textField == txtPetBirthdate)
    {
        if(txtPetBirthdate.text.length == 0)
        {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
            [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
            dateFormat.dateStyle = NSDateFormatterMediumStyle;
            [dateFormat setDateFormat:@"dd MMM, yyyy"];
            NSString *strSelectedDate = [NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:petBirthdatePicker.date]];
            txtPetBirthdate.text = strSelectedDate;
        }
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
}

#pragma mark - UIPickerView Delegate Methods

// tell the picker how many components it will have
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// tell the picker how many rows are available for a given component
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    NSInteger rowsInComponent;
    
    if(pickerView.tag == 1)
    {
        rowsInComponent = [[MySingleton sharedManager].dataManager.arrayPetTypes count];
    }
    else if(pickerView.tag == 2)
    {
        rowsInComponent = [self.arrayPetGender count];
    }
    
    return rowsInComponent;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel* lblMain = (UILabel*)view;
    if (!lblMain){
        lblMain = [[UILabel alloc] init];
        // Setup label properties - frame, font, colors etc
    }
    
    if (pickerView == petTypePickerView)
    {
        PetType *objPetType = [MySingleton sharedManager].dataManager.arrayPetTypes[row];
        lblMain.text = objPetType.strPetType;
        lblMain.font = [MySingleton sharedManager].themeFontSixteenSizeRegular;
        
    }
    else if (pickerView == petGenderPickerView)
    {
        lblMain.text = self.arrayPetGender[row];
        lblMain.font = [MySingleton sharedManager].themeFontSixteenSizeRegular;
    }
    
    lblMain.textAlignment = NSTextAlignmentCenter;
    return lblMain;
}

// tell the picker the width of each row for a given component
- (CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component
{
    return [MySingleton sharedManager].screenWidth;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(pickerView.tag == 1)
    {
        self.objSelectedPetType = [[MySingleton sharedManager].dataManager.arrayPetTypes objectAtIndex:row];
        txtPetType.text = self.objSelectedPetType.strPetType;
    }
    else if(pickerView.tag == 2)
    {
        txtPetGender.text = [self.arrayPetGender objectAtIndex:row];
    }
}

#pragma mark - UIImagePickerController Delegate Method

-(UIImage*)imageWithImage: (UIImage*) sourceImage scaledToWidth: (float) i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    @try
    {
        UIImage *image = (UIImage *)[info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage* smaller = [self imageWithImage:image scaledToWidth:320];
        
        //SEND IMAGE DATA TO SERVER
        NSData *selectedImageData = UIImagePNGRepresentation(smaller);
        NSString *selectedImageBase64Data = [selectedImageData base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
        
        UIGraphicsEndImageContext();
        
        [picker dismissViewControllerAnimated:NO completion:NULL];
        
        imageViewPetImage.image = image;
        
        [[MySingleton sharedManager].dataManager user_changeMyPetImage:self.objPetToBeUpdated.strPetID withPetImageData:selectedImageData];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in imagePickerController's didFinishPickingMediaWithInfo Method, Exception : %@",exception);
    }
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Image Selection Methods

-(void)takeAPhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePickerController.allowsEditing = YES;
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [imagePickerController setModalPresentationStyle:UIModalPresentationPopover];
            UIPopoverPresentationController *popPresenter = [imagePickerController
                                                             popoverPresentationController];
            popPresenter.sourceView = uploadPhotoContainerView;
            popPresenter.sourceRect = uploadPhotoContainerView.bounds;
            popPresenter.permittedArrowDirections = UIPopoverArrowDirectionAny;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:imagePickerController animated:YES completion:nil];
            });
        }
        else
        {
            if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
            {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self presentViewController:imagePickerController animated:YES completion:nil];
                }];
            }
            else
            {
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showErrorAlertViewWithTitle:@"Camera Unavailable" withDetails:@"Unable to find a camera on your device."];
        });
    }
}

-(void)chooseFromGallery
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc]init];
        imagePickerController.delegate = self;
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.allowsEditing = YES;
        
        if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            [imagePickerController setModalPresentationStyle:UIModalPresentationPopover];
            UIPopoverPresentationController *popPresenter = [imagePickerController
                                                             popoverPresentationController];
            popPresenter.sourceView = uploadPhotoContainerView;
            popPresenter.sourceRect = uploadPhotoContainerView.bounds;
            popPresenter.permittedArrowDirections = UIPopoverArrowDirectionAny;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self presentViewController:imagePickerController animated:YES completion:nil];
            });
        }
        else
        {
            if([[[UIDevice currentDevice] systemVersion] floatValue]>=8.0)
            {
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self presentViewController:imagePickerController animated:YES completion:nil];
                }];
            }
            else
            {
                [self presentViewController:imagePickerController animated:YES completion:nil];
            }
        }
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showErrorAlertViewWithTitle:@"Photo library Unavailable" withDetails:@"Unable to find photo library on your device."];
        });
    }
}

#pragma mark - Other Methods

-(void)doneClicked:(id)sender
{
    [self.view endEditing:YES];
}

-(IBAction)btnUploadPhotoClicked:(id)sender
{
    [self.view endEditing:true];
    
    UIAlertController *actionSheet = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
        // Cancel button tappped.
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Take a Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Take a Photo
        [self dismissViewControllerAnimated:YES completion:nil];
        [self takeAPhoto];
    }]];
    
    [actionSheet addAction:[UIAlertAction actionWithTitle:@"Choose from Gallery" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        
        // Choose from Gallery
        [self dismissViewControllerAnimated:YES completion:nil];
        [self chooseFromGallery];
    }]];
    
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        [actionSheet setModalPresentationStyle:UIModalPresentationPopover];
        UIPopoverPresentationController *popPresenter = [actionSheet
                                                         popoverPresentationController];
        popPresenter.sourceView = uploadPhotoContainerView;
        popPresenter.sourceRect = uploadPhotoContainerView.bounds;
        popPresenter.permittedArrowDirections = UIPopoverArrowDirectionAny;
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:actionSheet animated:YES completion:nil];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self presentViewController:actionSheet animated:YES completion:nil];
        });
    }
}

-(void)petBirthdateSelected:(id)sender
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
    [dateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    dateFormat.dateStyle = NSDateFormatterMediumStyle;
    [dateFormat setDateFormat:@"dd MMM, yyyy"];
    NSString *strSelectedDate = [NSString stringWithFormat:@"%@",[dateFormat  stringFromDate:petBirthdatePicker.date]];
    txtPetBirthdate.text = strSelectedDate;
}

-(IBAction)btnUpdateClicked:(id)sender
{
    [self.view endEditing:true];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    self.objPetToBeUpdated.strPetTypeID = self.objSelectedPetType.strPetTypeID;
    self.objPetToBeUpdated.strPetTypeName = self.objSelectedPetType.strPetType;
    self.objPetToBeUpdated.strPetName = txtPetName.text;
    self.objPetToBeUpdated.strPetBreed = txtPetBreed.text;
    self.objPetToBeUpdated.strPetBirthdate = txtPetBirthdate.text;
    self.objPetToBeUpdated.strPetGender = txtPetGender.text;
    self.objPetToBeUpdated.strPetUserId = [prefs objectForKey:@"userid"];
    
    if([self.objPetToBeUpdated isValidatePetToUpdate])
    {
        [[MySingleton sharedManager].dataManager user_updateMyPet:self.objPetToBeUpdated];
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showErrorAlertViewWithTitle:@"" withDetails:self.objPetToBeUpdated.strValidationMessage];
        });
    }
}

@end
