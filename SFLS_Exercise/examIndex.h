//
//  examIndex.h
//  SFLS_Exercise
//
//  Created by 皓斌 朱 on 12-2-4.
//  Copyright 2012年 sfls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLelement.h"
#import "XMLDocument.h"
#import "sqlite3.h"

@interface examIndex : UIViewController<XMLDocumentDelegate>{
   XMLDocument *xmlDocument; 
    NSString *stu_name;
    NSString *stu_number;
    sqlite3 *db;
    NSString *filePath;
    NSMutableArray *allQuestions;
    UIScrollView *scrollView;
    NSMutableArray *questionId;//选择的题目数在allquestion中的编号
    BOOL isFinishedThread;
    UIActivityIndicatorView *activityIndicator;
    NSString *guestMode;
}
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property(nonatomic,retain)XMLDocument *xmlDocument;
@property(nonatomic,retain)NSString *filePath;
@property(nonatomic,retain)NSMutableArray *allQuestions;
@property(nonatomic,retain)NSMutableArray *questionId;
@property(nonatomic,assign) BOOL isFinishedThread;
-(NSMutableArray *)getRandomfrom:(NSArray *)data;
@property(nonatomic,retain)NSString *stu_name;
@property(nonatomic,retain)NSString *stu_number;
@property(nonatomic,retain)NSString *guestMode;
-(IBAction)goToTest:(id)sender;
@property(nonatomic,retain)IBOutlet UIActivityIndicatorView *activityIndicator;

@end
