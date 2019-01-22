//
//  HSNetManger.h
//  testmap
//
//  Created by Fu_sion on 6/15/17.
//  Copyright © 2017 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
//高德接口
#define SITEURL @"https://restapi.amap.com/v3/place/text?"
#define KEY @"3f46c75b796f1aca86908b25f18c2c5f"
//腾讯接口
#define TenCentApi @"https://apis.map.qq.com/ws/place/v1/search?"
#define TenCentKEY @"E3FBZ-IEF3D-K2P42-PWZEJ-MYZWV-DJFL2"
//百度接口
#define BiaduApi @"https://api.map.baidu.com/place/v2/search?"
#define BiaduKEY @"clZ8KNbp57z41BRCVjgvxyK98ew111Ao"

@protocol HSGetDataDelegate <NSObject>
//获取网络数据
- (void)getDataSuccess;
- (void)getTenCentDataSuccess;
- (void)getBaiDuDataSuccess;
- (void)getDataFaild;
@end
@interface HSNetManger : NSObject

@property (nonatomic, weak) id<HSGetDataDelegate>getDataDelegate;
/**
 *  获取附件内容 文件
 */
-(void)getDataWithLocalWord:(NSString *)localWord andKeyWord:(NSString *)keyWord andPage:(NSInteger)page;
/**
 *  腾讯地图接口获取数据
 */
-(void)getDataWithTenCentLocalWord:(NSString *)localWord andKeyWord:(NSString *)keyWord andPage:(NSInteger)page;
/**
 *  百度地图接口获取数据
 */
-(void)getDataWithBaiDuLocalWord:(NSString *)localWord andKeyWord:(NSString *)keyWord andPage:(NSInteger)page;
@end
