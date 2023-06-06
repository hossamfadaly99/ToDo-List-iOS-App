//
//  EditToDoViewController.m
//  ToDo List
//
//  Created by Hossam on 26/04/2023.
//

#import "EditToDoViewController.h"
#import "Task.h"

@interface EditToDoViewController (){
    NSUserDefaults *defaults;
    NSData *todoData;
    NSData *inProgressData;
    NSData *doneData;
    NSMutableArray<Task*> *todoArray;
    NSMutableArray<Task*> *inProgressArray;
    NSMutableArray<Task*> *doneArray;
    Task *task;
}
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *perioritySegmented;
@property (weak, nonatomic) IBOutlet UISegmentedControl *stateSegmented;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (weak, nonatomic) IBOutlet UIButton *editBtn;


@end

@implementation EditToDoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    defaults = [NSUserDefaults standardUserDefaults];
    todoData = [defaults objectForKey:@"todoArray"];
    inProgressData = [defaults objectForKey:@"inProgressArray"];
    doneData = [defaults objectForKey:@"doneArray"];
    todoArray = [NSKeyedUnarchiver unarchiveObjectWithData:todoData];
    inProgressArray = [NSKeyedUnarchiver unarchiveObjectWithData:inProgressData];
    doneArray = [NSKeyedUnarchiver unarchiveObjectWithData:doneData];
    
    if(self.taskState == 0)
        task = [todoArray objectAtIndex:_taskIndex];
    else if (self.taskState == 1)
        task = [inProgressArray objectAtIndex:_taskIndex];
    else
        task = [doneArray objectAtIndex:_taskIndex];

    //    else
    //        task = [doneArray objectAtIndex:_taskIndex];
    NSLog(@"%@\n",task.name);
    _nameLabel.text = task.name;
    _perioritySegmented.selectedSegmentIndex = task.periority;
    _stateSegmented.selectedSegmentIndex = task.state;
    _datePicker.date = task.date;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    if(_taskState == 1){
        [_stateSegmented setEnabled:NO forSegmentAtIndex:0];
        [_editBtn setHidden:NO];
    }
    else if(_taskState == 2){
        [_stateSegmented setEnabled:NO forSegmentAtIndex:0];
        [_stateSegmented setEnabled:NO forSegmentAtIndex:1];
        [_editBtn setHidden:YES];
    }else{
        
        [_stateSegmented setEnabled:YES forSegmentAtIndex:0];
        [_stateSegmented setEnabled:YES forSegmentAtIndex:1];
        [_editBtn setHidden:NO];
    }
    [self.navigationController setNavigationBarHidden:NO];
}


- (IBAction)editBtnClick:(id)sender {
    
    task.name = _nameLabel.text;
    task.periority = _perioritySegmented.selectedSegmentIndex;
    task.state = _stateSegmented.selectedSegmentIndex;
    task.date = _datePicker.date;
    
    [self validateNameAndDate];
    
}

-(void) changeTaskState{
    printf("selected state: %i\n",_stateSegmented.selectedSegmentIndex);
    if(_stateSegmented.selectedSegmentIndex==0){
        
        [todoArray replaceObjectAtIndex:_taskIndex withObject:task];
        
        
        NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:todoArray ];
        [defaults setObject:encodedArray forKey:@"todoArray"];
    }
    else if(_stateSegmented.selectedSegmentIndex==1){
        
        printf("inProgress count: %i\n", inProgressArray.count);
        
        if(inProgressArray.count == 0){
            inProgressArray = [NSMutableArray new];
            NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:inProgressArray ];
            [defaults setObject:encodedArray forKey:@"inProgressArray"];
            
        } else{
            inProgressData = [defaults objectForKey:@"inProgressArray"];
            inProgressArray = [NSKeyedUnarchiver unarchiveObjectWithData:inProgressData];
        }
        if(self.taskState == 0){
            [todoArray removeObjectAtIndex:_taskIndex];
            NSData *encodedToDoArray = [NSKeyedArchiver archivedDataWithRootObject:todoArray ];
            [defaults setObject:encodedToDoArray forKey:@"todoArray"];
            
            [inProgressArray addObject:task];
            printf("inprogress count after edit %i\n", inProgressArray.count);
            
            NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:inProgressArray ];
            [defaults setObject:encodedArray forKey:@"inProgressArray"];
        }else if(self.taskState == 1){
            
            [inProgressArray replaceObjectAtIndex:_taskIndex withObject:task];
            
            
            NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:inProgressArray ];
            [defaults setObject:encodedArray forKey:@"inProgressArray"];
        }
        
    }else if (_stateSegmented.selectedSegmentIndex==2){
        
//        zzzz
//        printf("inProgress count: %i\n", inProgressArray.count);
        printf("zzzz");
        if(doneArray.count == 0){
            doneArray = [NSMutableArray new];
            NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:doneArray ];
            [defaults setObject:encodedArray forKey:@"doneArray"];
            
        } else{
            doneData = [defaults objectForKey:@"doneArray"];
            doneArray = [NSKeyedUnarchiver unarchiveObjectWithData:doneData];
        }
        
        if(self.taskState == 0){
            [todoArray removeObjectAtIndex:_taskIndex];
            NSData *encodedToDoArray = [NSKeyedArchiver archivedDataWithRootObject:todoArray ];
            [defaults setObject:encodedToDoArray forKey:@"todoArray"];
            
            //        inProgressData = [defaults objectForKey:@"inProgressArray"];
            //        inProgressArray = [NSKeyedUnarchiver unarchiveObjectWithData:inProgressData];
            
            
            printf("done count after edit %i\n", doneArray.count);
            
            doneData = [defaults objectForKey:@"doneArray"];
            doneArray = [NSKeyedUnarchiver unarchiveObjectWithData:doneData];
            
            printf("done count after edit %i\n", doneArray.count);
            [doneArray addObject:task];
            printf("done count after edit %i\n", doneArray.count);
            
            NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:doneArray ];
            [defaults setObject:encodedArray forKey:@"doneArray"];
        }else if(self.taskState == 1){
            
                [inProgressArray removeObjectAtIndex:_taskIndex];
                NSData *encodedToDoArray = [NSKeyedArchiver archivedDataWithRootObject:inProgressArray ];
                [defaults setObject:encodedToDoArray forKey:@"inProgressArray"];
//            [doneArray replaceObjectAtIndex:_taskIndex withObject:task];
            
            doneData = [defaults objectForKey:@"doneArray"];
            doneArray = [NSKeyedUnarchiver unarchiveObjectWithData:doneData];
            
            [doneArray addObject:task];
            
            NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:doneArray ];
            [defaults setObject:encodedArray forKey:@"doneArray"];
        }else if(self.taskState == 2){
            
            [doneArray replaceObjectAtIndex:_taskIndex withObject:task];
            
            NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:doneArray ];
            [defaults setObject:encodedArray forKey:@"doneArray"];
        }
        
    }
}

-(void) validateNameAndDate{
    
    NSDate *today = [NSDate new];
    if(_nameLabel.text.length == 0){
        [self createAlert:@"Empty name!"];
    }else if(!([_datePicker.date compare: today] == NSOrderedDescending)){
        [self createAlert:@"Enter a valid date for the task!"];
    }
    else{
        printf("%i zxzxzxxzxz\n", _nameLabel.text.length);
        
        
        [self changeTaskState];
        
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}

-(void) createAlert:(NSString *) msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:Nil];
    
}

@end
