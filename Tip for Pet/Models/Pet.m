//
//  Pet.m
//  Tip for Pet
//
//  Created by Pratik Gujarati on 01/08/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import "Pet.h"

@implementation Pet

-(BOOL)isValidatePetToAdd
{    
    //================BLANK FIELD VALIDATION===========//
    if(self.strPetName.length <=  0 || self.strPetTypeID.length <= 0 ||  self.strPetBreed.length <= 0 || self.strPetBirthdate.length <= 0  || self.strPetGender.length <= 0 || (self.petImageData.length <= 0 && self.petImageData == nil))
    {
        if(self.strPetName.length <= 0)
        {
            self.strValidationMessage = @"Please enter your pet's name";
            return false;
        }
        else if(self.strPetTypeID.length <= 0)
        {
            self.strValidationMessage = @"Please select your pet type";
            return false;
        }
        else if(self.strPetBreed.length <= 0)
        {
            self.strValidationMessage = @"Please enter your pet's breed";
            return false;
        }
        else if(self.strPetBirthdate.length <= 0)
        {
            self.strValidationMessage = @"Please select your pet's birthdate";
            return false;
        }
        else if(self.strPetGender.length <= 0)
        {
            self.strValidationMessage = @"Please select your pet's gender";
            return false;
        }
        else if(self.petImageData.length <= 0 && self.petImageData == nil)
        {
            self.strValidationMessage = @"Please select a picture of your pet";
            return false;
        }
    }
    else
    {
        return true;
    }
    
    return true;
}

-(BOOL)isValidatePetToUpdate
{
    //================BLANK FIELD VALIDATION===========//
    if(self.strPetName.length <=  0 || self.strPetTypeID.length <= 0 ||  self.strPetBreed.length <= 0 || self.strPetBirthdate.length <= 0  || self.strPetGender.length <= 0)
    {
        if(self.strPetName.length <= 0)
        {
            self.strValidationMessage = @"Please enter your pet's name";
            return false;
        }
        else if(self.strPetTypeID.length <= 0)
        {
            self.strValidationMessage = @"Please select your pet type";
            return false;
        }
        else if(self.strPetBreed.length <= 0)
        {
            self.strValidationMessage = @"Please enter your pet's breed";
            return false;
        }
        else if(self.strPetBirthdate.length <= 0)
        {
            self.strValidationMessage = @"Please select your pet's birthdate";
            return false;
        }
        else if(self.strPetGender.length <= 0)
        {
            self.strValidationMessage = @"Please select your pet's gender";
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
