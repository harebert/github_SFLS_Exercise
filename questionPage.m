//
//  questionPage.m
//  SFLS_Exercise
//
//  Created by 皓斌 朱 on 12-2-6.
//  Copyright 2012年 sfls. All rights reserved.
//

#import "questionPage.h"
#import "SFLS_ExerciseViewController.h"
@implementation questionPage

@synthesize selfTableView,allQuestionsID,page,allQuestions,answerSelected,oldIndexPath;
@synthesize rightOrNot;
@synthesize stu_name,stu_number;
@synthesize xmlDocument;
@synthesize guestMode;
-(void)xmlDocumentDelegateDownloadingStarted:(XMLDocument *)paramSender{
    
}
-(void)xmlDocumentDelegateParsingFinished:(XMLDocument *)paramSender{
    XMLelement *newElement=[self.xmlDocument.rootElement.children objectAtIndex:0];
    XMLelement *newElement1=[self.xmlDocument.rootElement.children objectAtIndex:1];
    int rate=[newElement1.text floatValue]*100;
    NSString *showRate=[NSString stringWithFormat:@"本次答题的正确率为：%i%%",rate];
    if ([newElement.text isEqualToString:@"OK"]) {
        UIAlertView *allert=[[UIAlertView alloc]initWithTitle:@"网络递交成功" message:showRate delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [allert show];
        SFLS_ExerciseViewController *newSFLSexercise=[[SFLS_ExerciseViewController alloc]init];
        newSFLSexercise.navigationItem.hidesBackButton=YES;
        [self.navigationController pushViewController:newSFLSexercise animated:NO];    
    }
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
    self.view.backgroundColor=[UIColor groupTableViewBackgroundColor];
    if (page==1) {
        rightOrNot=[[NSMutableDictionary alloc]init];
    }
    answerSelected=[[NSString alloc]init];
    //UITableViewController *newTableView=[[UITableViewController alloc]initWithStyle:UITableViewStyleGrouped];
    UITableView *newTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
    [newTableview setDelegate:self];
    [newTableview setDataSource:self];
    selfTableView=newTableview;
    if (page<allQuestionsID.count) {
        UIBarButtonItem *submitButton=[[UIBarButtonItem alloc] 
                                       initWithTitle:@"下一题" 
                                       style:UIBarButtonItemStylePlain 
                                       target:self action:@selector(nextPage:)];
        submitButton.tag=0;
        self.navigationItem.rightBarButtonItem=submitButton;
    }
    else{
        UIBarButtonItem *submitButton=[[UIBarButtonItem alloc] 
                                       initWithTitle:@"完成" 
                                       style:UIBarButtonItemStylePlain 
                                       target:self action:@selector(nextPage:)];
        submitButton.tag=1;
        self.navigationItem.rightBarButtonItem=submitButton;

    }
   

    
   
    [self.view addSubview:newTableview];
  
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(int)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 4;
}
-(int)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    selQuestion *newSelQuestion=[[selQuestion alloc]init];
    newSelQuestion=[allQuestions objectAtIndex:[[allQuestionsID objectAtIndex:page-1]intValue]];
    //[cell.textLabel setNumberOfLines:2];
    switch ([indexPath row]) {
        case 0:
            [cell.textLabel setNumberOfLines:([newSelQuestion.selA length]+20)/17 ];
            cell.textLabel.text=newSelQuestion.selA;
            break;
        case 1:
            [cell.textLabel setNumberOfLines:([newSelQuestion.selB length]+20)/17 ];
            cell.textLabel.text=newSelQuestion.selB;
            break;
        case 2:
            [cell.textLabel setNumberOfLines:([newSelQuestion.selC length]+20)/17 ];
            cell.textLabel.text=newSelQuestion.selC;
            break;
        case 3:
            [cell.textLabel setNumberOfLines:([newSelQuestion.selD length]+20)/17 ];
            cell.textLabel.text=newSelQuestion.selD;
            break;
            
        default:
            break;
    }
    //cell.textLabel.text=[allQuestionsID objectAtIndex:[indexPath row]];
    // Configure the cell...
    //[newSelQuestion release];
    return cell;

}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    selQuestion *newlySelQuestion=[[selQuestion alloc]init];
    newlySelQuestion=[allQuestions objectAtIndex:[[allQuestionsID objectAtIndex:(page-1)]intValue]];
    return newlySelQuestion.question;
    [newlySelQuestion release];
}
-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    selQuestion *newlySelQuestion=[[selQuestion alloc]init];
    newlySelQuestion=[allQuestions objectAtIndex:[[allQuestionsID objectAtIndex:page-1]intValue]];
    
    return [NSString stringWithFormat:@"本习题版本：%@",newlySelQuestion.version];
    [newlySelQuestion release];
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    selQuestion *newlySelQuestion=[[selQuestion alloc]init];
    newlySelQuestion=[allQuestions objectAtIndex:[[allQuestionsID objectAtIndex:page-1]intValue]];
    //NSLog(@"此题长度：%i",[newlySelQuestion.question length]);
    return ([newlySelQuestion.question length]+17)/17*30;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *newCell=[[[UITableViewCell alloc]init]retain];
    newCell=[tableView cellForRowAtIndexPath:indexPath];

    if (oldIndexPath!=indexPath) 
    {
       switch ([indexPath row]) 
        {
            case 0:
            answerSelected=@"A";
            break;
            case 1:
            answerSelected=@"B";
            break;
            case 2:
            answerSelected=@"C";
            break;
            case 3:
            answerSelected=@"D";
            break;
            default:
            break;        
        }
        if (oldIndexPath) 
        {
            NSLog(@"2.the new one is %@, the old one is %@",oldIndexPath,indexPath);
            UITableViewCell *oldCell=[[[UITableViewCell alloc]init]retain];
            oldCell=[tableView cellForRowAtIndexPath:oldIndexPath];
            oldCell.accessoryType=UITableViewCellAccessoryNone;
        }
        oldIndexPath=[indexPath copy];
        NSLog(@"the new one is %@, the old one is %@",oldIndexPath,indexPath);
        newCell.accessoryType=UITableViewCellAccessoryCheckmark;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        
    }
        else
    {
        newCell.accessoryType=UITableViewCellAccessoryNone;
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    NSString *isRight=[[NSString alloc]init];
    selQuestion *newSelQueston=[[selQuestion alloc]init];
    newSelQueston=[allQuestions objectAtIndex:[[allQuestionsID objectAtIndex:page-1]intValue]];
    
    if ([newSelQueston.answer isEqualToString:answerSelected]) {
        isRight=@"YES";
        [rightOrNot setObject:isRight forKey:[NSString stringWithFormat:@"%i", newSelQueston.questionId]];
    }
    else
    {
        isRight=@"NO";
        [rightOrNot setObject:isRight forKey:[NSString stringWithFormat:@"%i", newSelQueston.questionId]];
    }
    
    NSLog(@"是否正确,%@,正确答案是%@,记录在案的答案是%@",isRight,newSelQueston.answer,[rightOrNot objectForKey:[NSString stringWithFormat:@"%i", newSelQueston.questionId]]); 
    if ([guestMode isEqualToString:@"YES"]) {
        UILabel *newLabel=[[UILabel alloc]init];
        newLabel.text=[NSString stringWithFormat:@"本题答案：%@,正确答案是%@,记录在案的答案是%@",isRight,newSelQueston.answer,[rightOrNot objectForKey:[NSString stringWithFormat:@"%i", newSelQueston.questionId]]];
        newLabel.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [newLabel setLineBreakMode:UILineBreakModeTailTruncation];
        newLabel.numberOfLines=2;
        newLabel.frame=CGRectMake(20, -50, 280, 50);
        [self.view addSubview:newLabel];
        CGContextRef context = UIGraphicsGetCurrentContext();   
        [UIView beginAnimations:@"Curl" context:context];   
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];   
        [UIView setAnimationDuration:0.5]; 
        selfTableView.frame=CGRectMake(0, 50, 320, 450);
        newLabel.frame=CGRectMake(20, 0, 280, 50);
        [UIView commitAnimations];
    }
}
-(IBAction)nextPage:(id)sender{
    if ([self.answerSelected isEqualToString:@""]) {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"请做选择" message:@"不可以不选择任何选项\n如果该题不会\n 1.请课前预习\n2.请上课认真听讲\n3.课后请自行Google或者百度" delegate:self cancelButtonTitle:@"返回选择" otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
    if ([sender tag]==0) {
                      
        questionPage *nextPage=[[questionPage alloc]init];
        nextPage.page=page+1;
        nextPage.title=[NSString stringWithFormat:@"%i/%i题",page+1,allQuestionsID.count];
        nextPage.allQuestions=allQuestions;
        nextPage.allQuestionsID=allQuestionsID;
        nextPage.rightOrNot=rightOrNot;
        nextPage.stu_number=stu_number;
        nextPage.stu_name=stu_name;
        nextPage.guestMode=[guestMode copy];
        [self.navigationController pushViewController:nextPage animated:YES];        
    }
    else
    {   
        if ([guestMode isEqualToString:@"YES"]) {
            SFLS_ExerciseViewController *newIndex=[[SFLS_ExerciseViewController alloc]init];
            newIndex.navigationItem.hidesBackButton=YES;
            [self.navigationController pushViewController:newIndex animated:NO];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"完成所有习题" message:@"完成所有习题，将退出游客模式" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }
        else{
            
        
        UIActionSheet *submitExercise=[[UIActionSheet alloc]initWithTitle:@"提交测试结果" delegate:self cancelButtonTitle:@"取消递交" destructiveButtonTitle:nil otherButtonTitles:@"本地递交",@"网络递交", nil];
        [submitExercise showInView:self.view];
        [submitExercise release];
            }
    }
    }
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    NSString *filePath=[[NSString alloc]init];
    filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"database.sqlite"];
        //本地为0，网络为1
    //NSLog(@"%i",buttonIndex);
    if (buttonIndex==0) {
        int i;
        
        for (i=0; i<allQuestionsID.count; i++) {//从allquestionID中找到相应问题的QUESTIONid，然后到字典中去查找对应的值
         
        selQuestion *newSelQuestion=[[selQuestion alloc]init];
            newSelQuestion=[allQuestions objectAtIndex:[[allQuestionsID objectAtIndex:i]intValue]];
            
            NSString *isRight=[[NSString alloc]init ];
            isRight=[rightOrNot objectForKey:[NSString stringWithFormat:@"%i",newSelQuestion.questionId]];
            //数据库
           
            //NSLog(@"%@",filePath);
            if([isRight isEqualToString:@"NO"])
            {
                if (sqlite3_open([filePath UTF8String], &db)!=SQLITE_OK) {//打开数据库失败
                NSLog(@"database error");
                    }    
                else{//打开数据库成功
                    char *errorMsg;
                    selQuestion *newnewSelQuestion=[allQuestions objectAtIndex: [[allQuestionsID objectAtIndex:i]intValue]];
                    NSString *updateSQL=[NSString stringWithFormat: @"update appTestDB set errorTimes=errorTimes+1 where questionId=%i",newnewSelQuestion.questionId] ;
                    NSLog(@"%@",updateSQL);
                    if (sqlite3_exec(db,[updateSQL UTF8String], NULL, NULL, &errorMsg)!=SQLITE_OK)
                        {
                    //打开表、创建表失败
                            NSLog(@"写入成绩数据库失败");
                        }else
                        {
                            NSLog(@"写入成绩数据库成功");
                        }
                    //[updateSQL release];
                    
                     }
            }
            [newSelQuestion release];
            [isRight release];
        }
        SFLS_ExerciseViewController *newIndex=[[SFLS_ExerciseViewController alloc]init];
        newIndex.navigationItem.hidesBackButton=YES;
        [self.navigationController pushViewController:newIndex animated:NO];
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"完成所有习题" message:@"完成所有习题，本地递交成功，退出习题模式" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }else{
        //如果是网络递交
        NSString *HTMLallQuestionsId=[allQuestionsID componentsJoinedByString:@"|"];
        NSMutableArray *HTMLrightOrNotArray=[[NSMutableArray alloc]init];
        
        int i;
        for (i=0; i<allQuestionsID.count; i++) {
            selQuestion *newSelQuestion=[allQuestions objectAtIndex:[[allQuestionsID objectAtIndex:i]intValue]];
            [HTMLrightOrNotArray addObject:[rightOrNot objectForKey:[NSString stringWithFormat:@"%i" ,newSelQuestion.questionId]]];
        }
        NSString *HTMLrightOrNot=[HTMLrightOrNotArray componentsJoinedByString:@"|"];
        NSLog(@"%@,%@",HTMLallQuestionsId,HTMLrightOrNot);
        NSString *xmlPath=[NSString stringWithFormat: @"http://teacher.sfls.cn/sflsAPP/Exercise/submit.asp?stu_name=%@&allQuestionsID=%@&rightOrNot=%@",stu_name,HTMLallQuestionsId,HTMLrightOrNot];
        NSLog(@"%@",xmlPath);
        XMLDocument *newDocument=[[XMLDocument alloc]initWithDelegate:self];
        self.xmlDocument=newDocument;
        [newDocument release];
        [self.xmlDocument parseRemoteXMLWithURL:xmlPath];
    }
    
}
-(void)alertViewCancel:(UIAlertView *)alertView{
    SFLS_ExerciseViewController *newSFLSexercise=[[SFLS_ExerciseViewController alloc]init];
    newSFLSexercise.navigationItem.hidesBackButton=YES;
    [self.navigationController pushViewController:newSFLSexercise animated:NO];
}
@end
