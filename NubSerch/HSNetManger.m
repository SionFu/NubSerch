//
//  HSNetManger.m
//  testmap
//
//  Created by Fu_sion on 6/15/17.
//  Copyright © 2017 Fu_sion. All rights reserved.
//
/* 
 http://apis.map.qq.com/ws/place/v1/search?keyword=饭店&boundary=region(衢州,0)&key=E3FBZ-IEF3D-K2P42-PWZEJ-MYZWV-DJFL2
 
 http://restapi.amap.com/v3/geocode/regeo?key=6f2ff94634344cea4a0177aaf35991e6&location=116.481488,39.990464&poitype=商务写字楼&radius=1000&extensions=all&batch=false&roadlevel=0
 */
#import "HSNetManger.h"
#import "HSDataManger.h"
@implementation HSNetManger
-(void)getDataWithLocalWord:(NSString *)localWord andKeyWord:(NSString *)keyWord andPage:(NSInteger)page  {
    NSString *url = [NSString stringWithFormat:@"%@keywords=%@&city=%@&output=json&offset=40&page=%ld&key=%@&extensions=all",SITEURL,keyWord,localWord, (long)page, KEY];
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)url, NULL, NULL,  kCFStringEncodingUTF8 ));
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    [manger GET:encodedString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HSDataManger sharedHSDataManger].getDicData = responseObject;
        [self.getDataDelegate getDataSuccess];
        NSLog(@"%@",url);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.getDataDelegate getDataFaild];
    }];
}
-(void)getDataWithTenCentLocalWord:(NSString *)localWord andKeyWord:(NSString *)keyWord andPage:(NSInteger)page {
    NSString *url = [NSString stringWithFormat:@"%@?keyword=%@&boundary=region(%@,0)&output=json&page=%ld&key=%@",TenCentApi,keyWord,localWord, (long)page, TenCentKEY];
    NSString * encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes( kCFAllocatorDefault, (CFStringRef)url, NULL, NULL,  kCFStringEncodingUTF8 ));
    AFHTTPRequestOperationManager *manger = [AFHTTPRequestOperationManager manager];
    [manger GET:encodedString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [HSDataManger sharedHSDataManger].getDicData = responseObject;
        [self.getDataDelegate getTenCentDataSuccess];
        NSLog(@"%@",url);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self.getDataDelegate getDataFaild];
    }];
    
}
@end

