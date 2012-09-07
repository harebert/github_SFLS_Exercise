//
//  SFLS_ExerciseViewController.m
//  SFLS_Exercise
//
//  Created by 皓斌 朱 on 12-2-4.
//  Copyright 2012年 sfls. All rights reserved.
//

#import "SFLS_ExerciseViewController.h"
#import "examIndex.h"
#import "selQuestion.h"
#import "viewErrorList.h"
@implementation SFLS_ExerciseViewController
@synthesize name;
@synthesize pwd;
@synthesize xmlElement,xmlDocument;
@synthesize theServerAddress;
@synthesize guestMode;
@synthesize errorArray;

@synthesize activityIndicator;
#pragma theXmlParser
-(void)xmlDocumentDelegateDownloadingStarted:(XMLDocument *)paramSender{
  activityIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicator.frame=CGRectMake(142, 222, 36, 36);
    [activityIndicator startAnimating];
    [self.view addSubview:activityIndicator];
    NSLog(@"started");

}
-(void)xmlDocumentDelegateParsingFinished:(XMLDocument *)paramSender{
    XMLelement *success=[xmlDocument.rootElement.children objectAtIndex:0];
    
    
    if ([success.text isEqualToString:@"YES"]) {
        XMLelement *usernumber=[xmlDocument.rootElement.children objectAtIndex:1];
        XMLelement *username=[xmlDocument.rootElement.children objectAtIndex:2];
        
        //NSString *info=[NSString stringWithFormat:@"欢迎回来\n学号：%@\n姓名：%@",usernumber.text,username.text];
        //UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"登录成功" message:info delegate:self cancelButtonTitle:@"开始做题" otherButtonTitles:nil, nil];
        //[alert show];
        examIndex *newExamIndex=[[examIndex alloc]init];
        newExamIndex.stu_number=usernumber.text;
        newExamIndex.stu_name=username.text;
        newExamIndex.title=[NSString stringWithFormat:@"欢迎回来 %@ %@",usernumber.text,username.text];
        [self.navigationController pushViewController:newExamIndex animated:YES];
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"登录失败" message:@"用户姓名或者密码不正确\n请重新登录" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        alert.tag=2;
        [alert show];
    }
}
-(void)xmlDocumentDelegateParsingFailed:(XMLDocument *)paramSender withError:(NSError *)paramError{
    NSLog(@"Parse xml failed");
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    self.view.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"loginbak@1x.png"]];
    self.navigationController.navigationBarHidden=YES;
    //评分系统
    NSString *rateFilePath;
    char *errorMsg;
    rateFilePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"rate.sqlite"];
    NSLog(@"%@",rateFilePath);
    sqlite3_open( [rateFilePath UTF8String],&db);
    NSString * isFirst=@"select * from rateDB";
    sqlite3_stmt *isFirststatement;
    sqlite3_prepare_v2(db, [isFirst UTF8String], -1, &isFirststatement, nil);
    if (sqlite3_step(isFirststatement)==SQLITE_ROW) {
        int times;
        times= sqlite3_column_int(isFirststatement, 1);
        if (times==5) {
            NSLog(@"5 times");
            UIAlertView *rateAlertView=[[UIAlertView alloc]initWithTitle:@"请对APP评分" message:@"您已经使用本APP一段时间了，感谢您的支持的同时，如果支持此APP的发展，请拨冗前往进行评分" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"去评分", nil];
            rateAlertView.tag=2;
            [rateAlertView show];
            NSString *addTimes=[NSString stringWithFormat: @"update rateDB set loginTimes=loginTimes+1 where rateId=1"];
            sqlite3_exec(db, [addTimes UTF8String], NULL, NULL, &errorMsg);
        }else{
            NSString *addTimes=[NSString stringWithFormat: @"update rateDB set loginTimes=loginTimes+1 where rateId=1"];
            sqlite3_exec(db, [addTimes UTF8String], NULL, NULL, &errorMsg);
        }
        //NSString *insertRecord=[NSString stringWithFormat: @"INSERT OR REPLACE INTO 'rateDB' ('rateId','loginTimes') VALUES(1,1)"];
        //sqlite3_exec(db, [insertRecord UTF8String], NULL, NULL, &errorMsg);
    }
    else{
        
        if (sqlite3_open([rateFilePath UTF8String], &db)!=SQLITE_OK) {//打开数据库失败
        NSLog(@"database error");
    }
    
    
    else{//打开数据库成功
        
        NSString *creatSQL=@"CREATE TABLE IF NOT EXISTS 'rateDB'('rateID' INTEGER primary key,'loginTimes' INTEGER DEFAULT 1)";
        if (sqlite3_exec(db,[creatSQL UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK)
        {
            //打开表、创建表失败
        }
        else
        {//打开表成功，写入数据库；
           NSString *insertRecord=[NSString stringWithFormat: @"INSERT OR REPLACE INTO 'rateDB' ('rateId','loginTimes') VALUES(1,1)"];
            sqlite3_exec(db, [insertRecord UTF8String], NULL, NULL, &errorMsg);   
        }
    }
    }
    //评分系统
    
    name.delegate=self;
    pwd.delegate=self;
    [super viewDidLoad];
    NSString *filePath;
    filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"database.sqlite"];
    sqlite3_open( [filePath UTF8String],&db);
    NSString * searchString=@"select * from appTestDB where errortimes>0";
    sqlite3_stmt *statement;
    sqlite3_prepare_v2(db, [searchString UTF8String], -1, &statement, nil);
    //if (sqlite3_step(statement)==SQLITE_ROW) {
        
        
        NSMutableArray *newMutableArray=[[NSMutableArray alloc]initWithObjects:nil, nil];
        //allQuestions=newMutableArray;
        
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
            [newMutableArray addObject:newQuestionforDB];
            //selQuestion *newnewQuew=[allQuestions objectAtIndex:0];
            //NSLog(@"%@",newnewQuew.question);
            //[newQuestionforDB release];
            //NSLog(@"%i",allQuestions.count);
            [newQuestionforDB release];
        }
    errorArray=[newMutableArray copy];
    UIButton *reViewBTN=[UIButton buttonWithType:UIButtonTypeCustom];
    //NSLog(@"%i",[newMutableArray count]);
    //reViewBTN.titleLabel.text=[NSString stringWithFormat:@"查看错题集(%i题)",[newMutableArray count]];
    //[reViewBTN setTitle:[NSString stringWithFormat:@"查看错题集(%i题)",[newMutableArray count]] forState:UIControlStateNormal];
    [reViewBTN setTitle:@"查看错题集" forState:UIControlStateNormal];
    reViewBTN.tintColor=[UIColor blackColor];
    reViewBTN.frame=CGRectMake(92, 217, 163, 37);
    reViewBTN.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"wrongbutton.png"]];
    [reViewBTN addTarget:self action:(@selector(viewError:)) forControlEvents:UIControlEventTouchUpInside];
        if ([newMutableArray count]>0) {//如果有错题则显示
            [self.view addSubview:reViewBTN];
        }
    }
