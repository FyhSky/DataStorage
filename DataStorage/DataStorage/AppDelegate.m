//
//  AppDelegate.m
//  DataStorage
//
//  Created by FengYinghao on 12/18/15.
//  Copyright © 2015 FengYinghao. All rights reserved.
//

#import "AppDelegate.h"
#import "DataStorage.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
    
    NSString *key = @"Key";
    NSMutableArray *arr = [[NSMutableArray alloc]init];
    for (int i = 0; i < 10; i++) {
        [arr addObject:@(i)];
    }
    [[DataStorage sharedInstance] setItemValue:arr
                                        forKey:key];
    
    
    id value = [[DataStorage sharedInstance] itemValueForKey:key];
    if ([value isKindOfClass:[NSMutableArray class]]) {
        [value enumerateObjectsUsingBlock:^(id   obj, NSUInteger idx, BOOL * stop) {
            NSLog(@"Index = %ld, value = %@",idx,obj);
        }];
    }
    
   
    
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

@end
