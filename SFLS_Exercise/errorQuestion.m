//
//  errorQuestion.m
//  SFLS_Exercise
//
//  Created by 朱皓斌 on 12-4-1.
//  Copyright (c) 2012年 sfls. All rights reserved.
//

#import "errorQuestion.h"
#import "selQuestion.h"
#import <QuartzCore/QuartzCore.h>
@implementation errorQuestion
@synthesize errorQue,answerSelected,oldIndexPath,rightAnsLabel;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
    UITableView *newTableview=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 480) style:UITableViewStyleGrouped];
    [newTableview setDelegate:self];
    [newTableview setDataSource:self];
    //self.tableView=newTableview;
    UIButton *moveButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    moveButton.frame=CGRectMake(90, 0, 140, 50);
    [moveButton setTitle:@"从错题集中移除" forState:UIControlStateNormal];
    [moveButton addTarget:self action:@selector(moveQue:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *footerView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 50)];
    newTableview.tableFooterView=footerView;
    //self.tableView.tableFooterView.frame=CGRectMake(0, 0, 320, 50);
    [newTableview.tableFooterView addSubview:moveButton];
    [newTableview.tableFooterView addSubview:moveButton];
    self.tableView=newTableview;
    NSLog(@"%@",errorQue.question);
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 4;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return ([errorQue.question length]+17)/17*30;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 30;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return errorQue.question;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    UIButton *moveButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    moveButton.frame=CGRectMake(90, 7, 140, 30);
    switch ([indexPath row]) {
        case 0:
            cell.textLabel.text=[NSString stringWithFormat:@"A.%@",errorQue.selA];
            break;
        case 1:
            cell.textLabel.text=[NSString stringWithFormat:@"B.%@",errorQue.selB];
            break;
        case 2:
            cell.textLabel.text=[NSString stringWithFormat:@"C.%@",errorQue.selC];
            break;
        case 3:
            cell.textLabel.text=[NSString stringWithFormat:@"D.%@",errorQue.selD];
            break;
        case 4:
            [cell addSubview:moveButton];
            
            break;
        default:
            break;
    }
    //cell.textLabel.text=@"1";
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

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
    newSelQueston=errorQue;
    
    if ([newSelQueston.answer isEqualToString:answerSelected]) {
        isRight=@"YES";
        //[rightOrNot setObject:isRight forKey:[NSString stringWithFormat:@"%i", newSelQueston.questionId]];
    }
    else
    {
        isRight=@"NO";
        //[rightOrNot setObject:isRight forKey:[NSString stringWithFormat:@"%i", newSelQueston.questionId]];
    }
    
    UILabel *newLabel=[[UILabel alloc]init];
    newLabel.text=[NSString stringWithFormat:@"本题答案：%@,正确答案是%@,记录在案的答案是%@",isRight,errorQue.answer,isRight];
    newLabel.backgroundColor=[UIColor blackColor];
    [newLabel setLineBreakMode:UILineBreakModeTailTruncation];
    newLabel.numberOfLines=2;
    newLabel.frame=CGRectMake(20, 480, 280, 50);
    newLabel.textColor=[UIColor grayColor];
    newLabel.layer.cornerRadius=5;
    newLabel.layer.opacity=0.7;
    //self.rightAnsLabel=newLabel;
    [self.tableView addSubview:newLabel];
    CGContextRef context = UIGraphicsGetCurrentContext();   
    [UIView beginAnimations:@"Curl" context:context];   
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];   
    [UIView setAnimationDuration:0.5]; 
    self.tableView.tableHeaderView.frame=CGRectMake(0, 50, 320, 450);
    newLabel.frame=CGRectMake(20, 370, 280, 50);
    self.rightAnsLabel.frame=CGRectMake(20, 480, 280, 50);
    [UIView commitAnimations];
    self.rightAnsLabel=newLabel;
}
-(IBAction)moveQue:(id)sender{
    NSString *filePath;
     char *errorMsg;
    filePath=[[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"database.sqlite"];
    sqlite3_open( [filePath UTF8String],&db);
    NSString * searchString=[NSString stringWithFormat:@"update appTestDB set errorTimes=0 where questionId=%i", errorQue.questionId];
    if (sqlite3_exec(db,[searchString UTF8String], NULL, NULL, &errorMsg)==SQLITE_OK)
    {
        //打开表、创建表失败
        NSLog(@"移除成功");
    }else
    {
        NSLog(@"移除失败");
    }
    [self.navigationController popViewControllerAnimated:YES];
    //sqlite3_stmt *statement;
    //sqlite3_prepare_v2(db, [searchString UTF8String], -1, &statement, nil);
    
    
}
@end
