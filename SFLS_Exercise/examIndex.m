//
//  examIndex.m
//  SFLS_Exercise
//
//  Created by 皓斌 朱 on 12-2-4.
//  Copyright 2012年 sfls. All rights reserved.
//

#import "examIndex.h"
#import "selQuestion.h"
#import "questionPage.h"

@implementation examIndex
@synthesize scrollView;
@synthesize xmlDocument;
@synthesize filePath;
@synthesize allQuestions,questionId,isFinishedThread;
@synthesize stu_name,stu_number;
@synthesize activityIndicator;
@synthesize guestMode;
-(void)xmlDocumentDelegateDownloadingStarted:(XMLDocument *)paramSender{
    
}
-(IBAction)goToTest:(id)sender{
    
    NSLog(@"%i",[sender tag]);
    int questionCount;
    if ([sender tag]<6) {
        questionCount=[sender tag]*10;
    }    
    else
    {
        questionCount=allQuestions.count;
    }
    NSLog(@"all que is %i",questionCount);
    NSArray *array=[[NSArray alloc]initWithObjects:(NSString *)@"0", [NSString stringWithFormat:@"%i",allQuestions.count-1],[NSString stringWithFormat:@"%i",questionCount],nil];
    isFinishedThread=NO;
    [NSThread detachNewThreadSelector:@selector(getRandomfrom:) toTarget:self withObject:array];
    do
    {
        sleep(1);
    }
    while(!isFinishedThread);
    //NSLog(@"%@",[self.questionId componentsJoinedByString:@" and "]);
    //开始跳转题目页面
    questionPage *newQuestionPage=[[questionPage alloc]init];
    //newQuestionPage.navigationItem.backBarButtonItem .title=@"返回选题";
    newQuestionPage.guestMode=[guestMode copy];
    newQuestionPage.allQuestionsID=questionId;
    newQuestionPage.title=[NSString stringWithFormat:@"1/%i题",questionId.count];
    UIBarButtonItem *backbtn=[[UIBarButtonItem alloc] 
                              initWithTitle:@"返回重选" 
                              style:UIBarButtonItemStylePlain 
                              target:nil action:nil];
    self.navigationItem.backBarButtonItem=backbtn;
    [backbtn release];
    newQuestionPage.allQuestions=allQuestions;
    //NSLog(@"%i",allQuestions.count);
    //NSLog(@"%@，%@",[allQuestions objectAtIndex:1],[allQuestions objectAtIndex:2]);
    
    newQuestionPage.page=1;
    newQuestionPage.stu_name=stu_name;
    newQuestionPage.stu_number=stu_number;
    //newQuestionPage.navigationItem.hidesBackButton=YES;
    [self.navigationController pushViewController:newQuestionPage animated:YES];
}

