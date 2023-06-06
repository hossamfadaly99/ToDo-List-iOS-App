//
//  Task.m
//  ToDo List
//
//  Created by Hossam on 26/04/2023.
//

#import "Task.h"

@implementation Task

-(void) encodeWithCoder:(NSCoder *)encoder{
    [encoder encodeObject:self.name forKey:@"name"];
    [encoder encodeInteger:self.periority forKey:@"periority"];
    [encoder encodeInteger:self.state forKey:@"state"];
    [encoder encodeObject:self.date forKey:@"date"];
    
    
}

- (id)initWithCoder:(NSCoder *)decoder{
    if(self = [super init]){
        self.name = [decoder decodeObjectForKey:@"name"];
        self.periority = [decoder decodeIntegerForKey:@"periority"];
        self.state = [decoder decodeIntegerForKey:@"state"];
        self.date = [decoder decodeObjectForKey:@"date"];
    }
    return self;
}

+(BOOL) supportsSecureCoding{
    return YES;
}

@end
