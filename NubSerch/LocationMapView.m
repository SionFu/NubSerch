//
//  LocationMapView.m
//  NubSerch
//
//  Created by Fu Sion on 2019/3/11.
//  Copyright © 2019 Fu_sion. All rights reserved.
//

#import "LocationMapView.h"
#import  <MapKit/MapKit.h>
@interface LocationMapView ()<MKMapViewDelegate>
@property (weak) IBOutlet MKMapView *mapView;

@end

@implementation LocationMapView
- (IBAction)closeMapView:(NSButton *)sender {
    [self dismissViewController:self];
}

- (IBAction)gotoLocation:(NSButton *)sender {
}
-(void)viewDidAppear {
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(self.latitude, self.longitude);
    [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate,self.latitude , self.longitude)];
    NSLog(@"latitude:==>%f,longitude===>%f",self.latitude,self.longitude);
    //创建大头针模型
    MKPointAnnotation * annotation = [[MKPointAnnotation alloc] init];
    
    //给模型赋值
    annotation.coordinate = coordinate;
    annotation.title = @"主标题";
    annotation.subtitle = @"副标题...";
    //添加大头针标注信息
    [self.mapView addAnnotation:annotation];
    
    //    作者：任任任任师艳
    //    链接：https://www.jianshu.com/p/bcb1496fd353
    //    来源：简书
    //    简书著作权归作者所有，任何形式的转载都请联系作者获得授权并注明出处。
    
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"商家位置";
    [self.mapView setDelegate:self];
   
}

@end
