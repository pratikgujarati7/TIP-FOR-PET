 //
//  DataManager.m
//  HungerE
//
//  Created by Pratik Gujarati on 23/09/16.
//  Copyright © 2016 accereteinfotech. All rights reserved.
//

#import "DataManager.h"
#import "MySingleton.h"
#import "NYAlertViewController.h"

@implementation DataManager

-(id)init
{
    _dictionaryWebservicesUrls = [NSDictionary dictionaryWithContentsOfFile: [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent: @"WebservicesUrls.plist"]];
    
    appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    
    return self;
}

- (BOOL) isNetworkAvailable
{
    Reachability *reach = [Reachability reachabilityWithHostName:[_dictionaryWebservicesUrls objectForKey:@"AvailabilityHostToCheck"]];
    NetworkStatus status = [reach currentReachabilityStatus];
    isNetworkAvailable = [NSNumber numberWithBool:!(status == NotReachable)];
    reach = nil;
    return [isNetworkAvailable boolValue];
}

-(void)showInternetNotConnectedError
{
    NYAlertViewController *alertViewController = [[NYAlertViewController alloc] initWithNibName:nil bundle:nil];
    alertViewController.title = @"No Internet Connection";
    alertViewController.message = @"Please make sure that you are connected to the internet.";
    
    alertViewController.view.tintColor = [UIColor whiteColor];
    alertViewController.backgroundTapDismissalGestureEnabled = YES;
    alertViewController.swipeDismissalGestureEnabled = YES;
    alertViewController.transitionStyle = NYAlertViewControllerTransitionStyleFade;
    
    alertViewController.titleFont = [MySingleton sharedManager].alertViewTitleFont;
    alertViewController.messageFont = [MySingleton sharedManager].alertViewMessageFont;
    alertViewController.buttonTitleFont = [MySingleton sharedManager].alertViewButtonTitleFont;
    alertViewController.cancelButtonTitleFont = [MySingleton sharedManager].alertViewCancelButtonTitleFont;
    
    [alertViewController addAction:[NYAlertAction actionWithTitle:@"Go to Settings" style:UIAlertActionStyleDefault handler:^(NYAlertAction *action)
    {
        [alertViewController dismissViewControllerAnimated:YES completion:nil];
        
        if (UIApplicationOpenSettingsURLString != NULL)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
        }
    }]];
    
    [[[[UIApplication sharedApplication] keyWindow] rootViewController] presentViewController:alertViewController animated:YES completion:nil];
}

-(void)showErrorMessage:(NSString *)errorTitle withErrorContent:(NSString *)errorDescription
{
    if([errorTitle isEqualToString:@"Server Error"])
    {
        errorDescription = @"Oops! Something went wrong. Please try again later.";
    }
    else
    {
        errorDescription = errorDescription;
    }
    
    [appDelegate dismissGlobalHUD];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [appDelegate showErrorAlertViewWithTitle:errorTitle withDetails:errorDescription];
    });
}

- (void)connectionError
{
    [appDelegate dismissGlobalHUD];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"connectionErrorEvent" object:nil];
    [self showInternetNotConnectedError];
}

//==================== SQLITE METHODS ====================//
#pragma mark - SQLITE METHODS

#pragma mark CREATE SQLITE DATABASE

-(void)createDatabaseTable
{
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"Tip_For_Pet.sqlite"]];
    NSLog(@"_databasePath : %@", _databasePath);
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _databasePath ] == NO)
    {
        const char *dbpath = [_databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &_mainDB) == SQLITE_OK)
        {
            char *errMsg;
            
            const char *sql_stmt = "CREATE TABLE IF NOT EXISTS Reminders (Reminder_Unique_Id TEXT, Reminder_Medicine_Name TEXT, Reminder_Quantity TEXT, Reminder_Pet_Id TEXT, Reminder_Pet_Type TEXT, Reminder_Pet_Name TEXT, Reminder_Pet_Image_Url TEXT, Reminder_Date_And_Time TEXT)";
            
            if (sqlite3_exec(_mainDB, sql_stmt, NULL, NULL, &errMsg) != SQLITE_OK)
            {
                NSLog(@"Failed to create Reminders table");
            }
            
            sqlite3_close(_mainDB);
        }
        else
        {
            NSLog(@"Failed to open database!");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [appDelegate showErrorAlertViewWithTitle:@"Failed to Connect" withDetails:@"We are sorry! TIP FOR PET somehow failed to connect with database. Please try again after sometime."];
            });
        }
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"createdDatabaseTableEvent" object:nil];
}

#pragma mark USER FUNCTION TO INSERT REMINDER ENTRY TO SQLITE DATABASE

