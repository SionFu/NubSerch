//
//  HSDataManger.h
//  testmap
//
//  Created by Fu_sion on 6/14/17.
//  Copyright © 2017 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Singleton.h"
#import "HSNetManger.h"
@interface HSDataManger : NSObject
@property (nonatomic, strong) NSDictionary *getDicData;
@property (nonatomic, strong) HSNetManger *netManger;
singleton_interface(HSDataManger)
@end
