//
//  TodoViewController.h
//  ToDo List
//
//  Created by Hossam on 26/04/2023.
//

#import <UIKit/UIKit.h>
#import "AddTaskViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface TodoViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>
-(void) createAlert:(NSString *) msg;
@end

NS_ASSUME_NONNULL_END
