//
//  ViewController.m
//  LazyProperty
//
//  Created by 若懿 on 16/11/22.
//  Copyright © 2016年 若懿. All rights reserved.
//

#import "ViewController.h"
#import "NSObject+RYLazyProperty.h"


@interface Animal : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) NSMutableArray *foots;

@property (nonatomic, copy) NSDictionary *attribute;

@end

@implementation Animal

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.name = @"board";
        self.foots = [@[@"apple",@"water"] mutableCopy];
        self.attribute = @{
                           @"height":@12,
                           };
    }
    return self;
}

@end


@interface ViewController ()

@property (nonatomic, strong) Animal *animal;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [Animal ry_setLazyPropertyArr:@[@"name",@"foots",@"attribute",]];
    [ViewController ry_setLazyPropertyArr:@[@"animal"]];
    [self.animal.foots addObject:@"Noodles"];
    NSLog(@"%@", self.animal.foots);
    NSLog(@"%@", self.animal.name);
    [Animal ry_setLazyPropertyArr:@[@"name",@"attribute",]];

    self.animal.foots = nil;
    [self.animal.foots addObject:@"Noodles"];

    NSLog(@"%@", self.animal.foots);

    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
