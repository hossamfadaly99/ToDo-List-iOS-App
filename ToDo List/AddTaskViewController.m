//
//  AddTaskViewController.m
//  ToDo List
//
//  Created by Hossam on 26/04/2023.
//

#import "AddTaskViewController.h"
#import "Task.h"

@interface AddTaskViewController (){
    NSUserDefaults *defaults;
    NSData *todoData;
    NSMutableArray<Task*> *todoArray;
}
@property (weak, nonatomic) IBOutlet UITextField *nameLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *perioritySegmented;
@property (weak, nonatomic) IBOutlet UISegmentedControl *stateSegmented;
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

@end

@implementation AddTaskViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    
    _datePicker.minimumDate = [NSDate new];
    
    defaults = [NSUserDefaults new];
    todoData = [defaults objectForKey:@"todoArray"];
//    todoArray = [NSMutableArray new];
    todoArray = [NSKeyedUnarchiver unarchiveObjectWithData:todoData];

}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)addBtnClick:(id)sender {
    if(todoArray== nil){
        todoArray = [NSMutableArray new];
    }else{
        todoArray = [NSKeyedUnarchiver unarchiveObjectWithData:todoData];

    }
    if(_nameLabel.text.length == 0){
        [self createAlert:@"Empty name!"];
//    }else if(){
//        [self createAlert:@"Enter a valid date for the task!"];
    }
    else{
        Task *task = [Task new];
        
        task.name = _nameLabel.text;
        NSLog(@"%@ nammmmmmeeee\n", task.name);
        task.periority = _perioritySegmented.selectedSegmentIndex;
        task.state = _stateSegmented.selectedSegmentIndex;
        task.date = _datePicker.date;
        
        
        [todoArray addObject:task];
        
        NSLog(@"%d arrrr count",[todoArray count]);
        
        NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:todoArray ];
        [defaults setObject:encodedArray forKey:@"todoArray"];
        
        
        [defaults synchronize];
        [self.navigationController popViewControllerAnimated:YES ];
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
