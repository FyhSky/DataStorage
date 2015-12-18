//
//  DataStorage.m
//  DataStorage
//
//  Created by FengYinghao on 12/18/15.
//  Copyright © 2015 FengYinghao. All rights reserved.
//

#import "DataStorage.h"

@implementation DataStorage

@synthesize savePath;

+ (DataStorage *)sharedInstance {
    static DataStorage *_sharedManager = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedManager = [[self alloc] init];
    });
    return _sharedManager;
}

- (id)init {
    self = [super init];
    if (self) {
        NSString *plistPath = [[self documentPath] stringByAppendingString:@"appData.plist"];
        self.savePath = plistPath;
        [self initPlist];
    }
    return self;
}

- (void)setSaveFolderPath:(NSString *)saveFolderPath {
    self.savePath = saveFolderPath;
}

- (void)setItemValue:(id)value
              forKey:(NSString *)key {
    NSMutableDictionary *plistDictionary  = [[NSMutableDictionary alloc]init];
    if ([self isPlistFileExists]) {
        NSMutableDictionary *plistExistDictionary = [self readPlist];
        if (plistExistDictionary != nil) {
            [plistDictionary setDictionary:plistExistDictionary];
        }
    }
    [plistDictionary setValue:value forKey:key];
    [self writeToPlist:plistDictionary];
}

- (id)itemValueForKey:(NSString *)key {
    NSMutableDictionary *dataDictionary = [self readPlist];
    return [dataDictionary objectForKey:key];
}

- (void)removeItemValueForKey:(NSString *)key {
    NSMutableDictionary *dataDictionary = [self readPlist];
    [dataDictionary removeObjectForKey:key];
    [self writeToPlist:dataDictionary];

}

- (void)removeItemValueForKeys:(NSArray *)keyArray {
   NSMutableDictionary *dataDictionary = [self readPlist];
   [dataDictionary removeObjectsForKeys:keyArray];
   [self writeToPlist:dataDictionary];
}

- (void)removeAllItemValues {
    NSMutableDictionary *dataDictionary = [self readPlist];
    [dataDictionary removeAllObjects];
    [self writeToPlist:dataDictionary];
}

- (NSString *)getPlistPath {
    if (self.savePath == nil) {
        NSString *plistPath = [[self documentPath] stringByAppendingString:@"appData.plist"];
        self.savePath = plistPath;
    }
    return  self.savePath;
}

- (BOOL)isPlistFileExists {
    NSString *plistPath =[self getPlistPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if( [fileManager fileExistsAtPath:plistPath]== NO ) {
        NSLog(@"not exist");
        return NO;
    }else{
        NSLog(@"exist");
        return YES;
    }
}

- (void)initPlist {
    NSString *plistPath = [self getPlistPath];
    if (![self isPlistFileExists]) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        [fileManager createFileAtPath:plistPath contents:nil attributes:nil];
    }
}

-(BOOL)isItemValueExistsForKey:(NSString *)key {
    NSMutableDictionary *dataDictionary = [self readPlist];
    if ([dataDictionary objectForKey:key]) {
        NSLog(@"value not exist");
        return YES;
    }else{
        NSLog(@"value  exist");
        return NO;
    }
}

- (void)deletePlist {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *plistPath = [self getPlistPath];
    [fileManager removeItemAtPath:plistPath error:nil];
}


- (NSMutableDictionary *)readPlist {
    NSString *plistPath = [self getPlistPath];
    NSData *plistData = [[NSFileManager defaultManager] contentsAtPath:plistPath];
    NSMutableDictionary *resultDictionary = (NSMutableDictionary *)
    [NSPropertyListSerialization propertyListWithData:plistData
                                              options:0
                                               format:nil
                                                error:nil];
    return [resultDictionary mutableCopy];
}

- (void)replaceItemValue:(NSString *)newValue forKey:(NSString *)key {
    NSMutableDictionary *plistDictionary  = [[NSMutableDictionary alloc]init];
    if ([self isPlistFileExists]) {
        NSMutableDictionary *plistExistDictionary = [self readPlist];
        if (plistExistDictionary != nil) {
            [plistExistDictionary removeObjectForKey:key];
            [plistDictionary setDictionary:plistExistDictionary];
        }
    }
    [plistDictionary setValue:newValue forKey:key];
    [self writeToPlist:plistDictionary];
}

- (NSInteger)getItemValueCount {
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] init];
    dictionary = [self readPlist];
    return [dictionary count];
}

- (void)writeToPlist:(NSMutableDictionary *)plistDictionary {
    if (plistDictionary != nil) {
        NSString *plistPath = [self getPlistPath];
        NSError *error = nil;
        NSData *plistData = [NSPropertyListSerialization
            dataWithPropertyList:plistDictionary
                          format:NSPropertyListBinaryFormat_v1_0
                         options:0
                           error:&error];
        if ([plistData writeToFile:plistPath atomically:YES]) {
            NSLog(@"write ok!");
        } else {
            NSLog(@"write error!");
        }
    }
}

- (void)generatePlist:dictionary {
    [self writeToPlist:dictionary];
}

 - (NSString *)documentPath{
    
    NSString *budleIdentifier =[NSString stringWithFormat:@"/%@/",[[NSBundle mainBundle] bundleIdentifier]];
    
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES)[0] stringByAppendingString:budleIdentifier];
    
    NSError *err = nil;
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&err];
        
        if (err) {
            NSLog(@"file err:%@",err);
        }
    }
    
    return path;
}

@end
