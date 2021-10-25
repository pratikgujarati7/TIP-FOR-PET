//
//  Advice.h
//  Tip for Pet
//
//  Created by Pratik Gujarati on 28/07/17.
//  Copyright © 2017 innovativeiteration. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Advice : NSObject

@property(nonatomic,retain) NSString *strAdviceId;
@property(nonatomic,retain) NSString *strAdviceTitle;
@property(nonatomic,retain) NSString *strAdviceText;
@property(nonatomic,retain) NSString *strSubCategoryId;

@property(nonatomic,retain) NSMutableArray *arrayAdviceImageUrls;

@end
