//
//  HSNetManger.h
//  testmap
//
//  Created by Fu_sion on 6/15/17.
//  Copyright © 2017 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#define SITEURL @"https://restapi.amap.com/v3/place/text?"
#define KEY @"3f46c75b796f1aca86908b25f18c2c5f"
@protocol HSGetDataDelegate <NSObject>
//获取网络数据
- (void)getDataSuccess;
- (void)getDataFaild;
@end
@interface HSNetManger : NSObject

@property (nonatomic, weak) id<HSGetDataDelegate>getDataDelegate;
/**
 *  获取附件内容 文件
 */
-(void)getDataWithLocalWord:(NSString *)localWord andKeyWord:(NSString *)keyWord andPage:(NSInteger)page;
@end
