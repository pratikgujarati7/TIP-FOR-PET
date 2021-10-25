//
//  User.m
//  ENZYM
//
//  Created by Pratik Gujarati on 24/05/17.
//  Copyright © 2017 accreteit. All rights reserved.
//

#import "User.h"

@implementation User

-(BOOL)isValidateUserForLogin
{
    CommonUtility *objUtility = [[CommonUtility alloc]init];
    
    //================BLANK FIELD VALIDATION===========//
    if(self.strEmail.length <= 0 ||  self.strPassword.length <=  0 )
    {
        if(self.strEmail.length <= 0)
        {
            self.strValidationMessage = @"Please enter email";
            return false;
        }
        else if(self.strPassword.length <= 0)
        {
            self.strValidationMessage = @"Please enter password";
            return false;
        }
    }
    else if(![objUtility isValidEmailAddress:self.strEmail])
    {
        self.strValidationMessage = @"Invalid email address";
        return false;
    }
    else
    {
        return true;
    }
    
    return true;
}

-(BOOL)isValidateUserForRegistration
{
    CommonUtility *objUtility = [[CommonUtility alloc]init];
    
    //================BLANK FIELD VALIDATION===========//
    if(self.strEmail.length <= 0 ||  self.strPassword.length <=  0 || self.strName.length <= 0 || self.strPhoneNumber.length <= 0 || (self.profilePictureData.length <= 0 && self.profilePictureData == nil))
    {
        if(self.strName.length <= 0)
        {
            self.strValidationMessage = @"Please enter your name";
            return false;
        }
        else if(self.strEmail.length <= 0)
        {
            self.strValidationMessage = @"Please enter email";
            return false;
        }
        else if(self.strPassword.length <= 0)
        {
            self.strValidationMessage = @"Please enter password";
            return false;
        }
        else if(self.strPhoneNumber.length <= 0)
        {
            self.strValidationMessage = @"Please enter your phone number";
            return false;
        }
        else if(self.profilePictureData.length <= 0 && self.profilePictureData == nil)
        {
            self.strValidationMessage = @"Please select a profile picture";
            return false;
        }
    }
    else if(![objUtility isValidEmailAddress:self.strEmail])
    {
        self.strValidationMessage = @"Please enter a valid email address";
        return false;
    }
    else
    {
        return true;
    }
    
    return true;
}

-(BOOL)isValidateUserForUpdation
{
    //================BLANK FIELD VALIDATION===========//
    if(self.strName.length <= 0 || self.strPhoneNumber.length <= 0)
    {
        if(self.strName.length <= 0)
        {
            self.strValidationMessage = @"Please enter your name";
            return false;
        }
        else if(self.strPhoneNumber.length <= 0)
        {
            self.strValidationMessage = @"Please enter your phone number";
            return false;
        }
    }
    else
    {
        return true;
    }
    
    return true;
}

@end
