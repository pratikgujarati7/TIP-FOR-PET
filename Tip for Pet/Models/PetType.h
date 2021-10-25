//
//  PetType.h
//  Tip for Pet
//
//  Created by Pratik Gujarati on 20/07/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PetType : NSObject

@property(nonatomic,retain) NSString *strPetTypeID;
@property(nonatomic,retain) NSString *strPetType;
@property(nonatomic,retain) NSString *strPetTypeDescription;
@property(nonatomic,retain) NSString *strPetTypePictureImageUrl;
@property(nonatomic,assign) BOOL boolPetTypeIsPaid;
@property(nonatomic,retain) NSString *strPetTypeInAppPurchaseProductIdentifier;
@property(nonatomic,retain) NSString *strPetTypeInAppPurchaseProductFlagName;

@end
