//
//  AppDelegate.m
//  NubSerch
//
//  Created by Fu_sion on 7/24/17.
//  Copyright © 2017 Fu_sion. All rights reserved.
//

#import "AppDelegate.h"
#import "AVOSCloud.h"
#import "FGetIPAddress.h"
@interface AppDelegate ()

@end

@implementation AppDelegate
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication
                    hasVisibleWindows:(BOOL)flag{
    if (flag) {
        return NO;
    }
    else
    {
        NSWindow *window = [[NSApplication sharedApplication].windows lastObject];
        [window makeKeyAndOrderFront:self];
        return YES;
    }
}
- (void)applicationWillFinishLaunching:(NSNotification *)notification {
      [AVOSCloud setApplicationId:@"WbeWP9Vj6XInVSLBTgJWdcOo-gzGzoHsz" clientKey:@"2hHat98ni0Y4Hln6rmH4dOFX"];
}
- (void)applicationDidBecomeActive:(NSNotification *)notification {
  
    NSString *ip = [self getIPAddress];
    NSString *macAdd = [self getMacAddress];
    NSString *userIp = [[[FGetIPAddress alloc]init]getUserIPAddressAndLocation];
    NSString *username = [NSString stringWithFormat:@"ip&loc-%@,macadd-%@,locationIp-%@",userIp,macAdd,ip];
    NSString *password = @"123";
    if (username && password) {
        // LeanCloud - 登录
        // https://leancloud.cn/docs/leanstorage_guide-objc.html#登录
        [AVUser logInWithUsernameInBackground:username password:password block:^(AVUser *user, NSError *error) {
            if (error) {
                NSLog(@"保存数据 %@\n userData:%@", error, username);
                [self saveUserData];
            } else {
                NSLog(@"已有登陆数据%@",user);
                //                     AVObject *version = [AVObject objectWithClassName:@"NewVersion"];
                //                    [version setObject:user forKey:@"owner"];
                //                    [version save];
            }
        }];
    }
}
- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
    
   
}

//保存用户数据
-(void)saveUserData {
    NSString *ip = [self getIPAddress];
    NSString *macAdd = [self getMacAddress];
    AVUser *user = [AVUser user];
    NSString *userIp = [[[FGetIPAddress alloc]init]getUserIPAddressAndLocation];
    user.username = [NSString stringWithFormat:@"ip&loc-%@,macadd-%@,locationIp-%@",userIp,macAdd,ip];
    user.password = @"123";
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            //            [self performSegueWithIdentifier:@"fromSignUpToProducts" sender:nil];
            NSLog(@"登记成功");
        } else {
            NSLog(@"注册失败 %@", error);
        }
    }];
}

#pragma mark - Another way to get the device IP address
- (NSString *)getIPAddress {
    
    char ipAddress[16];
    
    if ([self getIPAddressCommandResult:ipAddress] == -1) {
        NSLog(@"获取IP地址失败");
    }
    
    return [NSString stringWithUTF8String:ipAddress];
}

- (int)getIPAddressCommandResult:(char *)result {
    
    char buffer[16];
    FILE* pipe = popen("ifconfig en0 | grep inet' ' | cut -d' ' -f 2", "r");
    if (!pipe)
        return -1;
    while(!feof(pipe)) {
        if(fgets(buffer, 1024, pipe)){
            //strcat(result, buffer);
            strncpy(result, buffer, sizeof(buffer) - 1);
            result[sizeof(buffer) - 1] = '\0';
        }
    }
    pclose(pipe);
    return 0;
}


#pragma mark - Another way to get the device MAC address
- (NSString *)getMacAddress {
    
    char macAddress[18];
    
    if ([self getMACAddressCommandResult:macAddress] == -1) {
        NSLog(@"获取MAC地址失败");
    }
    
    return [NSString stringWithUTF8String:macAddress];
}

- (int)getMACAddressCommandResult:(char *)result {
    
    char buffer[18];
    FILE* pipe = popen("ifconfig en0 | grep ether | cut -d' ' -f 2", "r");
    if (!pipe)
        return -1;
    while(!feof(pipe)) {
        if(fgets(buffer, 1024, pipe)){
            //strcat(result, buffer);
            strncpy(result, buffer, sizeof(buffer) - 1);
            result[sizeof(buffer) - 1] = '\0';
        }
    }
    pclose(pipe);
    return 0;
}



- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