-(void)user_addReminderToSqliteDatabase:(NSMutableArray *)arrayReminderDictionaries
{
    [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"Tip_For_Pet.sqlite"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _databasePath ] != NO)
    {
        sqlite3_stmt *statement;
        const char *dbpath = [_databasePath UTF8String];
        if (sqlite3_open(dbpath, &_mainDB) == SQLITE_OK)
        {
            for(int i = 0; i < arrayReminderDictionaries.count; i++)
            {
                NSDictionary *dictParameters = [arrayReminderDictionaries objectAtIndex:i];
                
                NSString *insertSQL;
                
                insertSQL = [NSString stringWithFormat:@"INSERT INTO Reminders (Reminder_Unique_Id, Reminder_Medicine_Name, Reminder_Quantity, Reminder_Pet_Id, Reminder_Pet_Type, Reminder_Pet_Name, Reminder_Pet_Image_Url, Reminder_Date_And_Time) VALUES (\"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\", \"%@\",\"%@\")", [dictParameters objectForKey:@"UniqueId"], [dictParameters objectForKey:@"MedicineName"], [dictParameters objectForKey:@"Quantity"], [dictParameters objectForKey:@"PetId"], [dictParameters objectForKey:@"PetType"], [dictParameters objectForKey:@"PetName"], [dictParameters objectForKey:@"PetImageUrl"], [dictParameters objectForKey:@"AlertDateAndTime"]];
                
                const char *insert_stmt = [insertSQL UTF8String];
                sqlite3_prepare_v2(_mainDB, insert_stmt, -1, &statement, NULL);
                
                if (sqlite3_step(statement) == SQLITE_DONE)
                {
                    NSLog(@"inserted reminder into table");
                    
                    [appDelegate dismissGlobalHUD];
                }
                else
                {
                    NSLog( @"Failed to insert reminder");
                    
                    [appDelegate dismissGlobalHUD];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [appDelegate showErrorAlertViewWithTitle:@"Operation Failed" withDetails:@"Failed to insert your reminders."];
                    });
                }
                
                sqlite3_finalize(statement);
            }
            
            sqlite3_close(_mainDB);
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"user_addedReminderToSqliteDatabaseEvent" object:nil];
        }
    }
    else
    {
        [appDelegate dismissGlobalHUD];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showErrorAlertViewWithTitle:@"Database Not Found" withDetails:@"SQLite database not found. Please try again after sometime."];
        });
    }
}

#pragma mark USER FUNCTION TO DELETE A REMINDER ENTRY FROM SQLITE DATABASE

-(void)user_deleteAReminderFromSqliteDatabase:(NSString *)strReminderUniqueId
{
    [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"Tip_For_Pet.sqlite"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _databasePath ] != NO)
    {
        sqlite3_stmt *statement;
        const char *dbpath = [_databasePath UTF8String];
        if (sqlite3_open(dbpath, &_mainDB) == SQLITE_OK)
        {
            NSString *deleteSQL;
            
            deleteSQL = [NSString stringWithFormat:@"DELETE FROM Reminders WHERE Reminder_Unique_Id = \"%@\"",strReminderUniqueId];
            
            const char *delete_stmt = [deleteSQL UTF8String];
            sqlite3_prepare_v2(_mainDB, delete_stmt, -1, &statement, NULL);
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"deleted reminder from table");
                
//                [appDelegate dismissGlobalHUD];
                
                self.arrayAllRemindersFromSQLiteDatabase = [[NSMutableArray alloc] init];
                
                NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM Reminders"];
                sqlite3_stmt *compiledStatement;
                
                if(sqlite3_prepare_v2(_mainDB, [querySQL UTF8String], -1, &compiledStatement, NULL) != SQLITE_OK)
                    NSLog(@"Error while creating detail view statement. '%s'", sqlite3_errmsg(_mainDB));
                
                if(sqlite3_prepare_v2(_mainDB, [querySQL UTF8String], -1, &compiledStatement, nil) == SQLITE_OK)
                {
                    while(sqlite3_step(compiledStatement) == SQLITE_ROW)
                    {
                        Reminder *objReminder = [[Reminder alloc] init];
                        
                        objReminder.strReminderUniqueID = [[NSString alloc] initWithUTF8String:
                                                           (const char *) sqlite3_column_text(compiledStatement, 0)];
                        objReminder.strReminderMedicineName = [[NSString alloc] initWithUTF8String:
                                                               (const char *) sqlite3_column_text(compiledStatement, 1)];
                        objReminder.strReminderQuantity = [[NSString alloc] initWithUTF8String:
                                                           (const char *) sqlite3_column_text(compiledStatement, 2)];
                        objReminder.strReminderPetId = [[NSString alloc] initWithUTF8String:
                                                        (const char *) sqlite3_column_text(compiledStatement, 3)];
                        objReminder.strReminderPetType = [[NSString alloc] initWithUTF8String:
                                                          (const char *) sqlite3_column_text(compiledStatement, 4)];
                        objReminder.strReminderPetName = [[NSString alloc] initWithUTF8String:
                                                          (const char *) sqlite3_column_text(compiledStatement, 5)];
                        objReminder.strReminderPetImageUrl = [[NSString alloc] initWithUTF8String:
                                                              (const char *) sqlite3_column_text(compiledStatement, 6)];
                        objReminder.strReminderDateAndTime = [[NSString alloc] initWithUTF8String:
                                                              (const char *) sqlite3_column_text(compiledStatement, 7)];
                        
                        [self.arrayAllRemindersFromSQLiteDatabase addObject:objReminder];
                    }
                    sqlite3_finalize(compiledStatement);
                }
            }
            else
            {
                NSLog( @"Failed to delete reminder");
                
                [appDelegate dismissGlobalHUD];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [appDelegate showErrorAlertViewWithTitle:@"Operation Failed" withDetails:@"Failed to delete this reminder."];
                });
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(_mainDB);
            
            [appDelegate dismissGlobalHUD];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"user_deletedAReminderFromSqliteDatabaseEvent" object:nil];
        }
    }
    else
    {
        [appDelegate dismissGlobalHUD];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showErrorAlertViewWithTitle:@"Database Not Found" withDetails:@"SQLite database not found. Please try again after sometime."];
        });
    }
}

