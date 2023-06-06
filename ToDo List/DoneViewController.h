//
//  DoneViewController.h
//  ToDo List
//
//  Created by Hossam on 27/04/2023.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DoneViewController : UIViewController<UITableViewDelegate, UITableViewDataSource>

-(void) filterToMiniArrays;

@end

NS_ASSUME_NONNULL_END
