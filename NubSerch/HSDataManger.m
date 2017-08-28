//
//  HSDataManger.m
//  testmap
//
//  Created by Fu_sion on 6/14/17.
//  Copyright © 2017 Fu_sion. All rights reserved.
//

#import "HSDataManger.h"

@implementation HSDataManger
-(HSNetManger *)netManger {
    if (_netManger == nil) {
        _netManger = [HSNetManger new];
    }return _netManger;
}
-(NSDictionary *)getDicData {
    if (_getDicData == nil) {
        _getDicData = [NSDictionary dictionary];
    }return _getDicData;
}
singleton_implementation(HSDataManger)
@end
