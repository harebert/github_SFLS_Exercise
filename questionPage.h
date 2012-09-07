//
//  questionPage.h
//  SFLS_Exercise
//
//  Created by 皓斌 朱 on 12-2-6.
//  Copyright 2012年 sfls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "sqlite3.h"
#import "selQuestion.h"
#import "XMLDocument.h"
#import "XMLelement.h"
#import "SFLS_ExerciseViewController.h"
@interface questionPage : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,XMLDocumentDelegate,UIAlertViewDelegate>{
    NSMutableArray *allQuestionsID;//选出的题目序号
    NSMutableArray *allQuestions;//数据库里所有的题目
    int page;
    XMLDocument *xmlDocument;
    sqlite3 *db;
    NSString *answerSelected;
    NSIndexPath *oldIndexPath;
    NSMutableDictionary *rightOrNot;//记录所有正确或者错误题目的错误对;结构为：questionId-YES/NO
    NSString *stu_name;
    NSString *stu_number;
    NSString *guestMode;
    UITableView *selfTableView;
    
}
@property(nonatomic,retain)NSMutableArray *allQuestionsID;
@property(nonatomic,assign)int page;
@property(nonatomic,retain)NSMutableArray *allQuestions;
@property(nonatomic,retain)NSString *answerSelected;
@property(nonatomic,retain)NSIndexPath *oldIndexPath;
@property(nonatomic,retain)NSMutableDictionary *rightOrNot;
@property(nonatomic,retain)NSString *stu_name;
@property(nonatomic,retain)NSString *stu_number;
@property(nonatomic,retain)XMLDocument *xmlDocument;
@property(nonatomic,retain)NSString *guestMode;
@property(nonatomic,retain)IBOutlet UITableView *selfTableView;
@end
