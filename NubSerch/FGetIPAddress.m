//
//  FGetIPAddress.m
//  NubSerch
//
//  Created by Fu Sion on 2019/2/20.
//  Copyright © 2019 Fu_sion. All rights reserved.
//

#import "FGetIPAddress.h"
@implementation FGetIPAddress

-(NSString *)getUserIPAddressAndLocation {
    NSString *htmlString = [NSString stringWithContentsOfURL:[NSURL URLWithString:@"https://ip.tianqiapi.com/?a=getip"] encoding:NSUTF8StringEncoding error:nil];
    NSRange rangeBegin = [htmlString rangeOfString:@"com"];
    NSRange rangeEnd = [htmlString rangeOfString:@"所在区域"];
    NSRange rangIp = {rangeBegin.location + 6,rangeEnd.location - 11 - rangeBegin.location};
    NSString *ipaddStr = [NSString stringWithFormat:@"%@",htmlString];
    NSString *ipandLocation = [ipaddStr substringWithRange:rangIp];
    
    NSRange rangLocation = [htmlString rangeOfString:@"');"];
    NSRange rangL = {rangeEnd.location + 1,rangLocation.location - rangeEnd.location - 1};
    NSString *locationStr = [ipaddStr substringWithRange:rangL];
    NSLog(@"htmlString=>>>>r%@",htmlString);
    return [NSString stringWithFormat:@"%@%@",ipandLocation,locationStr];
}
@end
