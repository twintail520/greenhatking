//
//  AppDelegate.h
//  greenhatking
//
//  Created by 刘铭鑫 on 2020/3/5.
//  Copyright © 2020 刘铭鑫. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

