//
//  selQuestion.h
//  SFLS_Exercise
//
//  Created by 皓斌 朱 on 12-2-5.
//  Copyright 2012年 sfls. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface selQuestion : NSObject{
    int questionId;
    NSString *question;
    NSString *questionType;
    NSString *answer;
    NSString *selA;
    NSString *selB;
    NSString *selC;
    NSString *selD;
    NSString *version;
    
}
@property(nonatomic,assign)int questionId;
@property(nonatomic,retain)NSString *question;
@property(nonatomic,retain)NSString *questionType;
@property(nonatomic,retain)NSString *answer;
@property(nonatomic,retain)NSString *selA;
@property(nonatomic,retain)NSString *selB;
@property(nonatomic,retain)NSString *selC;
@property(nonatomic,retain)NSString *selD;
@property(nonatomic,retain)NSString *version;
@end
