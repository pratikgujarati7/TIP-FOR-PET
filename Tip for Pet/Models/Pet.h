//
//  Pet.h
//  Tip for Pet
//
//  Created by Pratik Gujarati on 01/08/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Pet : NSObject

@property(nonatomic,retain) NSString *strValidationMessage;

@property(nonatomic,retain) NSString *strPetID;
@property(nonatomic,retain) NSString *strPetTypeID;
@property(nonatomic,retain) NSString *strPetTypeName;
@property(nonatomic,retain) NSString *strPetName;
@property(nonatomic,retain) NSString *strPetBreed;
@property(nonatomic,retain) NSString *strPetBirthdate;
@property(nonatomic,retain) NSString *strPetGender;
@property(nonatomic,retain) NSString *strPetImageUrl;
@property(nonatomic,retain) NSString *strPetUserId;

@property(nonatomic,retain) NSData *petImageData;

-(BOOL)isValidatePetToAdd;
-(BOOL)isValidatePetToUpdate;

@end
