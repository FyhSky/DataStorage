//
//  DataStorage.h
//  DataStorage
//
//  Created by FengYinghao on 12/18/15.
//  Copyright © 2015 FengYinghao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataStorage : NSObject

@property (nonatomic,copy) NSString *savePath;

+(DataStorage *)sharedInstance;

- (void)setItemValue: (id)value
             forKey : (NSString *)key;
- (id)itemValueForKey : (NSString *)key;
- (void)removeItemValueForKey: (NSString *)key;
- (void)removeItemValueForKeys:(NSArray *)keyArray;
- (void)replaceItemValue:(NSString *)newValue forKey:(NSString *)key;
- (void)removeAllItemValues;
- (NSInteger)getItemValueCount;

@end
