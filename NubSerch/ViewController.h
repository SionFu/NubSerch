//
//  ViewController.h
//  NubSerch
//
//  Created by Fu_sion on 7/24/17.
//  Copyright © 2017 Fu_sion. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "HSNetManger.h"
#import "HSDataManger.h"
#import <CoreLocation/CoreLocation.h> 
@interface ViewController : NSViewController<HSGetDataDelegate,NSTableViewDelegate,NSTableViewDataSource,CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (weak) IBOutlet NSTextField *localLabel;
@property (weak) IBOutlet NSTextField *keyWordLabel;
@property (nonatomic, strong)HSNetManger *netManger;
@property (weak) IBOutlet NSTableView *NubTbleView;
//获取数据内容
@property(nonatomic, strong)NSMutableArray *dataArray;
//整理后的数据
@property(nonatomic, strong)NSMutableArray *fixDataArray;
//页数
@property(nonatomic, assign)NSInteger pageNub;
//获取数据序列数 总和
@property(nonatomic, assign)int listNub;
@property (weak) IBOutlet NSButton *saveBtn;
//显示数据条数
@property (weak) IBOutlet NSTextField *nubOfData;
//是否值显示手机号码内容
@property (weak) IBOutlet NSButton *phoneNubOnly;
//选择接口
@property (weak) IBOutlet NSPopUpButton *apiTypeSelect;
//显示版本信息
@property (weak) IBOutlet NSTextField *versionField;

@end

