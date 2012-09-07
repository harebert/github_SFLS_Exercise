//
//  viewErrorList.m
//  SFLS_Exercise
//
//  Created by 朱皓斌 on 12-4-1.
//  Copyright (c) 2012年 sfls. All rights reserved.
//

#import "viewErrorList.h"
#import "selQuestion.h"
#import "errorQuestion.h"
#import "SFLS_ExerciseViewController.h"
@implementation viewErrorList
@synthesize errorList;
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
-(IBAction)backToLogin:(id)sender{
    //NSLog(@"give me some hint");
    SFLS_ExerciseViewController *newExerciseViewController=[[SFLS_ExerciseViewController alloc]init];
    [self.navigationController pushViewController:newExerciseViewController animated:YES];
    //[self.navigationController.view addSubview:newExerciseViewController.view];
}
- (void)viewDidLoad
{
    self.navigationController.navigationBarHidden=NO;
    //self.navigationItem.hidesBackButton=YES;
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithTitle:@"back" style:UIBarButtonItemStyleBordered target:self action:@selector(backToLogin:)];
    [self.navigationItem setBackBarButtonItem:backItem];
    self.navigationItem.leftBarButtonItem=backItem;
    //SFLS_ExerciseViewController *newExerciseViewController;
    //[self.navigationController pushViewController:newExerciseViewController animated:YES];
    
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
        NSLog(@"you");
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
        [newMutableArray addObject:newQuestionforDB];
        [newQuestionforDB release];
    }
    errorList=[newMutableArray copy];
    [self.tableView reloadData];

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
        NSLog(@"you");
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
    errorList=[newMutableArray copy];
    [self.tableView reloadData];
    self.title=[NSString stringWithFormat:@"查看错题集-(%i题)",[errorList count]];
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
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [errorList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    selQuestion *newQuestion=[[selQuestion alloc]init];
    newQuestion=[errorList objectAtIndex:[indexPath row]];
    cell.textLabel.text=newQuestion.question;
    // Configure the cell...
    
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
    errorQuestion *newErrorQuestion=[[errorQuestion alloc]init];
    newErrorQuestion.errorQue=[self.errorList objectAtIndex:[indexPath row]];
    selQuestion *newQuestion;
    newQuestion=[errorList objectAtIndex:[indexPath row]];
    //newErrorQuestion.errorQuestion=newQuestion;
    /*
    UIBarButtonItem *backbtn=[[UIBarButtonItem alloc] 
                              initWithTitle:@"返回错题集" 
                              style:UIBarButtonItemStylePlain 
                              target:nil action:nil]; 
    newErrorQuestion.navigationItem.backBarButtonItem=backbtn; 
     */
    [self.navigationController pushViewController:newErrorQuestion animated:YES];
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
}



@end
