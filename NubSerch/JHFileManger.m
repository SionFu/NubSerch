//
//  JHFileManger.m
//  JHCloudOffice
//
//  Created by Fu_sion on 16/9/18.
//  Copyright © 2016年 Fu_sion. All rights reserved.
//

#import "JHFileManger.h"
//#import "JHUserInfo.h"
@implementation JHFileManger
- (NSArray *)showAllFile {
    //1.获取目标文件夹的路径
    
//    NSString *path = [NSString stringWithFormat:@"%@%@",NSHomeDirectory(),@"/Library/Caches/"];
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
//    path = [path stringByAppendingPathComponent:[JHUserInfo sharedJHUserInfo].loginid];
    [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    //2.创建文件管理者
    
    NSFileManager *manager = [NSFileManager defaultManager];
    
    //3.获取文件夹下所有的子路径
    
    NSArray *allPath =[manager contentsOfDirectoryAtPath:path error:nil];
    
    //4.遍历所有的子路径
    NSMutableArray *muArray = [NSMutableArray array];
    for (NSString *subPath in allPath) {
        NSString *filePath = [path stringByAppendingPathComponent:subPath];
        NSDictionary * attrs = [manager attributesOfItemAtPath:filePath error:nil];
        //获取创建大小
//        NSString * fileSize = attrs[NSFileSize];
//        NSLog(@"%@",fileSize);
        //获取字典中文件创建时间
        NSDate *fileCreatTime = attrs[NSFileCreationDate];
        NSDateFormatter *format = [NSDateFormatter new];
        [format setDateFormat:@"yyyy年MM月dd日 hh点mm分ss秒"];
        NSString *time = [format stringFromDate:fileCreatTime];
        NSMutableDictionary *information = [NSMutableDictionary dictionary];
        [information setValue:subPath forKey:@"title"];
        [information setValue:time forKey:@"subTitle"];
        [information setObject:filePath forKey:@"filePath"];
        [muArray addObject:information];
    }
    return muArray;
}
@end
