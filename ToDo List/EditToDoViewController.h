//
//  EditToDoViewController.h
//  ToDo List
//
//  Created by Hossam on 26/04/2023.
//

#import <UIKit/UIKit.h>
#import "Task.h"

NS_ASSUME_NONNULL_BEGIN

@interface EditToDoViewController : UIViewController
//@property NSInteger todoTaskIndex;
//@property NSInteger inProgressTaskIndex;
//@property NSInteger doneTaskIndex;
@property NSInteger taskIndex;
@property NSInteger taskState;



-(void) createAlert:(NSString *) msg;
-(void) validateNameAndDate;
-(void) changeTaskState;
@end

NS_ASSUME_NONNULL_END
