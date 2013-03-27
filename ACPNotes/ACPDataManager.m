//
//  ACPDataManager.m
//  ACPNotes
//
//  Created by Anna Parks on 3/26/13.
//  Copyright (c) 2013 Anna Parks. All rights reserved.
//

#import "ACPDataManager.h"
#import <CoreData/CoreData.h>
#import "ACPNote.h"

#define kACPEntityName @"ACPNote"
#define kACPSaveError @"Whoops, couldn't save: %@"


@interface ACPDataManager ()
    @property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
    @property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
    @property (strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@end


@implementation ACPDataManager
- (BOOL)addNoteWithDescription:(NSString *)description title:(NSString *)title
{
    NSManagedObjectContext *context = [self managedObjectContext];
    ACPNote *note = [NSEntityDescription insertNewObjectForEntityForName:kACPEntityName inManagedObjectContext:context];
    note.title = title;
    note.description = description;
    NSError *error;
    if (![context save:&error]) {
        NSLog(kACPSaveError, [error localizedDescription]);
        return NO;
    }
    NSLog(@"note saved");
    return YES;
}

- (NSArray *)getAllNotes
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:kACPEntityName inManagedObjectContext:context];
    
    //NSSortDescriptor *sort = [[NSSortDescriptor alloc]
    //                          initWithKey:@"timestamp" ascending:YES];
    //[fetchRequest setSortDescriptors:@[sort]];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    return fetchedObjects;
}

- (BOOL)deleteNote:(ACPNote *)note
{
    NSManagedObjectContext *context = [self managedObjectContext];
    [context deleteObject:note];
    NSError *error;
    if (![context save:&error]) {
        NSLog(kACPSaveError, [error localizedDescription]);
        return NO;
    }
    return YES;
}

- (BOOL)updateNote:(ACPNote *)note withDescription:(NSString *)description title:(NSString *)title
{
    NSManagedObjectContext *context = [self managedObjectContext];
    note.title = title;
    note.description = description;
    NSError *error;
    if (![context save:&error]) {
        NSLog(kACPSaveError, [error localizedDescription]);
        return NO;
    }
    return YES;
}

- (BOOL)deleteAllNotes
{
    NSArray *allNotes = [self getAllNotes];
    for (ACPNote *note in allNotes) {
        if (![self deleteNote:note]) {
            return NO;
        }
    }
    return YES;
}


#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ACPNote" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"ACPNote.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
