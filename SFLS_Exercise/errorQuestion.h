//
//  errorQuestion.h
//  SFLS_Exercise
//
//  Created by 朱皓斌 on 12-4-1.
//  Copyright (c) 2012年 sfls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "selQuestion.h"
#import "sqlite3.h"
@interface errorQuestion : UITableViewController{
    selQuestion *errorQue;
    sqlite3 *db;
    NSString *answerSelected;
    NSIndexPath *oldIndexPath;
    UILabel *rightAnsLabel;
}
@property(nonatomic,retain)selQuestion *errorQue;
@property(nonatomic,retain)NSString *answerSelected;
@property(nonatomic,retain)NSIndexPath *oldIndexPath;
@property(nonatomic,retain)UILabel *rightAnsLabel;
@end
