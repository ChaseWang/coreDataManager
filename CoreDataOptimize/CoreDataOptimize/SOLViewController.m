//
//  SOLViewController.m
//  CoreDataOptimize
//
//  Created by wangtao on 14-5-26.
//  Copyright (c) 2014年 wangtao. All rights reserved.
//

#import "SOLViewController.h"
#import "SOLCoredata.h"
#import "StudentEntity.h"
#import "SubjectEntity.h"

@interface SOLViewController ()
@property (nonatomic, strong)SOLCoredataManager *coredataManager;
@end

@implementation SOLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.coredataManager = [[SOLCoredataManager alloc]initWithDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)createClick:(id)sender {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"create begin");
        for (int i = 0; i < 100000; i++) {
            @autoreleasepool {
                StudentEntity *stu = (StudentEntity *)[self.coredataManager addRecordObjectByName:@"StudentEntity"];
                stu.name = [NSString stringWithFormat:@"s%d",i];
                stu.sid = [NSNumber numberWithInt:i];
            }
        }
        [self.coredataManager saveToPersistence];
        NSLog(@"create end");

    });
}

- (IBAction)queryClick:(id)sender {

//    for (int j = 0; j < 10; j++) {
        dispatch_sync(dispatch_get_global_queue(0, 0), ^{
            NSLog(@"query begin");
            NSArray *stuArray = [self.coredataManager objectsByClass:@"StudentEntity" sortBy:@"sid" ascending:YES predicate:nil];
            NSLog(@"query end");
            for (int i = 0; i < stuArray.count; i++) {
                StudentEntity *stu = [stuArray objectAtIndex:i];
                NSLog(@"%d:%@",0,stu.sid);
            }

        });
//    }

}

- (IBAction)deleteClick:(id)sender {
    for (int j = 0; j < 1; j++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self.coredataManager deleteObjectsByClass:@"StudentEntity" predicate:nil];
            [self.coredataManager saveToPersistence];
        });
    }
}

@end
