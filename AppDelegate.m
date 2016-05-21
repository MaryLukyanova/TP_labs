//
//  AppDelegate.m
//  lab08_1
//
//  Created by Admin on 13.05.16.
//  Copyright © 2016 Admin. All rights reserved.
//

#import "AppDelegate.h"
#import "Record.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize managedObjectContext,managedObjectModel,persistentStoreCoordinator;


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    if (![[NSUserDefaults standardUserDefaults]
          boolForKey:@"HasLaunchedOnce"]) { [[NSUserDefaults
                                              standardUserDefaults] setBool:YES forKey:@"HasLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        Record * firstFlight =
        [NSEntityDescription
         insertNewObjectForEntityForName:@"Record"
         inManagedObjectContext:self.managedObjectContext];
        firstFlight.cityFrom = @"Minsk";
        firstFlight.cityTo = @"Moskow";
        firstFlight.aviaCompany
        = @"AeroFlot";
        firstFlight.price = [NSNumber numberWithInt:1000.0]; Record * secondFlight =
        [NSEntityDescription
         insertNewObjectForEntityForName:@"Record"
         inManagedObjectContext:self.managedObjectContext];
        secondFlight.cityFrom = @"Moskow";
        secondFlight.cityTo = @"Minsk";
        secondFlight.aviaCompany = @"ChelAvia";
        secondFlight.price = [NSNumber numberWithInt:1200.0];
        Record * thirdFlight = [NSEntityDescription insertNewObjectForEntityForName:@"Record"
                                inManagedObjectContext:self.managedObjectContext];
        thirdFlight.cityFrom = @"Smolensk";
        thirdFlight.cityTo = @"Tula"; thirdFlight.aviaCompany =
        @"ChelAvia";
        thirdFlight.price = [NSNumber
                                          numberWithInt:500.0]; Record * fourthFlight =
        [NSEntityDescription
         insertNewObjectForEntityForName:@"Record"
         inManagedObjectContext:self.managedObjectContext];
        fourthFlight.cityFrom = @"Tula";
        fourthFlight.cityTo = @"Moskow"; fourthFlight.aviaCompany =
        @"RusLain";
        fourthFlight.price = [NSNumber
                                          numberWithInt:1500.0]; Record * fivthFlight =
        [NSEntityDescription
        insertNewObjectForEntityForName:@"Record"
         inManagedObjectContext:self.managedObjectContext];
        fivthFlight.cityFrom = @"Minsk";
        fivthFlight.cityTo = @"Tula";
        fivthFlight.aviaCompany = @"AeroFlot";
        fivthFlight.price = [NSNumber numberWithInt:800.0];
        [self saveContext];
    }
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (NSString *)applicationDocumentsDirectory {
    
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,    NSUserDomainMask, YES) lastObject];
    
}

// 1
- (NSManagedObjectContext *) managedObjectContext { if (managedObjectContext != nil) { return managedObjectContext; } NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator]; if(coordinator != nil) { managedObjectContext = [[NSManagedObjectContext alloc] init];
    [managedObjectContext setPersistentStoreCoordinator: coordinator]; }
return managedObjectContext; }
//2
- (NSManagedObjectModel *)managedObjectModel { if (managedObjectModel != nil) { return managedObjectModel; }
managedObjectModel = [NSManagedObjectModel mergedModelFromBundles:nil];
    return
    managedObjectModel; }
//3
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator { if
    (persistentStoreCoordinator != nil) {
        return persistentStoreCoordinator; }
    NSURL *storeUrl = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory]
                            stringByAppendingPathComponent:@"lab08_1.sqlite"]];
    NSError *error = nil;
    persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc]
     initWithManagedObjectModel:[self managedObjectModel]];
    if(![persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType
         configuration:nil URL:storeUrl options:nil error:&error]) {
        /*Error for store creation should be handled in here*/
    }
    return persistentStoreCoordinator;
}

-(void)saveContext
{
    {
    NSError *error = nil; NSManagedObjectContext *managedObjectCont =
    self.managedObjectContext; if(nil != managedObjectCont) {
        if([managedObjectCont hasChanges] && ![managedObjectCont save:&error]){
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort(); }
        }
    }
}


- (NSArray *)getFlightsWithCityFrom:(NSString *)cityFrom andCityTo:(NSString *)cityTo
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setPredicate:[NSPredicate predicateWithFormat:@"cityFrom == %@ and cityTo == %@", cityFrom, cityTo]];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    NSArray *fetchedRecords = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    return [fetchedRecords sortedArrayUsingComparator: ^NSComparisonResult(id obj1, id obj2) {
        if(((Record *)obj1).price < ((Record *)obj2).price) {
            return NSOrderedAscending;
        }
        if(((Record *)obj1).price > ((Record *)obj2).price) {
            return NSOrderedDescending;
        }
        return NSOrderedSame;
    }];
    
}


-(NSArray*)getAllFlights
{
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Record" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    NSError* error;
    NSArray *fetchedRecords =[self.managedObjectContext
     executeFetchRequest:fetchRequest error:&error];
    return fetchedRecords;
}

@end
