//
//  ACPMasterViewController.m
//  ACPNotes
//
//  Created by Anna Parks on 3/14/13.
//  Copyright (c) 2013 Anna Parks. All rights reserved.
//

#import "ACPMasterViewController.h"
#import "ACPNote.h"
#import "ACPDetailViewController.h"
#import "ACPDataManager.h"



@interface ACPMasterViewController ()
    @property (strong, nonatomic) NSMutableArray *notes;
    @property (strong, nonatomic) ACPDataManager *dataManager;


@end

@implementation ACPMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.dataManager = [[ACPDataManager alloc] init];
    NSLog(@"%@",self.dataManager.description);
    self.notes = [[NSMutableArray alloc] initWithArray:[self.dataManager getAllNotes]];
    for (ACPNote *note in self.notes){
        NSLog(@"%@",note.title);
    }
    [self.tableView reloadData];

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(ACPNote*) note
{
    [self.notes insertObject:note atIndex:0];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}


#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.notes.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    ACPNote *note = self.notes[indexPath.row];
    cell.textLabel.text = note.title;
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.notes removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
    }
}

- (IBAction)unwindFromDetail:(UIStoryboardSegue *)segue {
    ACPDetailViewController *srcViewController = segue.sourceViewController;
   
        ACPNote *note = [[ACPNote alloc] init];
        note.location = srcViewController.location;
        NSString *title = srcViewController.noteTitle.text;
        NSString *description = srcViewController.description.text;
        note.title = title;
        note.description = description;
        [self insertNewObject:note];

        [self.dataManager addNoteWithDescription:description  title:title];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        
        ACPDetailViewController *destViewController = segue.destinationViewController;
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        ACPNote *note = self.notes[indexPath.row];
        [destViewController setDetailItem:note];
        destViewController.isEditable = NO;
        destViewController.showDetail = YES;
    }
    else if ([[segue identifier] isEqualToString:@"addNote"]) {
        ACPDetailViewController *destViewController = segue.destinationViewController;
        destViewController.isEditable = YES;
        destViewController.addNote = YES;

    }
}


@end
