//
//  CommonUtility.h
//  HungerE
//
//  Created by Pratik Gujarati on 23/09/16.
//  Copyright © 2016 accereteinfotech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CommonUtility : NSObject

-(BOOL) isValidEmailAddress:(NSString *)checkString;
-(NSString *)convertDateStringInFormatForToday:(NSString *)localDateStr;
-(NSString *)getShortWeekNames:(NSString *)localDateStr;
-(NSString *)getEncodedURLString:(NSString *)urlString;
-(NSLocale *)getCurrentLocale;

@end