-(void)xmlDocumentDelegateParsingFinished:(XMLDocument *)paramSender{
    NSMutableArray *questions=[[NSMutableArray alloc]init];
    
    XMLelement *newXmlElement=[[XMLelement alloc]init];
    XMLelement *newXmlElement2=[[XMLelement alloc]init];
    int i;
    for (i=0; i<[self.xmlDocument.rootElement.children count]; i++) {
        selQuestion *newSelQuestion=[[selQuestion alloc]init];
        newXmlElement=[self.xmlDocument.rootElement.children objectAtIndex:i];
        newXmlElement2=[newXmlElement.children objectAtIndex:0];
        newSelQuestion.questionId=[newXmlElement2.text intValue];
        newXmlElement2=[newXmlElement.children objectAtIndex:1];
        newSelQuestion.question=newXmlElement2.text;
        newXmlElement2=[newXmlElement.children objectAtIndex:2];
        newSelQuestion.questionType=newXmlElement2.text;
        newXmlElement2=[newXmlElement.children objectAtIndex:3];
        newSelQuestion.answer=newXmlElement2.text;
        newXmlElement2=[newXmlElement.children objectAtIndex:4];
        newSelQuestion.selA=newXmlElement2.text;
        newXmlElement2=[newXmlElement.children objectAtIndex:5];
        newSelQuestion.selB=newXmlElement2.text;
        newXmlElement2=[newXmlElement.children objectAtIndex:6];
        newSelQuestion.selC=newXmlElement2.text;
        newXmlElement2=[newXmlElement.children objectAtIndex:7];
        newSelQuestion.selD=newXmlElement2.text;
        newXmlElement2=[newXmlElement.children objectAtIndex:8];
        newSelQuestion.version=newXmlElement2.text;
        
        [questions addObject:newSelQuestion];
        [newSelQuestion release];
                
    }
    //NSLog(@"%i",questions.count);
    //接下来是sqlite的操作
    //找到应用程序沙箱内的 数据库路径
    filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"database.sqlite"];
    //NSLog(@"%@",filePath);

    NSLog(@"%@",filePath);
    if (sqlite3_open([filePath UTF8String], &db)!=SQLITE_OK) {//打开数据库失败
        NSLog(@"database error");
    }
    
    
    else{//打开数据库成功
        char *errorMsg;
        NSString *creatSQL=@"CREATE TABLE IF NOT EXISTS 'appTestDB'('questionId' INTEGER primary key,'question' TEXT,'questionType' TEXT,'answer' TEXT,'selA' TEXT,'selB' TEXT,'selC' TEXT,'selD' TEXT,'version' TEXT,'errorTimes' INTEGER DEFAULT 0)";
        if (sqlite3_exec(db,[creatSQL UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK)
        {
            //打开表、创建表失败
        }
        else
        {//打开表成功，写入数据库；
            int i;
            NSString *insertRecord;
            for (i=0; i<questions.count; i++) 
            {
            selQuestion *newQuestionforDB=[questions objectAtIndex:i];
            insertRecord=[NSString stringWithFormat: @"INSERT OR REPLACE INTO 'appTestDB' ('questionId','question','questionType','answer','selA','selB','selC','selD','version') VALUES(%i,'%@','%@','%@','%@','%@','%@','%@','%@')",newQuestionforDB.questionId,newQuestionforDB.question,newQuestionforDB.questionType,newQuestionforDB.answer,newQuestionforDB.selA,newQuestionforDB.selB,newQuestionforDB.selC,newQuestionforDB.selD,newQuestionforDB.version];
                sqlite3_exec(db, [insertRecord UTF8String], NULL, NULL, &errorMsg);
                //[insertRecord release];
                //[newQuestionforDB release];                
            }
        }
        }
    allQuestions=questions;
    //NSLog(@"%@",[allQuestions componentsJoinedByString:@"|"]);
    int Margin=0;
    if ([guestMode isEqualToString:@"YES"]) {
        NSLog(@"now%@",guestMode);
        UILabel *guestLabel=[[UILabel alloc]init];
        guestLabel.text=@"你现在正处于游客模式\n该模式不记录成绩但显示答案。";
        guestLabel.frame=CGRectMake(20, 44, 280, 60);
        guestLabel.numberOfLines=3;
        guestLabel.textColor=[UIColor blackColor];
        guestLabel.backgroundColor=[UIColor clearColor];
        guestLabel.textAlignment=UITextAlignmentCenter;
        [self.scrollView addSubview:guestLabel];
        Margin=30;
    }

    for (i=1; i<=4; i++) {
        UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame=CGRectMake(40, i*(25+50)+Margin, 240, 50);
        [button setTitle:[NSString stringWithFormat:@"先做%i题练练手",i*10] forState:UIControlStateNormal];
        [button setTag:i];
        [button addTarget:self action:@selector(goToTest:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        
    }
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(40, 6*(25+50)+Margin, 240, 50);
    [button setTitle:[NSString stringWithFormat:@"做全部的%i题",[self.allQuestions count]] forState:UIControlStateNormal];
    [button setTag:6];
    [button addTarget:self action:@selector(goToTest:) forControlEvents:UIControlEventTouchUpInside];
    [self.scrollView addSubview:button];
    scrollView.frame=CGRectMake(0, 0, 320, 480);
    [scrollView setScrollEnabled:YES];
    [scrollView setContentSize:CGSizeMake(320, 600)];
    [scrollView setPagingEnabled:NO];
    
    [self.view addSubview:scrollView];
    //[self.view reloadInputViews];
   }
-(void)xmlDocumentDelegateParsingFailed:(XMLDocument *)paramSender withError:(NSError *)paramError{
    NSLog(@"Parse xml failed");
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad

{   
    self.navigationController.navigationBarHidden=NO;
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"questionListBAK@1x.png"]];
    self.scrollView.backgroundColor=[UIColor clearColor];
    //NSLog(@"%@",guestMode);
    if ([self.guestMode isEqualToString:@"YES"]) {
        //guestMode=YES;
        NSLog(@"%@",guestMode);
    }
    filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"database.sqlite"];
    sqlite3_open( [filePath UTF8String],&db);
    NSString * searchString=@"select * from appTestDB";
    sqlite3_stmt *statement;
    sqlite3_prepare_v2(db, [searchString UTF8String], -1, &statement, nil);
    if (sqlite3_step(statement)==SQLITE_ROW) {
        NSLog(@"有数据");
        NSMutableArray *newMutableArray=[[NSMutableArray alloc]initWithObjects:nil, nil];
        allQuestions=newMutableArray;
        
        while (sqlite3_step(statement)==SQLITE_ROW) {
            selQuestion *newQuestionforDB=[[selQuestion alloc]init];
            newQuestionforDB.questionId= sqlite3_column_int(statement, 0);
            newQuestionforDB.question= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 1)];
            newQuestionforDB.questionType= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 2)];
             newQuestionforDB.answer= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 3)];
            newQuestionforDB.selA= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 4)];
            newQuestionforDB.selB= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 5)];
            newQuestionforDB.selC= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement,6)];
            newQuestionforDB.selD= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 7)];
            newQuestionforDB.version= [NSString stringWithUTF8String:(char *)sqlite3_column_text(statement, 8)];
            //NSLog(@"第%i题,题目：%@,题型：%@，答案：%@，选项A:%@,B:%@,C:%@,D:%@,版本：%@",newQuestionforDB.questionId,newQuestionforDB.question,newQuestionforDB.questionType,newQuestionforDB.answer,newQuestionforDB.selA,newQuestionforDB.selB,newQuestionforDB.selC,newQuestionforDB.selD,newQuestionforDB.version);
            [allQuestions addObject:newQuestionforDB];
            //selQuestion *newnewQuew=[allQuestions objectAtIndex:0];
            //NSLog(@"%@",newnewQuew.question);
            //[newQuestionforDB release];
            //NSLog(@"%i",allQuestions.count);
            [newQuestionforDB release];
        }
        int i;
        int Margin=0;
        if ([guestMode isEqualToString:@"YES"]) {
            NSLog(@"now%@",guestMode);
            UILabel *guestLabel=[[UILabel alloc]init];
            guestLabel.text=@"你现在正处于游客模式\n该模式不记录成绩但显示答案。";
            guestLabel.frame=CGRectMake(20, 44, 280, 60);
            guestLabel.numberOfLines=3;
            guestLabel.textColor=[UIColor blackColor];
            guestLabel.backgroundColor=[UIColor clearColor];
            guestLabel.textAlignment=UITextAlignmentCenter;
            [self.scrollView addSubview:guestLabel];
            Margin=30;
        }
        for (i=1; i<=6  ; i++) {
            UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            button.frame=CGRectMake(40, i*(25+50)+Margin, 240, 50);
            [button setTitle:[NSString stringWithFormat:@"先做%i题练练手",i*10] forState:UIControlStateNormal];
            [button setTag:i];
            [button addTarget:self action:@selector(goToTest:) forControlEvents:UIControlEventTouchUpInside];
            [self.scrollView addSubview:button];
            
        }
        UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame=CGRectMake(40, 6*(25+50)+Margin, 240, 50);
        [button setTitle:[NSString stringWithFormat:@"做全部的%i题",[self.allQuestions count]] forState:UIControlStateNormal];
        [button setTag:6];
        [button addTarget:self action:@selector(goToTest:) forControlEvents:UIControlEventTouchUpInside];
        [self.scrollView addSubview:button];
        
        

        scrollView.frame=CGRectMake(0, 0, 320, 480);
        [scrollView setScrollEnabled:YES];
        [scrollView setContentSize:CGSizeMake(320, 600)];
        [scrollView setPagingEnabled:NO];

        [self.view addSubview:scrollView];
        //NSLog(@"%@",guestMode);
            }
    else{
        NSLog(@"无数据");
        NSString *xmlPath=[NSString stringWithFormat: @"http://teacher.sfls.cn/sflsapp/exercise/creatquestion.asp"];
        XMLDocument *newDocument=[[XMLDocument alloc]initWithDelegate:self];
        self.xmlDocument=newDocument;
        [newDocument release];
        [self.xmlDocument parseRemoteXMLWithURL:xmlPath];
    }
        
    
    self.navigationItem.hidesBackButton=YES;
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [scrollView release];
    [super dealloc];
}
-(NSMutableArray *)getRandomfrom:(NSArray *)data{//选择由0到number-1并找到对应编号的题目在allquestion中的编号
    
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
    NSMutableArray *result=[[NSMutableArray alloc] init];
    int i,j,ra,to,number,from;
    from=[[data objectAtIndex:0]intValue];
    to=[[data objectAtIndex:1]intValue];
    number=[[data objectAtIndex:2]intValue];
    if (number<allQuestions.count) {
      
    BOOL flag;//找到yes找不到no
    //flag=NO;
    
        
    for (i=0; i<=number+1; i++) {
        flag=NO;
        
        ra=(rand()%to);
        //NSLog(@"第%i次，选出的随机数：%i",i,ra);
        if (i>1) {
            for (j=0; j<result.count; j++) {
                if (ra==[[result objectAtIndex:j]intValue]) {
                    flag=YES;
                }
            }
            if (flag==YES) {
                i=i-1;
            }
            else
            {
                [result addObject:[NSString stringWithFormat:@"%i",ra] ];
                //NSLog(@"第%i个随机数是%i",i,ra);
            }
        }
    }
    self.questionId=[[NSMutableArray alloc]init];
    /*
    
    for (i=0; i<result.count; i++) {
        selQuestion *newSelQuestion=[[selQuestion alloc]init];
        newSelQuestion=[allQuestions objectAtIndex:[[result objectAtIndex:i]intValue]];
        [self.questionId addObject:[NSString stringWithFormat:@"%i", newSelQuestion.questionId]];
        [newSelQuestion release];
    }
    NSLog(@"%@",[self.questionId componentsJoinedByString:@" AND "]);
    //self.questionId=result;
    */
    isFinishedThread=YES;
    self.questionId=result;
    return self.questionId;
    }
    else{
        self.questionId=[[NSMutableArray alloc]init];
        for (i=0; i<allQuestions.count; i++) {
            [self.questionId addObject:[NSString stringWithFormat:@"%i",i]];
        }
        isFinishedThread=YES;
        return self.questionId;
    }
    
    
    
    [pool release];
}

@end
