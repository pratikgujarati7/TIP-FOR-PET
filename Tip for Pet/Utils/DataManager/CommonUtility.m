//
//  CommonUtility.m
//  HungerE
//
//  Created by Pratik Gujarati on 23/09/16.
//  Copyright © 2016 accereteinfotech. All rights reserved.
//

#import "CommonUtility.h"

@implementation CommonUtility

//========================= Function for Email Validation===========================================//
-(BOOL) isValidEmailAddress:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    bool result =[emailTest evaluateWithObject:checkString];
    return result;
}

-(NSString *)convertDateStringInFormatForToday:(NSString *)localDateStr
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    //formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    [formatter setDateFormat:@"MM/dd/yyyy HH:mm:ss a"];
    
//    NSString *dateString = [formatter stringFromDate:[NSDate date]];
    NSDate *date2 = [NSDate date];//[formatter dateFromString:dateString];
    
    NSDate *date1 = [formatter dateFromString:localDateStr];
    
    NSTimeInterval secondsBetween = [date2 timeIntervalSinceDate:date1];
    int mins=0,hours=0,numberOfDays=0;
    mins = secondsBetween / 60;
    if(mins >= 60){
        hours = (int)mins/60;
        mins = mins - (hours*60);
        if(hours >= 24){
            numberOfDays = (int)hours/24;
            hours = hours -(numberOfDays *24);
        }
    }
    
    formatter.doesRelativeDateFormatting = YES;
    
    if(hours < 24 && numberOfDays <= 0)
    {
        if(hours <= 1)
        {
            return [NSString stringWithFormat:@"%d hour ago",hours];
        }
        else
        {
            return [NSString stringWithFormat:@"%d hours ago",hours];
        }
    }
    
    else if(numberOfDays == 1)
    {
        return @"Yesterday";
    }
    else if(numberOfDays > 1 && numberOfDays < 7)
    {
       // formatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
        [formatter setDateFormat:@"EEEE"];
        return [formatter stringFromDate:date1];
    }
    else
    {
        NSDateFormatter *prefixDateFormatter = [[NSDateFormatter alloc] init] ;
        [prefixDateFormatter setFormatterBehavior:NSDateFormatterBehavior10_4];
        [prefixDateFormatter setDateFormat:@"MMM d"];
        NSString *prefixDateString = [prefixDateFormatter stringFromDate:date1];
        return prefixDateString;
    }
    return @"";
}

-(NSString *)getShortWeekNames:(NSString *)localDateStr
{
    NSArray *aryWeeks = [localDateStr componentsSeparatedByString:@","];
    if(aryWeeks.count > 0)
    {
        NSString *str = @"";
        for(int i=0;i<aryWeeks.count;i++)
        {
            if(i == 0)
            {
                str = [NSString stringWithFormat:@"%@",[[aryWeeks objectAtIndex:i] substringToIndex:3]];
            }
            else
            {
                str = [NSString stringWithFormat:@"%@, %@",str,[[aryWeeks objectAtIndex:i] substringToIndex:3]];
            }
        }
        return str;
    }
    else
    {
        return localDateStr;
    }
}



-(NSString *)getEncodedURLString:(NSString *)urlString
{
    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                                  NULL,
                                                                                  (CFStringRef)urlString,
                                                                                  NULL,
                                                                                  (CFStringRef)@" ",
                                                                                  kCFStringEncodingUTF8 ));
    return encodedString;
}

-(NSLocale *)getCurrentLocale
{
    NSString * deviceLanguage = [[NSLocale preferredLanguages] objectAtIndex:0];
    NSLocale * locale = [[NSLocale alloc] initWithLocaleIdentifier:deviceLanguage];
    return locale;
}

@end
