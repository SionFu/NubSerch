//
//  ViewController.m
//  NubSerch
//
//  Created by Fu_sion on 7/24/17.
//  Copyright © 2017 Fu_sion. All rights reserved.
//

#import "ViewController.h"
#import "AVOSCloud.h"
#import "FGetIPAddress.h"

@implementation ViewController
- (BOOL)applicationShouldHandleReopen:(NSApplication *)theApplication
                    hasVisibleWindows:(BOOL)flag{
    if (flag) {
        return NO;
    }
    else
    {
        [self.view.window makeKeyAndOrderFront:self];
        return YES;
    }
    
}

-(NSArray *)fixDataArray {
    if (_fixDataArray == nil) {
        _fixDataArray = [NSMutableArray array];
    }return _fixDataArray;
}
-(NSMutableArray *)dataArray {
    if (_dataArray == nil) {
        _dataArray = [NSMutableArray array];
    }return _dataArray;
}
-(NSInteger)pageNub {
    if (_pageNub == 0) {
        _pageNub = 2;
    }return _pageNub;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    _NubTbleView.delegate = self;
    _NubTbleView.dataSource = self;
    self.netManger = [HSDataManger sharedHSDataManger].netManger;
    self.netManger.getDataDelegate = self;
    //版本信息
    self.versionField.stringValue = [NSString stringWithFormat:@"%@ (%@)",[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"],[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleVersion"]] ;
}
//获取用户位置
//开始定位
- (void)startLocation {
    if ([CLLocationManager locationServicesEnabled]) {
        //        CLog(@"--------开始定位");
        self.locationManager = [[CLLocationManager alloc]init];
        self.locationManager.delegate = self;
        //控制定位精度,越高耗电量越
        self.locationManager.desiredAccuracy = kCLLocationAccuracyKilometer;
        // 总是授权
//        [self.locationManager requestAlwaysAuthorization];
        self.locationManager.distanceFilter = 10.0f;
//        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startUpdatingLocation];
    }
}

//- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
//    if ([error code] == kCLErrorDenied) {
//        CLog(@"访问被拒绝");
//    }
//    if ([error code] == kCLErrorLocationUnknown) {
//        CLog(@"无法获取位置信息");
//    }
//}
//定位代理经纬度回调
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    CLLocation *newLocation = locations[0];
    // 获取当前所在的城市名
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    //根据经纬度反向地理编译出地址信息
    [geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray *array, NSError *error){
        if (array.count > 0){
            CLPlacemark *placemark = [array objectAtIndex:0];

            //获取城市
            NSString *city = placemark.locality;
            [city stringByAppendingString:placemark.thoroughfare];
            if (!city) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                city = placemark.administrativeArea;
            }
            NSLog(@"city = %@", city);
            //保存当前的经纬度到数据库 
            AVUser *cuser = [AVUser currentUser];
            [cuser setObject:[NSString stringWithFormat:@"%@",placemark] forKey:@"locations"];
            [cuser save];
//            [self httpGetWeather:city];
        }
        else if (error == nil && [array count] == 0)
        {
            NSLog(@"No results were returned.");
        }
        else if (error != nil)
        {
            NSLog(@"An error occurred = %@", error);
        }
    }];
    //系统会一直更新数据，直到选择停止更新，因为我们只需要获得一次经纬度即可，所以获取之后就停止更新
    [manager stopUpdatingLocation];

}
-(void)getBaiDuDataSuccess {
    [self.dataArray addObjectsFromArray:[HSDataManger sharedHSDataManger].getDicData[@"results"]];
    //判断字典中的数组和字符串
    NSArray *lastDataArray = [NSArray arrayWithArray:[HSDataManger sharedHSDataManger].getDicData[@"results"]];
    if (lastDataArray.count == 0) {
        self.apiTypeSelect.enabled = YES;
    }else {
        [self loadMoreDeal];
        self.apiTypeSelect.enabled = NO;
    }
    for (int i = 0; i < lastDataArray.count; i ++){
        NSDictionary *dataDic = lastDataArray[i];
        id tempObj = [dataDic objectForKey:@"telephone"];
        NSString *str = [NSString stringWithFormat:@"%@",[tempObj class]];
        if ([str isEqualToString:@"__NSCFString"]) {
            //            NSLog(@"%@",dataDic[@"tel"]);
            NSString *telStr = [NSString stringWithFormat:@"%@",dataDic[@"telephone"]];
            if([telStr rangeOfString:@";"].location !=NSNotFound){
                //如果电话字段内有多个电话号码
                //                        NSRange range = [telStr rangeOfString:@";"];
                NSString *telNum = [self segmentationStr:telStr];
//                NSLog(@"2:%@,返回分割电话\n%@",telStr,telNum);
                //多个电话号码中有手机号码
                if (![telNum isEqualToString:@""]) {
                    /*不返回一个电话字段中有多个电话号码字段注释*/
                    //                    [self.fixDataArray addObject:[NSNumber numberWithInt:i+self.listNub]];
                }
            }else {
                //电话字段内只有一个号码
                NSLog(@"1:%@",telStr);
                if ([[self getTelFirstNubWithTelNub:telStr] isEqualToString:telStr]) {
                    //add To ListArray
                    [self.fixDataArray addObject:[NSNumber numberWithInt:i+self.listNub]];
                }
                
            }
        }
        
    }
    self.listNub += (int)lastDataArray.count;
    [self.NubTbleView reloadData];
    //    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    if (self.fixDataArray.count == 0) {
        
    }
    //    NSLog(@"获取数据成功%@",self.fixDataArray);
    //显示总共有多少条数据
    self.nubOfData.stringValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.fixDataArray.count];
}
- (void)getTenCentDataSuccess {
    [self.dataArray addObjectsFromArray:[HSDataManger sharedHSDataManger].getDicData[@"data"]];
    //判断字典中的数组和字符串
    NSArray *lastDataArray = [NSArray arrayWithArray:[HSDataManger sharedHSDataManger].getDicData[@"data"]];
    if (lastDataArray.count == 0) {
        self.apiTypeSelect.enabled = YES;
    }else {
        [self loadMoreDeal];
        self.apiTypeSelect.enabled = NO;
    }
    for (int i = 0; i < lastDataArray.count; i ++){
        NSDictionary *dataDic = lastDataArray[i];
        id tempObj = [dataDic objectForKey:@"tel"];
        NSString *str = [NSString stringWithFormat:@"%@",[tempObj class]];
        if ([str isEqualToString:@"__NSCFString"]) {
            //            NSLog(@"%@",dataDic[@"tel"]);
            NSString *telStr = [NSString stringWithFormat:@"%@",dataDic[@"tel"]];
            if([telStr rangeOfString:@";"].location !=NSNotFound){
                //如果电话字段内有多个电话号码
                //                        NSRange range = [telStr rangeOfString:@";"];
                NSString *telNum = [self segmentationStr:telStr];
//                NSLog(@"2:%@,返回分割电话\n%@",telStr,telNum);
                //多个电话号码中有手机号码
                if (![telNum isEqualToString:@""]) {
                    /*不返回一个电话字段中有多个电话号码字段注释*/
                    //                    [self.fixDataArray addObject:[NSNumber numberWithInt:i+self.listNub]];
                }
            }else {
                //电话字段内只有一个号码
//                NSLog(@"1:%@",telStr);
                if ([[self getTelFirstNubWithTelNub:telStr] isEqualToString:telStr]) {
                    //add To ListArray
                    [self.fixDataArray addObject:[NSNumber numberWithInt:i+self.listNub]];
                }
                
            }
        }
        
    }
    self.listNub += (int)lastDataArray.count;
    [self.NubTbleView reloadData];
    //    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    if (self.fixDataArray.count == 0) {
        
    }
    //    NSLog(@"获取数据成功%@",self.fixDataArray);
    //显示总共有多少条数据
    self.nubOfData.stringValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.fixDataArray.count];
}
-(void)getDataSuccess {
    [self.dataArray addObjectsFromArray:[HSDataManger sharedHSDataManger].getDicData[@"pois"]];
    //判断字典中的数组和字符串
    NSArray *lastDataArray = [NSArray arrayWithArray:[HSDataManger sharedHSDataManger].getDicData[@"pois"]];
    if (lastDataArray.count == 0) {
         self.apiTypeSelect.enabled = YES;
    }else {
        [self loadMoreDeal];
         self.apiTypeSelect.enabled = NO;
    }
    for (int i = 0; i < lastDataArray.count; i ++){
        NSDictionary *dataDic = lastDataArray[i];
        id tempObj = [dataDic objectForKey:@"tel"];
        NSString *str = [NSString stringWithFormat:@"%@",[tempObj class]];
        if ([str isEqualToString:@"__NSCFString"]) {
            //            NSLog(@"%@",dataDic[@"tel"]);
            NSString *telStr = [NSString stringWithFormat:@"%@",dataDic[@"tel"]];
            if([telStr rangeOfString:@";"].location !=NSNotFound){
                //如果电话字段内有多个电话号码
                //                        NSRange range = [telStr rangeOfString:@";"];
                NSString *telNum = [self segmentationStr:telStr];
//                NSLog(@"2:%@,返回分割电话\n%@",telStr,telNum);
                //多个电话号码中有手机号码
                if (![telNum isEqualToString:@""]) {
                    /*不返回一个电话字段中有多个电话号码字段注释*/
//                    [self.fixDataArray addObject:[NSNumber numberWithInt:i+self.listNub]];
                }
            }else {
                //电话字段内只有一个号码
//                NSLog(@"1:%@",telStr);
                if ([[self getTelFirstNubWithTelNub:telStr] isEqualToString:telStr]) {
                    //add To ListArray
                    [self.fixDataArray addObject:[NSNumber numberWithInt:i+self.listNub]];
                }
                
            }
        }
        
    }
    self.listNub += (int)lastDataArray.count;
    [self.NubTbleView reloadData];
    //    [MBProgressHUD hideHUDForView:self.tableView animated:YES];
    if (self.fixDataArray.count == 0) {
        
    }
    //    NSLog(@"获取数据成功%@",self.fixDataArray);
    //显示总共有多少条数据
    self.nubOfData.stringValue = [NSString stringWithFormat:@"%lu",(unsigned long)self.fixDataArray.count];
    
}
//以";"分割字符 并返回手机号码
-(NSString *)segmentationStr:(NSString *)str
{
    /*不返回号码中有";"注释*/
//    NSArray *array = [str componentsSeparatedByString:@";"];
    NSArray *array = [str componentsSeparatedByString:@""];
    NSMutableString *returnNum = [NSMutableString string];
    for (NSMutableString *telNum in array) {
        if ([self getTelFirstNubWithTelNub:telNum] == telNum){
             /*不返回号码中有";"注释*/
//            returnNum = [NSMutableString stringWithFormat:@"%@;%@",telNum,returnNum];
            returnNum = [NSMutableString stringWithFormat:@"%@",telNum];
        }
    }
    return returnNum;
}
//选择查询接口类型
- (IBAction)selectApiTypeButtonClick:(NSPopUpButton *)sender {
    NSLog(@"%@",sender.selectedItem.title);
}