#pragma mark USER FUNCTION TO GET ALL REMINDER ENTRIES FROM SQLITE DATABASE

-(void)user_getAllRemindersFromSqliteDatabase
{
    [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
    
    self.arrayAllRemindersFromSQLiteDatabase = [[NSMutableArray alloc] init];
    
    NSDateFormatter *fullDateFormat = [[NSDateFormatter alloc]init];
    [fullDateFormat setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"]];
    fullDateFormat.dateStyle = NSDateFormatterMediumStyle;
    if([appDelegate isClock24Hour])
    {
        [fullDateFormat setDateFormat:@"dd MMM, yy HH:mm"];
    }
    else
    {
        [fullDateFormat setDateFormat:@"dd MMM, yy hh:mm a"];
    }
    
    NSString *strCurrentDateWithCurrentTime = [fullDateFormat stringFromDate:[NSDate date]];
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"Tip_For_Pet.sqlite"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _databasePath ] != NO)
    {
        sqlite3_stmt *statement;
        const char *dbpath = [_databasePath UTF8String];
        if (sqlite3_open(dbpath, &_mainDB) == SQLITE_OK)
        {
            NSString *deleteSQL;
            
            deleteSQL = [NSString stringWithFormat:@"DELETE FROM Reminders WHERE Reminder_Date_And_Time <= \"%@\"", strCurrentDateWithCurrentTime];
            
            const char *delete_stmt = [deleteSQL UTF8String];
            sqlite3_prepare_v2(_mainDB, delete_stmt, -1, &statement, NULL);
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"deleted past reminders from current date and time from table");
                
                if (sqlite3_open(dbpath, &_mainDB) == SQLITE_OK)
                {
                    NSString *querySQL = [NSString stringWithFormat:@"SELECT * FROM Reminders"];
                    sqlite3_stmt *compiledStatement;
                    
                    if(sqlite3_prepare_v2(_mainDB, [querySQL UTF8String], -1, &compiledStatement, NULL) != SQLITE_OK)
                        NSLog(@"Error while creating detail view statement. '%s'", sqlite3_errmsg(_mainDB));
                    
                    if(sqlite3_prepare_v2(_mainDB, [querySQL UTF8String], -1, &compiledStatement, nil) == SQLITE_OK)
                    {
                        while(sqlite3_step(compiledStatement) == SQLITE_ROW)
                        {
                            Reminder *objReminder = [[Reminder alloc] init];
                            
                            objReminder.strReminderUniqueID = [[NSString alloc] initWithUTF8String:
                                                               (const char *) sqlite3_column_text(compiledStatement, 0)];
                            objReminder.strReminderMedicineName = [[NSString alloc] initWithUTF8String:
                                                                   (const char *) sqlite3_column_text(compiledStatement, 1)];
                            objReminder.strReminderQuantity = [[NSString alloc] initWithUTF8String:
                                                               (const char *) sqlite3_column_text(compiledStatement, 2)];
                            objReminder.strReminderPetId = [[NSString alloc] initWithUTF8String:
                                                               (const char *) sqlite3_column_text(compiledStatement, 3)];
                            objReminder.strReminderPetType = [[NSString alloc] initWithUTF8String:
                                                               (const char *) sqlite3_column_text(compiledStatement, 4)];
                            objReminder.strReminderPetName = [[NSString alloc] initWithUTF8String:
                                                               (const char *) sqlite3_column_text(compiledStatement, 5)];
                            objReminder.strReminderPetImageUrl = [[NSString alloc] initWithUTF8String:
                                                               (const char *) sqlite3_column_text(compiledStatement, 6)];
                            objReminder.strReminderDateAndTime = [[NSString alloc] initWithUTF8String:
                                                                  (const char *) sqlite3_column_text(compiledStatement, 7)];
                            
                            [self.arrayAllRemindersFromSQLiteDatabase addObject:objReminder];
                        }
                        sqlite3_finalize(compiledStatement);
                    }
                    
                    sqlite3_close(_mainDB);
                }
            }
        }
        
        [appDelegate dismissGlobalHUD];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"user_gotAllRemindersFromSqliteDatabaseEvent" object:nil];
    }
    else
    {
        [appDelegate dismissGlobalHUD];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showErrorAlertViewWithTitle:@"Database Not Found" withDetails:@"SQLite database not found. Please try again after sometime."];
        });
    }
}

