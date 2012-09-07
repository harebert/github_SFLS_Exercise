//
//  SFLS_ExerciseAppDelegate.h
//  SFLS_Exercise
//
//  Created by 皓斌 朱 on 12-2-4.
//  Copyright 2012年 sfls. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SFLS_ExerciseViewController;

@interface SFLS_ExerciseAppDelegate : NSObject <UIApplicationDelegate>{

}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet SFLS_ExerciseViewController *viewController;
@end
