//
//  SFLS_ExerciseViewController.h
//  SFLS_Exercise
//
//  Created by 皓斌 朱 on 12-2-4.
//  Copyright 2012年 sfls. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XMLelement.h"
#import "XMLDocument.h"
#import "sqlite3.h"
@interface SFLS_ExerciseViewController : UIViewController <XMLDocumentDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIAlertViewDelegate,UIAlertViewDelegate>{
    UITextField *name;
    UITextField *pwd;
    XMLelement *xmlElement;
    XMLDocument *xmlDocument;
    UIActivityIndicatorView *activityIndicator;
    BOOL guestMode;
    NSMutableArray *errorArray;
    
@public
    sqlite3 *db;
    NSString *theServerAddress;
}

@property (nonatomic, retain) IBOutlet UITextField *name;
@property (nonatomic, retain) IBOutlet UITextField *pwd;
@property (nonatomic, retain)XMLDocument *xmlDocument;
@property(nonatomic,retain)XMLelement *xmlElement;
@property(nonatomic,retain)NSString *theServerAddress;
@property(nonatomic,assign)BOOL guestMode;
@property(nonatomic,retain)NSMutableArray *errorArray;
- (IBAction)login:(id)sender;
- (IBAction)bgClick:(id)sender;
-(BOOL)textFieldShouldReturn:(UITextField *)textField;
- (IBAction)Guest:(id)sender;

@property(nonatomic,retain)IBOutlet UIActivityIndicatorView *activityIndicator;

@end