#pragma mark USER FUNCTION TO DELETE ALL REMINDER ENTRIES FROM SQLITE DATABASE

-(void)user_deleteAllRemindersFromSqliteDatabase
{
    [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
    
    NSString *docsDir;
    NSArray *dirPaths;
    
    // Get the documents directory
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    docsDir = dirPaths[0];
    
    // Build the path to the database file
    _databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent:@"Tip_For_Pet.sqlite"]];
    
    NSFileManager *filemgr = [NSFileManager defaultManager];
    
    if ([filemgr fileExistsAtPath: _databasePath ] != NO)
    {
        sqlite3_stmt *statement;
        const char *dbpath = [_databasePath UTF8String];
        if (sqlite3_open(dbpath, &_mainDB) == SQLITE_OK)
        {
            NSString *deleteSQL;
            
            deleteSQL = [NSString stringWithFormat:@"DELETE FROM Reminders"];
            
            const char *delete_stmt = [deleteSQL UTF8String];
            sqlite3_prepare_v2(_mainDB, delete_stmt, -1, &statement, NULL);
            
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"deleted reminder from table");
                
                self.arrayAllRemindersFromSQLiteDatabase = [[NSMutableArray alloc] init];
            }
            else
            {
                NSLog( @"Failed to delete reminder");
                
                [appDelegate dismissGlobalHUD];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [appDelegate showErrorAlertViewWithTitle:@"Operation Failed" withDetails:@"Failed to delete this reminder."];
                });
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(_mainDB);
            
            [appDelegate dismissGlobalHUD];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"user_deletedAllRemindersFromSqliteDatabaseEvent" object:nil];
        }
    }
    else
    {
        [appDelegate dismissGlobalHUD];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [appDelegate showErrorAlertViewWithTitle:@"Database Not Found" withDetails:@"SQLite database not found. Please try again after sometime."];
        });
    }
}

//==================== COMMON USER APP WEBSERVICES ====================//
#pragma mark - USER APP WEBSERVICES -

#pragma mark USER FUNCTION FOR LOGIN

-(void)user_login:(User *)objUser
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Login"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:objUser.strEmail forKey:@"email"];
        [parameters setObject:objUser.strPassword forKey:@"password"];
        [parameters setObject:@"1" forKey:@"device_type"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    if(self.objLoggedInUser == nil)
                    {
                        self.objLoggedInUser = [[User alloc] init];
                    }
                    
                    self.objLoggedInUser.strUserID = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"user_id"]];
                    self.objLoggedInUser.strEmail = objUser.strEmail;
                    self.objLoggedInUser.strName = [jsonResult objectForKey:@"name"];
                    self.objLoggedInUser.strPhoneNumber = [jsonResult objectForKey:@"phone_number"];
                    NSCharacterSet *set = [NSCharacterSet URLFragmentAllowedCharacterSet];
                    self.objLoggedInUser.strProfilePictureImageUrl = [[NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"profile_picture_image_url"]] stringByAddingPercentEncodingWithAllowedCharacters:set];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                        
                        [prefs removeObjectForKey:@"loginskipped"];
                        
                        [prefs setObject:@"1" forKey:@"autologin"];
                        [prefs setObject:self.objLoggedInUser.strUserID forKey:@"userid"];
                        [prefs setObject:self.objLoggedInUser.strEmail forKey:@"useremail"];
                        [prefs setObject:self.objLoggedInUser.strName forKey:@"username"];
                        [prefs synchronize];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"user_loggedinEvent" object:nil];
                    });
                    
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"Login Failed" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION FOR LOGOUT