//}


- (void)viewDidUnload
{
    
    [self setName:nil];
    [self setPwd:nil];
    //[self setGuest:nil];
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
    [name release];
    [pwd release];
    
    [super dealloc];
}
- (IBAction)login:(id)sender {
    if ([name.text isEqualToString:@""]||[pwd.text isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"填写错误" message:@"用户名或密码不能为空" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
        alert.tag=1;
        [alert show];
        return;
    }
    NSString *xmlPath=[NSString stringWithFormat: @"http://teacher.sfls.cn/sflsapp/exercise/createxercise.asp?login=1&name=%@&pwd=%@",name.text,pwd.text];
    XMLDocument *newDocument=[[XMLDocument alloc]initWithDelegate:self];
    self.xmlDocument=newDocument;
    [newDocument release];
    [self.xmlDocument parseRemoteXMLWithURL:xmlPath];
}

- (IBAction)bgClick:(id)sender {
    [name resignFirstResponder];
    [pwd resignFirstResponder];
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField

{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)Guest:(id)sender {
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"游客码" message:@"游客模式需要输入密码1。可以不登录服务器做题2。可以实时显示答案" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
    [alert setAlertViewStyle:UIAlertViewStyleSecureTextInput];
    alert.tag=0;
    
    [alert show];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSLog(@"login guest mode");
    if (alertView.tag==0) {
        NSLog(@"login guest mode");
        UITextField *password=[alertView textFieldAtIndex:0];
        if (buttonIndex==1) {
            
        
            if ([password.text isEqualToString:@"Hello"]) {
                self.guestMode=YES;
                NSLog(@"login guest mode ok");
                
                examIndex *newExamIndex=[[examIndex alloc]init];
                newExamIndex.stu_number=@"Guest Mode";
                newExamIndex.stu_name=@"Guest Mode";
                newExamIndex.title=[NSString stringWithFormat:@"游客模式"];
                newExamIndex.guestMode=@"YES";
                [self.navigationController pushViewController:newExamIndex animated:YES];
                
                }
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"游客密码错误" message:@"请重新输入或者直接登录" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            alert.tag=3;
            [alert show];
        }
    }
    if (alertView.tag==2) {
        if (buttonIndex==1) {
            NSLog(@"go to rate");
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/app/sandman/id520816917?mt=8&uo=4"]];
        }
    }
}

-(void)alertViewCancel:(UIAlertView *)alertView{
    NSLog(@"login guest mode");
    if (alertView.tag==0) {
        NSLog(@"login guest mode");
        UITextField *password=[alertView textFieldAtIndex:0];
        if ([password.text isEqualToString:@"Hello"]) {
            self.guestMode=YES;
            NSLog(@"login guest mode ok");
        }
        else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"游客密码错误" message:@"请重新输入或者直接登录" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:nil, nil];
            [alert show];
        }
    }
}
-(IBAction)viewError:(id)sender{
    viewErrorList *newViewErrorList=[[viewErrorList alloc]init];
    newViewErrorList.errorList=errorArray;
    newViewErrorList.navigationItem.leftBarButtonItem.title=@"返回登录";
    newViewErrorList.title=[NSString stringWithFormat: @"错题集 -(%d题)",[errorArray count]];
    [self.navigationController pushViewController:newViewErrorList animated:YES];  
}
#pragma alertView

@end
