//
//  Reminder.h
//  Malabar
//
//  Created by Pratik Gujarati on 01/07/17.
//  Copyright © 2017 accreteit. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Reminder : NSObject

@property(nonatomic,retain) NSString *strReminderUniqueID;
@property(nonatomic,retain) NSString *strReminderMedicineName;
@property(nonatomic,retain) NSString *strReminderQuantity;
@property(nonatomic,retain) NSString *strReminderPetId;
@property(nonatomic,retain) NSString *strReminderPetType;
@property(nonatomic,retain) NSString *strReminderPetName;
@property(nonatomic,retain) NSString *strReminderPetImageUrl;
@property(nonatomic,retain) NSString *strReminderDateAndTime;

@end
