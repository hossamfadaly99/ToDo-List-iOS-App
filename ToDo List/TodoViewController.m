//
//  TodoViewController.m
//  ToDo List
//
//  Created by Hossam on 26/04/2023.
//

#import "TodoViewController.h"
#import "Task.h"
#import "EditToDoViewController.h"

@interface TodoViewController (){
    NSUserDefaults *defaults;
    NSData *todoData;
    NSMutableArray<Task*> *todoArray;
    BOOL isSearched;
    NSMutableArray *searchArray;
}
@property (weak, nonatomic) IBOutlet UITableView *myTable;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;


@end

@implementation TodoViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
    defaults = [NSUserDefaults new];
    
    todoData = [defaults objectForKey:@"todoArray"];
    todoArray = [NSKeyedUnarchiver unarchiveObjectWithData:todoData];

    printf("todoarray count after get from UD: %d\n", todoArray.count);
    [self.myTable reloadData];
//    _myTable.reloadData;
    isSearched = NO;
    searchArray = [NSMutableArray new];
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
    todoData = [defaults objectForKey:@"todoArray"];
    todoArray = [NSKeyedUnarchiver unarchiveObjectWithData:todoData];

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
- (IBAction)addTaskBtnClick:(id)sender {
    printf("addClick\n");
    
    AddTaskViewController *addVC = [self.storyboard instantiateViewControllerWithIdentifier:@"taskAdditionVC"];

    [self.navigationController pushViewController:addVC animated:YES];
    printf("mafrod navigation\n");
}



- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(isSearched){
        return searchArray.count;
    }
    NSData *todoData = [defaults objectForKey:@"todoArray"];
    NSArray *todoArray = [NSKeyedUnarchiver unarchiveObjectWithData:todoData];

    NSLog(@"todoarray count after get from UD: %d\n", todoArray.count);
        return todoArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *myCell = [tableView dequeueReusableCellWithIdentifier:@"normalCell" forIndexPath:indexPath];
    
    NSLog(@"%d", indexPath.row);

    Task *task;
    if(isSearched){
        task = [searchArray objectAtIndex:indexPath.row];
    }else
        task = [todoArray objectAtIndex:indexPath.row];
    
    myCell.textLabel.text = task.name;
    
    switch(task.periority){
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
            
            [todoArray removeObjectAtIndex:indexPath.row];
            
            NSData *encodedArray = [NSKeyedArchiver archivedDataWithRootObject:todoArray ];
            [defaults setObject:encodedArray forKey:@"todoArray"];
            [defaults synchronize];
            [_myTable reloadData];

            
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:action];
        
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:Nil];
        
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
    editToDoVC.taskIndex = indexPath.row;
    editToDoVC.taskState = 0;

    [self.navigationController pushViewController:editToDoVC animated:YES];

}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length == 0) {
        isSearched = NO;
    } else {
        isSearched = YES;
        [searchArray removeAllObjects];
        for (Task *task in todoArray) {
            NSRange range = [task.name rangeOfString:searchText options:NSCaseInsensitiveSearch];
            if (range.location != NSNotFound) {
                [searchArray addObject:task];
            }
        }
    }
    [_myTable reloadData];
}

@end
