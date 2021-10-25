//
//  DataManager.h
//  HungerE
//
//  Created by Pratik Gujarati on 23/09/16.
//  Copyright © 2016 accereteinfotech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Reachability.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
#import "CommonUtility.h"
#import <sqlite3.h>

//IMPORTING MODELS
#import "User.h"
#import "PetType.h"
#import "Reminder.h"
#import "Category.h"
#import "SubCategory.h"
#import "Advice.h"
#import "Pet.h"

@interface DataManager : NSObject
{
    // The delegate - Will be notified of various changes of state via the DataManagerDelegate
    
    NSNumber  *isNetworkAvailable;
    AppDelegate *appDelegate;
    
    User *objLoggedInUser;
}

//==================== SQLITE VARIABLES ====================//

@property (strong, nonatomic) NSString *databasePath;
@property (nonatomic) sqlite3 *mainDB;

//==================== OTHER VARIABLES ====================//

@property(nonatomic,retain) AppDelegate *appDelegate;
@property(nonatomic,retain) NSDictionary *dictionaryWebservicesUrls;

@property(nonatomic,retain) User *objLoggedInUser;

@property(nonatomic,retain) NSMutableArray *arrayPetTypes;
@property(nonatomic,retain) NSMutableArray *arrayCategories;
@property(nonatomic,retain) NSMutableArray *arraySubCategories;
@property(nonatomic,retain) NSMutableArray *arrayAdvices;

@property(nonatomic,retain) NSMutableArray *arrayAllRemindersFromSQLiteDatabase;

@property(nonatomic,retain) NSMutableArray *arrayMyPets;

@property(nonatomic,assign) BOOL boolIsPetAddedSuccessfully;
@property(nonatomic,assign) BOOL boolIsPetUpdatedSuccessfully;
@property(nonatomic,assign) BOOL boolIsPetImageChangedSuccessfully;
@property(nonatomic,assign) BOOL boolIsReminderAddedSuccessfully;

#pragma mark - Server communication

//FUNCTION TO CHECK IF INTERNET CONNECTION IS AVAILABLE OR NOT
-(BOOL)isNetworkAvailable;

//FUNCTION TO SHOW ERROR ALERT
-(void)showErrorMessage:(NSString *)errorTitle withErrorContent:(NSString *)errorDescription;

//==================== SQLITE METHODS ====================//

//CREATE SQLITE DATABASE
-(void)createDatabaseTable;

//USER FUNCTION TO INSERT REMINDER ENTRY TO SQLITE DATABASE
-(void)user_addReminderToSqliteDatabase:(NSMutableArray *)arrayReminderDictionaries;

//USER FUNCTION TO GET ALL REMINDER ENTRIES FROM SQLITE DATABASE
-(void)user_getAllRemindersFromSqliteDatabase;

//USER FUNCTION TO DELETE A REMINDER ENTRY FROM SQLITE DATABASE
-(void)user_deleteAReminderFromSqliteDatabase:(NSString *)strReminderUniqueId;

//USER FUNCTION TO DELETE ALL REMINDER ENTRIES FROM SQLITE DATABASE
-(void)user_deleteAllRemindersFromSqliteDatabase;

//==================== USER APP WEBSERVICES ====================//

//USER FUNCTION FOR LOGIN
-(void)user_login:(User *)objUser;

//USER FUNCTION FOR LOGOUT
-(void)user_logout:(NSString *)strUserId;

//USER FUNCTION FOR SIGNUP
-(void)user_signUp:(User *)objUser;

//USER FUNCTION TO GET PROFILE DETAILS BY USER ID
-(void)user_getProfileDetailsByUserId:(NSString *)strUserId;

//USER FUNCTION TO UPDATE PROFILE
-(void)user_updateProfile:(NSDictionary *)dictParameters;

//USER FUNCTION FOR FORGET PASSWORD
-(void)user_forgetPassword:(NSString *)strEmail;

//USER FUNCTION TO CHANGE PASSWORD
-(void)user_changePassword:(NSDictionary *)dictParameters;

//USER FUNCTION TO CHANGE PROFILE PICTURE
-(void)user_changeProfilePicture:(NSString *)strUserId withProfilePictureData:(NSData *)profilePictureData;

//FUNCTION TO GET ALL PET TYPES
-(void)getAllPetTypes;

//FUNCTION TO GET ALL CATEGORIES BY PET TYPE ID
-(void)getAllCategories:(NSString *)strPetTypeId;

//FUNCTION TO GET ALL SUB CATEGORIES BY CATEGORY ID
-(void)getAllSubCategories:(NSString *)strCategoryId;

//FUNCTION TO GET ALL ADVICES BY SUB CATEGORY ID
-(void)getAllAdvices:(NSString *)strSubCategoryId;

//USER FUNCTION TO GET ALL MY PETS BY USER ID
-(void)user_getAllMyPetsByUserId:(NSString *)strUserId;

//USER FUNCTION TO ADD MY PET
-(void)user_addMyPet:(Pet *)objPet;

//USER FUNCTION TO DELETE MY PET BY USER ID AND PET ID
-(void)user_deleteMyPetByUserId:(NSString *)strUserId withPetId:(NSString *)strPetId;

//USER FUNCTION TO UPDATE MY PET
-(void)user_updateMyPet:(Pet *)objPet;

//USER FUNCTION TO CHANGE PET IMAGE
-(void)user_changeMyPetImage:(NSString *)strPetId withPetImageData:(NSData *)petImageData;

@end
