//
//  FGetIPAddress.h
//  NubSerch
//
//  Created by Fu Sion on 2019/2/20.
//  Copyright © 2019 Fu_sion. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface FGetIPAddress : NSObject
@property (nonatomic, assign)NSString *ipadd;
@property (nonatomic, assign)NSString *location;
- (NSString *)getUserIPAddressAndLocation;

@end