//是否为查看手机号码
- (IBAction)phoneNubOnlyBtnClink:(NSButton *)sender {
    NSLog(@"%ld",(long)sender.state);
}

//返回手机号码 是手机号码返回手机号码 否则返回 空值
-(NSString *)getTelFirstNubWithTelNub:(NSString *)telNub {
    NSString *firtNub = [telNub substringToIndex:1];
    if ([firtNub isEqualToString:@"1"]) {
        return telNub;
    }else {
        if (self.phoneNubOnly.state == 1) {
            return nil;
        }else {
            return telNub;
        }
//        return nil;
    }
    
}
- (NSString *)getDownLoadspath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
    NSString *path = [paths.firstObject stringByAppendingPathComponent:@"NubSearch.dmg"];
    return path;
}
- (NSString *)getDocumentsPath {
    //获取DocumentsPath路径
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDownloadsDirectory, NSUserDomainMask, YES);
    NSString *path = [paths.firstObject stringByAppendingPathComponent:@"Nub"];
    NSFileManager *fm = [NSFileManager defaultManager];
   //当文件夹不存在的时候创建一个文件夹
    if (![fm fileExistsAtPath:path]) {
        //创建文件夹
        [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    }
    return path;
}
- (void)writeFileWithContent:(NSString *)contents AndFileName:(NSString *)fileName {
    NSString *documentPath = [self getDocumentsPath];
    NSString *filePath = [documentPath stringByAppendingPathComponent:fileName];
    BOOL isSuccess = [contents writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    if (isSuccess) {
        NSLog(@"writeSuccess");
        NSLog(@"FilePath:%@",filePath);
    }else {
        NSLog(@"FilePath:%@",filePath);
        NSLog(@"writefail");
    }
}
- (void)loadNewDeal {
    //将计数计数改为0
    self.pageNub = 0;
    [self.fixDataArray removeAllObjects];
    
}
- (void)loadMoreDeal {
    //将计数计数相加  数组也是相加
        [self getDataWithPage:self.pageNub ++];
}
-(void)getDataFaild {
    NSLog(@"获取数据失败");
}
//点击搜索按钮
- (IBAction)searchBtnClick:(NSButton *)sender {
    
    AVUser *currentUser = [AVUser currentUser];
     AVQuery *query = [AVQuery queryWithClassName:@"_User"];
    [query getObjectInBackgroundWithId:currentUser.objectId block:^(AVObject * _Nullable object, NSError * _Nullable error) {
        NSString *update = [object objectForKey:@"update"];
        NSAlert *alert = [[NSAlert alloc]init];
        if ([object objectForKey:@"MessageText"]) {
            [alert setMessageText:[object objectForKey:@"MessageText"]];
            [alert setInformativeText:[object objectForKey:@"InformativeText"]];
            [alert addButtonWithTitle:[object objectForKey:@"Title"]];
            [alert setAlertStyle:0];
        }
        if ([object objectForKey:@"imageUrl"]) {
            NSImage *image = [self getImageWithUrl:[object objectForKey:@"imageUrl"]];
            [alert setIcon:image];
        }
        if ([update isEqualToString:@"1"]) {
            //只提醒一次信息
            static dispatch_once_t onceTaken;
            dispatch_once(&onceTaken, ^{
                [alert beginSheetModalForWindow:self.view.window
                              completionHandler:^(NSModalResponse returnCode){
                                  //获取用户位置信息
                                  [self startLocation];
                              }];
            });
            [self searchDate];
        }else if([update isEqualToString:@"2"]){
            //每次显示信息
            
            [alert beginSheetModalForWindow:self.view.window
                          completionHandler:^(NSModalResponse returnCode){
                              [self searchDate];
                              //获取用户位置信息
                              [self startLocation];
                          }];
        
            
        }else if([update isEqualToString:@"3"]){
            //升级
            [alert beginSheetModalForWindow:self.view.window
                          completionHandler:^(NSModalResponse returnCode){
                              //升级
                              NSString *updateUrl = [object objectForKey:@"updateURL"];
                              [self downLoadNewVersionWithUrl:updateUrl];
                          }];
            
        }
        else if ([update isEqualToString:@"0"]){
            //不可使用
            [alert beginSheetModalForWindow:self.view.window
                          completionHandler:^(NSModalResponse returnCode){
                              //
                          }];
        }else {
            [self searchDate];
        }
    }];
}
//下载新版本
- (void)downLoadNewVersionWithUrl:(NSString *)url {
//     [NSTask launchedTaskWithLaunchPath:[self getDownLoadspath] arguments:nil];
    NSData *newVersion = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSString *downloadPath = [self getDownLoadspath];
    BOOL isCreate = [newVersion writeToFile:downloadPath atomically:YES];
    if (isCreate) {
        NSLog(@"创建成功");
         dispatch_async(dispatch_get_main_queue(), ^{
//             NSTask *softTask = [[NSTask alloc]init];
//             [softTask setLaunchPath:[self getDownLoadspath]];
            
//             [softTask setArguments:[NSArray arrayWithObjects:@"hello world", "2016", nil]];
//             [softTask launch];
         });
        
        
        NSError * error;
        //            [string writeToFile:myFiled atomically:YES encoding:NSUTF8StringEncoding error:&error];
        
        if (error) {
            NSLog(@"save error:%@",error.description);
        }
    }
    else{
        NSLog(@"🌺 创建失败");
    }
}
//获取支付二维码
- (NSImage * )getImageWithUrl:(NSString *)url {
    NSData *imagedata = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
    NSImage *image = [[NSImage alloc]initWithData:imagedata];
    return image;
}
- (void)searchDate {
    self.apiTypeSelect.enabled = NO;
    [self loadNewDeal];
    [self.NubTbleView reloadData];
    NSLog(@"%@%@",self.localLabel.stringValue,self.keyWordLabel.stringValue);
    [self getDataWithPage:1];
    self.saveBtn.title = @"保存";
    self.saveBtn.enabled = YES;
    AVObject *testObject = [AVObject objectWithClassName:@"TestObject"];
    [testObject setObject:self.apiTypeSelect.title forKey:@"search"];
    [testObject setObject:self.localLabel.stringValue forKey:@"place"];
    [testObject setObject:self.keyWordLabel.stringValue forKey:@"keyWord"];
    [testObject setObject:[self getMacAddress] forKey:@"userMacAdd"];
    [testObject setObject:[self getIPAddress] forKey:@"userIP"];
    [testObject setObject:[[[FGetIPAddress alloc]init]getUserIPAddressAndLocation] forKey:@"IP"];
    [testObject setObject:self.versionField.stringValue forKey:@"version"];
    [testObject save];
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
//点击保存按钮
- (IBAction)saveBtnClick:(NSButton *)sender {
    NSString *contentStr = @"";
    NSString *contentStrNub = @"";
    for (int i = 0 ; i < self.fixDataArray.count; i ++) {
        NSNumber *indexNum = self.fixDataArray[i];
        NSInteger indexTer = [indexNum intValue];
        if ([self.apiTypeSelect.title isEqualToString:@"高德地图"]) {
             contentStr = [NSString stringWithFormat:@"%@ \n%@",contentStr,self.dataArray[indexTer][@"name"]];
            NSString *telStr = self.dataArray[indexTer][@"tel"];
            if (self.phoneNubOnly.state == 1) {
                contentStrNub = [NSString stringWithFormat:@"%@ \n%@",contentStrNub,[self segmentationStr:telStr]];
            }else {
                contentStrNub = [NSString stringWithFormat:@"%@ \n%@",contentStrNub,telStr];
            }
        }else if ([self.apiTypeSelect.title isEqualToString:@"腾讯地图"]){
            contentStr  = [NSString stringWithFormat:@"%@ \n%@",contentStr,self.dataArray[indexTer][@"title"]];
            NSString *telStr = self.dataArray[indexTer][@"tel"];
            if (self.phoneNubOnly.state == 1) {
                contentStrNub = [NSString stringWithFormat:@"%@ \n%@",contentStrNub,[self segmentationStr:telStr]];
            }else {
                contentStrNub = [NSString stringWithFormat:@"%@ \n%@",contentStrNub,telStr];
            }
        }else if ([self.apiTypeSelect.title isEqualToString:@"百度地图"]){
            contentStr  = [NSString stringWithFormat:@"%@ \n%@",contentStr,self.dataArray[indexTer][@"name"]];
            NSString *telStr = self.dataArray[indexTer][@"telephone"];
            if (self.phoneNubOnly.state == 1) {
                contentStrNub = [NSString stringWithFormat:@"%@ \n%@",contentStrNub,[self segmentationStr:telStr]];
            }else {
                contentStrNub = [NSString stringWithFormat:@"%@ \n%@",contentStrNub,telStr];
            }
        }
        

    }
    if ([self.apiTypeSelect.title isEqualToString:@"高德地图"]) {
        [self writeFileWithContent:contentStr AndFileName:[NSString stringWithFormat:@"%@-%@-高德.txt",self.localLabel.stringValue,self.keyWordLabel.stringValue]];
        [self writeFileWithContent:contentStrNub AndFileName:[NSString stringWithFormat:@"%@-%@-Nub-高德.txt",self.localLabel.stringValue,self.keyWordLabel.stringValue]];
    }else if ([self.apiTypeSelect.title isEqualToString:@"腾讯地图"]){
        [self writeFileWithContent:contentStr AndFileName:[NSString stringWithFormat:@"%@-%@-腾讯.txt",self.localLabel.stringValue,self.keyWordLabel.stringValue]];
        [self writeFileWithContent:contentStrNub AndFileName:[NSString stringWithFormat:@"%@-%@-Nub-腾讯.txt",self.localLabel.stringValue,self.keyWordLabel.stringValue]];
    }else if ([self.apiTypeSelect.title isEqualToString:@"百度地图"]){
        [self writeFileWithContent:contentStr AndFileName:[NSString stringWithFormat:@"%@-%@-百度.txt",self.localLabel.stringValue,self.keyWordLabel.stringValue]];
        [self writeFileWithContent:contentStrNub AndFileName:[NSString stringWithFormat:@"%@-%@-Nub-百度.txt",self.localLabel.stringValue,self.keyWordLabel.stringValue]];
    }
    sender.title = @"已保存";
    sender.enabled = NO;
}
//获取数据
- (void)getDataWithPage:(NSInteger)page {
    if ([self.apiTypeSelect.title isEqualToString:@"高德地图"]) {
       [self.netManger getDataWithLocalWord:self.localLabel.stringValue andKeyWord:self.keyWordLabel.stringValue andPage:page];
    }else if ([self.apiTypeSelect.title isEqualToString:@"腾讯地图"]){
        [self.netManger getDataWithTenCentLocalWord:self.localLabel.stringValue andKeyWord:self.keyWordLabel.stringValue andPage:page];
    }else if ([self.apiTypeSelect.title isEqualToString:@"百度地图"]){
        [self.netManger getDataWithBaiDuLocalWord:self.localLabel.stringValue andKeyWord:self.keyWordLabel.stringValue andPage:page];
    }
}

//返回行数
-(NSInteger) numberOfRowsInTableView:(NSTableView* )tableView{
    NSInteger rows = self.fixDataArray.count;
    //do something
    return rows;
}
//每个单元内的view
-(NSView *)tableView:(NSTableView* )tableView viewForTableColumn:(NSTableColumn* )tableColumn row:(NSInteger)row{
    // 1.0.创建一个Cell
    NSTextField *view   = [[NSTextField alloc] initWithFrame:NSMakeRect(0, 0, 100, 30)];
    view.bordered       = NO;
    view.editable       = YES;
    NSNumber *indexNum = self.fixDataArray[row];
    NSInteger indexTer = [indexNum intValue];
    // 1.1.判断是哪一列
    if ([tableColumn.identifier isEqualToString:@"nameCell"]) {
        if ([self.apiTypeSelect.title isEqualToString:@"高德地图"]) {
           view.stringValue    = [NSString stringWithFormat:@"%@",self.dataArray[indexTer][@"name"]];
        }else if ([self.apiTypeSelect.title isEqualToString:@"腾讯地图"]){
            view.stringValue    = [NSString stringWithFormat:@"%@",self.dataArray[indexTer][@"title"]];
        }else if ([self.apiTypeSelect.title isEqualToString:@"百度地图"]){
            view.stringValue    = [NSString stringWithFormat:@"%@",self.dataArray[indexTer][@"name"]];
        }
    }else if ([tableColumn.identifier isEqualToString:@"nubCell"]) {
        if ([self.apiTypeSelect.title isEqualToString:@"高德地图"]) {
            NSString *phoneNub = [NSString stringWithFormat:@"%@",self.dataArray[indexTer][@"tel"]];
            
            if (self.phoneNubOnly.state == 1) {
                phoneNub =  [self segmentationStr:phoneNub];
            }
            view.stringValue = phoneNub;
        }else if ([self.apiTypeSelect.title isEqualToString:@"腾讯地图"]){
            NSString *phoneNub = [NSString stringWithFormat:@"%@",self.dataArray[indexTer][@"tel"]];
            
            if (self.phoneNubOnly.state == 1) {
                phoneNub =  [self segmentationStr:phoneNub];
            }
            view.stringValue = phoneNub;
        }else if ([self.apiTypeSelect.title isEqualToString:@"百度地图"]){
            NSString *phoneNub = [NSString stringWithFormat:@"%@",self.dataArray[indexTer][@"telephone"]];
            
            if (self.phoneNubOnly.state == 1) {
                phoneNub =  [self segmentationStr:phoneNub];
            }
            view.stringValue = phoneNub;
        }
        
        
        
    }else if ([tableColumn.identifier isEqualToString:@"addCell"]) {
        
        if ([self.apiTypeSelect.title isEqualToString:@"高德地图"]) {
            view.stringValue    = [NSString stringWithFormat:@"%@",self.dataArray[indexTer][@"address"]];
        }else if ([self.apiTypeSelect.title isEqualToString:@"腾讯地图"]){
            view.stringValue    = [NSString stringWithFormat:@"%@",self.dataArray[indexTer][@"address"]];
        }else if ([self.apiTypeSelect.title isEqualToString:@"百度地图"]){
            view.stringValue    = [NSString stringWithFormat:@"%@",self.dataArray[indexTer][@"address"]];
        }
        
    }
    else {
        view.stringValue    = [NSString stringWithFormat:@"不知道哪列的第%ld个Cell",row + 1];
    }
    return view;
    
}


- (void)setRepresentedObject:(id)representedObject {
    [super setRepresentedObject:representedObject];

    // Update the view, if already loaded.
}


@end