-(void)user_logout:(NSString *)strUserId
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Logout"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:strUserId forKey:@"user_id"];
        [parameters setObject:@"1" forKey:@"device_type"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_loggedoutEvent" object:nil];
                }
                else
                {
                    [appDelegate dismissGlobalHUD];
                    [self showErrorMessage:@"Server Error" withErrorContent:@""];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION FOR SIGNUP

-(void)user_signUp:(User *)objUser
{
    if ([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_Signup"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:objUser.strEmail forKey:@"email"];
        [parameters setObject:objUser.strPassword forKey:@"password"];
        [parameters setObject:objUser.strName forKey:@"name"];
        [parameters setObject:objUser.strPhoneNumber forKey:@"phone_number"];
        [parameters setObject:@"1" forKey:@"device_type"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        manager.requestSerializer.timeoutInterval = 60000;
        manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
        
        [manager POST:urlString parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            [formData appendPartWithFileData:objUser.profilePictureData name:@"user_profile_picture_data" fileName:@"profile_picture.png" mimeType:@"image/png"];
        
        } progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    if(self.objLoggedInUser == nil)
                    {
                        self.objLoggedInUser = [[User alloc] init];
                    }
                    
                    self.objLoggedInUser.strUserID = [NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"user_id"]];
                    self.objLoggedInUser.strEmail = objUser.strEmail;
                    self.objLoggedInUser.strName = objUser.strName;
                    self.objLoggedInUser.strPhoneNumber = objUser.strPhoneNumber;
                    self.objLoggedInUser.strProfilePictureImageUrl = [jsonResult objectForKey:@"profile_picture_image_url"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                    
                        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                        
                        [prefs removeObjectForKey:@"loginskipped"];
                        
                        [prefs setObject:@"1" forKey:@"autologin"];
                        [prefs setObject:self.objLoggedInUser.strUserID forKey:@"userid"];
                        [prefs setObject:self.objLoggedInUser.strEmail forKey:@"useremail"];
                        [prefs setObject:self.objLoggedInUser.strName forKey:@"username"];
                        [prefs synchronize];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"user_signedupEvent" object:nil];
                    });
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"Registration Failed" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO GET PROFILE DETAILS BY USER ID

-(void)user_getProfileDetailsByUserId:(NSString *)strUserId
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_GetProfileDetailsByUserId"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:strUserId forKey:@"user_id"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    if(self.objLoggedInUser == nil)
                    {
                        self.objLoggedInUser = [[User alloc] init];
                    }
                    
                    NSCharacterSet *set = [NSCharacterSet URLFragmentAllowedCharacterSet];
                    self.objLoggedInUser.strProfilePictureImageUrl = [[NSString stringWithFormat:@"%@", [jsonResult objectForKey:@"profile_picture_image_url"]] stringByAddingPercentEncodingWithAllowedCharacters:set];
                    self.objLoggedInUser.strName = [jsonResult objectForKey:@"name"];
                    self.objLoggedInUser.strEmail = [jsonResult objectForKey:@"email"];
                    self.objLoggedInUser.strPhoneNumber = [jsonResult objectForKey:@"phone_number"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_gotProfileDetailsByUserIdEvent" object:nil];
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"Server Error" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO UPDATE PROFILE

-(void)user_updateProfile:(NSDictionary *)dictParameters
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_UpdateProfile"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:[dictParameters objectForKey:@"user_id"] forKey:@"user_id"];
        [parameters setObject:[dictParameters objectForKey:@"name"] forKey:@"name"];
        [parameters setObject:[dictParameters objectForKey:@"phone_number"] forKey:@"phone_number"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    if(self.objLoggedInUser == nil)
                    {
                        self.objLoggedInUser = [[User alloc] init];
                    }
                    
                    self.objLoggedInUser.strName = [dictParameters objectForKey:@"name"];
                    self.objLoggedInUser.strPhoneNumber = [dictParameters objectForKey:@"phone_number"];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
                        [prefs setObject:self.objLoggedInUser.strName forKey:@"username"];
                        [prefs synchronize];
                        
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"user_updatedProfileEvent" object:nil];
                    });
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"Server Error" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION FOR FORGET PASSWORD

-(void)user_forgetPassword:(NSString *)strEmail
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
//        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_ForgetPassword"]];
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_ForgetPasswordDirectPassword"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:strEmail forKey:@"email"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
//                    [self showErrorMessage:@"Email Sent" withErrorContent:message];
                    [self showErrorMessage:@"" withErrorContent:message];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_forgetpasswordemailsentEvent" object:nil];
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO CHANGE PASSWORD

-(void)user_changePassword:(NSDictionary *)dictParameters
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_ChangePassword"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:[dictParameters objectForKey:@"user_id"] forKey:@"user_id"];
        [parameters setObject:[dictParameters objectForKey:@"strOldPassword"] forKey:@"oldpassword"];
        [parameters setObject:[dictParameters objectForKey:@"strNewPassword"] forKey:@"newpassword"];
        [parameters setObject:[dictParameters objectForKey:@"strRepeatPassword"] forKey:@"repeatpassword"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_changedPasswordEvent" object:nil];
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO CHANGE PROFILE PICTURE

-(void)user_changeProfilePicture:(NSString *)strUserId withProfilePictureData:(NSData *)profilePictureData
{
    if ([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_ChangeProfilePicture"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:strUserId forKey:@"user_id"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        manager.requestSerializer.timeoutInterval = 60000;
        manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
        
        [manager POST:urlString parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSString *strProfilePictureFileName = [NSString stringWithFormat:@"%@.png", strUserId];
            [formData appendPartWithFileData:profilePictureData name:@"user_profile_picture_data" fileName:strProfilePictureFileName mimeType:@"image/png"];
            
        } progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    if(self.objLoggedInUser == nil)
                    {
                        self.objLoggedInUser = [[User alloc] init];
                    }
                    
                    self.objLoggedInUser.strProfilePictureImageUrl = [jsonResult objectForKey:@"profile_picture_image_url"];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_changedProfilePictureEvent" object:nil];
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"Server Error" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark FUNCTION TO GET ALL PET TYPES

-(void)getAllPetTypes
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"GetAllPetTypes"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                //========== FILL PET TYPES ARRAY ==========//
                NSArray *arrayPetTypesList = [jsonResult objectForKey:@"pet_types"];
                
                self.arrayPetTypes = [[NSMutableArray alloc] init];
                
                for(int i = 0 ; i < arrayPetTypesList.count; i++)
                {
                    NSDictionary *currentDictionary = [arrayPetTypesList objectAtIndex:i];
                    
                    PetType *objPetType = [[PetType alloc] init];
                    objPetType.strPetTypeID = [currentDictionary objectForKey:@"pet_type_id"];
                    objPetType.strPetType = [currentDictionary objectForKey:@"pet_type_name"];
                    objPetType.strPetTypeDescription = [currentDictionary objectForKey:@"pet_type_description"];
                    objPetType.strPetTypePictureImageUrl = [currentDictionary objectForKey:@"pet_type_picture_image_url"];
                    objPetType.boolPetTypeIsPaid = [[currentDictionary objectForKey:@"pet_type_is_paid"] boolValue];
                    objPetType.strPetTypeInAppPurchaseProductIdentifier = [currentDictionary objectForKey:@"pet_type_in_app_purchase_product_identifier"];
                    objPetType.strPetTypeInAppPurchaseProductFlagName = [currentDictionary objectForKey:@"pet_type_in_app_purchase_product_flag_name"];
                    
                    [self.arrayPetTypes addObject:objPetType];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"gotAllPetTypesEvent" object:nil];
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark FUNCTION TO GET ALL CATEGORIES BY PET TYPE ID

-(void)getAllCategories:(NSString *)strPetTypeId
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"GetAllCategories"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:strPetTypeId forKey:@"pet_type_id"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                //========== FILL CATEGORIES ARRAY ==========//
                NSArray *arrayCategoriesList = [jsonResult objectForKey:@"categories"];
                
                self.arrayCategories = [[NSMutableArray alloc] init];
                
                for(int i = 0 ; i < arrayCategoriesList.count; i++)
                {
                    NSDictionary *currentDictionary = [arrayCategoriesList objectAtIndex:i];
                    
                    Category *objCategory = [[Category alloc] init];
                    objCategory.strCategoryId = [currentDictionary objectForKey:@"category_id"];
                    objCategory.strCategoryName = [currentDictionary objectForKey:@"category_name"];
                    objCategory.strCategoryImageUrl = [currentDictionary objectForKey:@"category_image_url"];
                    objCategory.strPetTypeID = [currentDictionary objectForKey:@"pet_type_id"];
                    
                    [self.arrayCategories addObject:objCategory];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"gotAllCategoriesEvent" object:nil];
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark FUNCTION TO GET ALL SUB CATEGORIES BY CATEGORY ID

-(void)getAllSubCategories:(NSString *)strCategoryId
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"GetAllSubCategories"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:strCategoryId forKey:@"category_id"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                //========== FILL SUBCATEGORIES ARRAY ==========//
                NSArray *arraySubCategoriesList = [jsonResult objectForKey:@"subcategories"];
                
                self.arraySubCategories = [[NSMutableArray alloc] init];
                
                for(int i = 0 ; i < arraySubCategoriesList.count; i++)
                {
                    NSDictionary *currentDictionary = [arraySubCategoriesList objectAtIndex:i];
                    
                    SubCategory *objSubCategory = [[SubCategory alloc] init];
                    objSubCategory.strSubCategoryId = [currentDictionary objectForKey:@"sub_category_id"];
                    objSubCategory.strSubCategoryName = [currentDictionary objectForKey:@"sub_category_name"];
                    objSubCategory.strSubCategoryImageUrl = [currentDictionary objectForKey:@"sub_category_image_url"];
                    objSubCategory.strCategoryId = [currentDictionary objectForKey:@"category_id"];
                    
                    [self.arraySubCategories addObject:objSubCategory];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"gotAllSubCategoriesEvent" object:nil];
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark FUNCTION TO GET ALL ADVICES BY SUB CATEGORY ID

-(void)getAllAdvices:(NSString *)strSubCategoryId
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"GetAllAdvices"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:strSubCategoryId forKey:@"subcategory_id"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                //========== FILL ADVICES ARRAY ==========//
                NSArray *arrayAdvicesList = [jsonResult objectForKey:@"advices"];
                
                self.arrayAdvices = [[NSMutableArray alloc] init];
                
                for(int i = 0 ; i < arrayAdvicesList.count; i++)
                {
                    NSDictionary *currentDictionary = [arrayAdvicesList objectAtIndex:i];
                    
                    Advice *objAdvice = [[Advice alloc] init];
                    objAdvice.strAdviceId = [currentDictionary objectForKey:@"advice_id"];
                    objAdvice.strAdviceTitle = [currentDictionary objectForKey:@"advice_title"];
                    objAdvice.strAdviceText = [currentDictionary objectForKey:@"advice_text"];
                    objAdvice.strSubCategoryId = [currentDictionary objectForKey:@"sub_category_id"];
                    
                    NSMutableArray *arrayAdviceImageUrlsTemp = [[NSMutableArray alloc] init];
                    
                    NSString *strAdviceImageUrls = [currentDictionary objectForKey:@"advice_image_urls"];
                    NSArray *arrayAdviceImageUrlsList = [strAdviceImageUrls componentsSeparatedByString:@","];
                    
                    for(int j = 0 ; j < arrayAdviceImageUrlsList.count; j++)
                    {
                        NSString *strAdviceImageUrl = [NSString stringWithFormat:@"%@%@", [_dictionaryWebservicesUrls objectForKey:@"ServerIPForAdviceImages"], [arrayAdviceImageUrlsList objectAtIndex:j]];
                        [arrayAdviceImageUrlsTemp addObject:strAdviceImageUrl];
                    }
                    
                    objAdvice.arrayAdviceImageUrls = arrayAdviceImageUrlsTemp;
                    
                    [self.arrayAdvices addObject:objAdvice];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"gotAllAdvicesEvent" object:nil];
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO GET ALL MY PETS BY USER ID

-(void)user_getAllMyPetsByUserId:(NSString *)strUserId
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_GetAllMyPets"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:strUserId forKey:@"user_id"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                //========== FILL PETS ARRAY ==========//
                NSArray *arrayMyPetsList = [jsonResult objectForKey:@"pets"];
                
                self.arrayMyPets = [[NSMutableArray alloc] init];
                
                for(int i = 0 ; i < arrayMyPetsList.count; i++)
                {
                    NSDictionary *currentDictionary = [arrayMyPetsList objectAtIndex:i];
                    
                    Pet *objPet = [[Pet alloc] init];
                    objPet.strPetID = [currentDictionary objectForKey:@"pet_id"];
                    objPet.strPetTypeID = [currentDictionary objectForKey:@"pet_type_id"];
                    objPet.strPetTypeName = [currentDictionary objectForKey:@"pet_type_name"];
                    objPet.strPetName = [currentDictionary objectForKey:@"pet_name"];
                    objPet.strPetBreed = [currentDictionary objectForKey:@"pet_breed"];
                    objPet.strPetBirthdate = [currentDictionary objectForKey:@"pet_birthdate"];
                    objPet.strPetGender = [currentDictionary objectForKey:@"pet_gender"];
                    objPet.strPetImageUrl = [currentDictionary objectForKey:@"pet_image_url"];
                    objPet.strPetUserId = [currentDictionary objectForKey:@"user_id"];
                    
                    [self.arrayMyPets addObject:objPet];
                }
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"user_gotAllMyPetsByUserIdEvent" object:nil];
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO ADD MY PET

-(void)user_addMyPet:(Pet *)objPet
{
    if ([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_AddMyPet"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:objPet.strPetTypeID forKey:@"pet_type_id"];
        [parameters setObject:objPet.strPetName forKey:@"pet_name"];
        [parameters setObject:objPet.strPetBreed forKey:@"pet_breed"];
        [parameters setObject:objPet.strPetBirthdate forKey:@"pet_birthdate"];
        [parameters setObject:objPet.strPetGender forKey:@"pet_gender"];
        [parameters setObject:objPet.strPetUserId forKey:@"user_id"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        manager.requestSerializer.timeoutInterval = 60000;
        manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
        
        [manager POST:urlString parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            [formData appendPartWithFileData:objPet.petImageData name:@"pet_image_data" fileName:@"pet_image.png" mimeType:@"image/png"];
            
        } progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_addedMyPetEvent" object:nil];
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"Server Error" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO DELETE MY PET BY USER ID AND PET ID

-(void)user_deleteMyPetByUserId:(NSString *)strUserId withPetId:(NSString *)strPetId
{
    if([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_DeleteMyPet"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:strUserId forKey:@"user_id"];
        [parameters setObject:strPetId forKey:@"pet_id"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    //========== FILL PETS ARRAY ==========//
                    NSArray *arrayMyPetsList = [jsonResult objectForKey:@"pets"];
                    
                    self.arrayMyPets = [[NSMutableArray alloc] init];
                    
                    for(int i = 0 ; i < arrayMyPetsList.count; i++)
                    {
                        NSDictionary *currentDictionary = [arrayMyPetsList objectAtIndex:i];
                        
                        Pet *objPet = [[Pet alloc] init];
                        objPet.strPetID = [currentDictionary objectForKey:@"pet_id"];
                        objPet.strPetTypeID = [currentDictionary objectForKey:@"pet_type_id"];
                        objPet.strPetTypeName = [currentDictionary objectForKey:@"pet_type_name"];
                        objPet.strPetName = [currentDictionary objectForKey:@"pet_name"];
                        objPet.strPetBreed = [currentDictionary objectForKey:@"pet_breed"];
                        objPet.strPetBirthdate = [currentDictionary objectForKey:@"pet_birthdate"];
                        objPet.strPetGender = [currentDictionary objectForKey:@"pet_gender"];
                        objPet.strPetImageUrl = [currentDictionary objectForKey:@"pet_image_url"];
                        objPet.strPetUserId = [currentDictionary objectForKey:@"user_id"];
                        
                        [self.arrayMyPets addObject:objPet];
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_deletedMyPetByUserIdEvent" object:nil];
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"Server Error" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO UPDATE MY PET

-(void)user_updateMyPet:(Pet *)objPet
{
    if ([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_UpdateMyPet"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:objPet.strPetID forKey:@"pet_id"];
        [parameters setObject:objPet.strPetTypeID forKey:@"pet_type_id"];
        [parameters setObject:objPet.strPetName forKey:@"pet_name"];
        [parameters setObject:objPet.strPetBreed forKey:@"pet_breed"];
        [parameters setObject:objPet.strPetBirthdate forKey:@"pet_birthdate"];
        [parameters setObject:objPet.strPetGender forKey:@"pet_gender"];
        [parameters setObject:objPet.strPetUserId forKey:@"user_id"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        
        [manager POST:urlString parameters:parameters headers:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_updatedMyPetEvent" object:nil];
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"Server Error" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

#pragma mark USER FUNCTION TO CHANGE PET IMAGE

-(void)user_changeMyPetImage:(NSString *)strPetId withPetImageData:(NSData *)petImageData
{
    if ([self isNetworkAvailable])
    {
        [appDelegate showGlobalProgressHUDWithTitle:@"Loading..."];
        
        NSString *urlString = [NSString stringWithFormat:@"%@%@",[_dictionaryWebservicesUrls objectForKey:@"ServerIP"],[_dictionaryWebservicesUrls objectForKey:@"User_ChangeMyPetImage"]];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        [parameters setObject:strPetId forKey:@"pet_id"];
        
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        
        manager.requestSerializer.timeoutInterval = 60000;
        manager.requestSerializer.cachePolicy = NSURLRequestReloadIgnoringLocalAndRemoteCacheData;
        
        [manager POST:urlString parameters:parameters headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
            
            NSString *strPetImageFileName = [NSString stringWithFormat:@"%@.png", strPetId];
            [formData appendPartWithFileData:petImageData name:@"pet_image_data" fileName:strPetImageFileName mimeType:@"image/png"];
            
        } progress:nil success:^(NSURLSessionDataTask *operation, id responseObject) {
            [appDelegate dismissGlobalHUD];
            
            if ([responseObject isKindOfClass:[NSArray class]]) {
                
                NSArray *responseArray = responseObject;
                
            } else if ([responseObject isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *jsonResult = responseObject;
                
                if([[jsonResult objectForKey:@"success"] integerValue] == 1)
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"user_changedMyPetImageEvent" object:nil];
                }
                else
                {
                    NSString *message = [jsonResult objectForKey:@"message"];
                    [self showErrorMessage:@"Server Error" withErrorContent:message];
                }
            }
        } failure:^(NSURLSessionTask *operation, NSError *error) {
            
            [appDelegate dismissGlobalHUD];
            [self showErrorMessage:@"Server Error" withErrorContent:@""];
            
        }];
    }
    else
    {
        [self showInternetNotConnectedError];
    }
}

@end
