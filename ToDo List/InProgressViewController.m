//
//  InProgressViewController.m
//  ToDo List
//
//  Created by Hossam on 27/04/2023.
//

#import "InProgressViewController.h"
#import "Task.h"
#import "EditToDoViewController.h"

@interface InProgressViewController (){
    NSUserDefaults *defaults;
    NSData *todoData;
    NSData *inProgressData;
    NSMutableArray<Task*> *inProgressArray;
    NSMutableArray<Task*> *lowPeriority;
    NSMutableArray<Task*> *mediumPeriority;
    NSMutableArray<Task*> *highPiority;
    Task *currentTask;
    NSUInteger globalTaskIndex;
    BOOL isFiltered;
}
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (weak, nonatomic) IBOutlet UIButton *filterBtn;


@end

@implementation InProgressViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
    defaults = [NSUserDefaults new];
//    lowPeriority = [NSMutableArray new];
//    mediumPeriority = [NSMutableArray new];
//    highPiority = [NSMutableArray new];
    
    inProgressData = [defaults objectForKey:@"inProgressArray"];
    inProgressArray = [NSKeyedUnarchiver unarchiveObjectWithData:inProgressData];
    
    
    [self filterToMiniArrays];

    printf("todoarray count after get from UD: %d\n", inProgressArray.count);
    
    [self.myTable reloadData];
//    _myTable.reloadData;
}
- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
//    [self.myTable reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    defaults = [NSUserDefaults new];
    _myTable.dataSource = self;
    _myTable.delegate = self;
    todoData = [defaults objectForKey:@"inProgressArray"];
    inProgressArray = [NSKeyedUnarchiver unarchiveObjectWithData:todoData];

    printf("inprogress count %i\n", inProgressArray.count);
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if(isFiltered)
        return 3;
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSData *todoData = [defaults objectForKey:@"inProgressArray"];
    NSArray<Task*> *todoArray = [NSKeyedUnarchiver unarchiveObjectWithData:todoData];
    
    if(!isFiltered)
        return todoArray.count;
    
    printf("low: %d, ", lowPeriority.count);
        switch(section){
            case 0:
                return [lowPeriority count];
            case 1:
                return [mediumPeriority count];
            default:
                return [highPiority count];
        }
    
}




- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"inProgressCell" forIndexPath:indexPath];
    
    NSLog(@"%d", indexPath.row);

    if(!isFiltered){
        
        myCell.textLabel.text = [inProgressArray objectAtIndex:indexPath.row].name;
        
        switch([inProgressArray objectAtIndex:indexPath.row].periority){
            case 0:
                myCell.imageView.image = [UIImage imageNamed:@"low"];
                break;
            case 1:
                myCell.imageView.image = [UIImage imageNamed:@"medium"];
                break;
            case 2:
                myCell.imageView.image = [UIImage imageNamed:@"high"];
                break;
        }
    }
    else{
        
        switch(indexPath.section){
            case 0:
                myCell.textLabel.text = [lowPeriority objectAtIndex:indexPath.row].name;
                myCell.imageView.image = [UIImage imageNamed:@"low"];
                break;
            case 1:
                myCell.textLabel.text = [mediumPeriority objectAtIndex:indexPath.row].name;
                myCell.imageView.image = [UIImage imageNamed:@"medium"];
                break;
            case 2:
                myCell.textLabel.text = [highPiority objectAtIndex:indexPath.row].name;
                myCell.imageView.image = [UIImage imageNamed:@"high"];
                break;
        }
        
    }
    
    return myCell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove the deleted object from your data source.
        //If your data source is an NSMutableArray, do this
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:@"are you sure that you want to delete the task?" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            
            if(isFiltered){
                switch(indexPath.section){
                    case 0:
                        currentTask = [lowPeriority objectAtIndex:indexPath.row];
                        globalTaskIndex = [inProgressArray indexOfObject:currentTask];
                        break;
                    case 1:
                        currentTask = [mediumPeriority objectAtIndex:indexPath.row];
                        globalTaskIndex = [inProgressArray indexOfObject:currentTask];
                        break;
                    case 2:
                        currentTask = [highPiority objectAtIndex:indexPath.row];
                        globalTaskIndex = [inProgressArray indexOfObject:currentTask];
                        break;
                }
                
            }else{
                globalTaskIndex = indexPath.row;
            }
            
            [inProgressArray removeObjectAtIndex:globalTaskIndex];
            
            NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:inProgressArray ];
            [defaults setObject:encodedArray forKey:@"inProgressArray"];
            [defaults synchronize];
            
            [self filterToMiniArrays];
            
            [_myTable reloadData];
            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:action];
        [alert addAction:cancelAction];
        
        [self presentViewController:alert animated:YES completion:Nil];
        
//        [_myTable reloadData]; // tell table to refresh now
    }
}

-(void) createAlert:(NSString *) msg{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Alert" message:msg preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:action];
    
    [self presentViewController:alert animated:YES completion:Nil];
    
}


//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//        return 50.0;
//
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
//{
//    UIView *footerView = [[UIView alloc] init];
//    footerView.backgroundColor = [UIColor whiteColor];
//    return footerView;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EditToDoViewController *editToDoVC = [self.storyboard instantiateViewControllerWithIdentifier:@"editTodoTaskVC"];
    
    editToDoVC.taskState = 1;

    if(isFiltered){
        switch(indexPath.section){
            case 0:
                currentTask = [lowPeriority objectAtIndex:indexPath.row];
                editToDoVC.taskIndex = [inProgressArray indexOfObject:currentTask];
                break;
            case 1:
                currentTask = [mediumPeriority objectAtIndex:indexPath.row];
                editToDoVC.taskIndex = [inProgressArray indexOfObject:currentTask];
                break;
            case 2:
                currentTask = [highPiority objectAtIndex:indexPath.row];
                editToDoVC.taskIndex = [inProgressArray indexOfObject:currentTask];
                break;
        }
        
    }else{
        editToDoVC.taskIndex = indexPath.row;
    }
    
    [self.navigationController pushViewController:editToDoVC animated:YES];

}
- (IBAction)filterClick:(id)sender {
    
    [_filterBtn setSelected:!isFiltered];
    isFiltered = !isFiltered;
    
    [_myTable reloadData];
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(isFiltered){
        if(section == 0)
        {
            return @"Low";
        }
        else if (section == 1){
            return @"Medium";
        }
        else if (section == 2){
            return @"High";
        }
    }

    return @"";
}
-(void) filterToMiniArrays{
    lowPeriority  = [NSMutableArray new];
    mediumPeriority  = [NSMutableArray new];
    highPiority  = [NSMutableArray new];
    for(int i=0 ;i <inProgressArray.count; i++){
//            printf("low 3aaa3333 %d\n", lowPeriority.count);
        switch([inProgressArray objectAtIndex:i].periority){
            case 0:
                [lowPeriority addObject:[inProgressArray objectAtIndex:i]];
                break;
            case 1:
                [mediumPeriority addObject:[inProgressArray objectAtIndex:i]];
                break;
            case 2:
                [highPiority addObject:[inProgressArray objectAtIndex:i]];
                break;
        }
    }
}

@end
