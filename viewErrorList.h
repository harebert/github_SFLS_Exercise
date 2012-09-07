//
//  viewErrorList.h
//  SFLS_Exercise
//
//  Created by 朱皓斌 on 12-4-1.
//  Copyright (c) 2012年 sfls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
@interface viewErrorList : UITableViewController{
    NSMutableArray *errorList;
    sqlite3 *db;
}
@property(nonatomic,retain)NSMutableArray *errorList;
@end
