//
//  Task.h
//  ToDo List
//
//  Created by Hossam on 26/04/2023.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Task : NSObject<NSCoding, NSSecureCoding>

@property NSString *name;
@property int periority;
@property int state;
@property NSDate *date;


@end

NS_ASSUME_NONNULL_END
