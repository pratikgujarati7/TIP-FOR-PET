//
//  User.h
//  ENZYM
//
//  Created by Pratik Gujarati on 24/05/17.
//  Copyright © 2017 accreteit. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonUtility.h"

@interface User : NSObject

@property(nonatomic,retain) NSString *strValidationMessage;

@property(nonatomic,retain) NSString *strUserID;
@property(nonatomic,retain) NSString *strEmail;
@property(nonatomic,retain) NSString *strName;
@property(nonatomic,retain) NSString *strPassword;
@property(nonatomic,retain) NSString *strPhoneNumber;
@property(nonatomic,retain) NSString *strProfilePictureImageUrl;

@property(nonatomic,retain) NSData *profilePictureData;

-(BOOL)isValidateUserForLogin;
-(BOOL)isValidateUserForRegistration;
-(BOOL)isValidateUserForUpdation;

@end
