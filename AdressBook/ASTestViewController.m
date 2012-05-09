//
//  ASTestViewController.m
//  AdressBook
//
//  Created by Atsushi Nagase on 5/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ASTestViewController.h"
#import <AddressBook/AddressBook.h>
#import "ABAddressBook.h"
#import "ABPerson.h"
#import "ABProperties.h"
#import "ABMultiValue.h"

@interface ASTestViewController ()

@end

@implementation ASTestViewController

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  [self writeSampleData];
}

- (void)writeSampleData {
  NSFileManager *fileManager = [NSFileManager defaultManager];
  NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
  NSString *documentsDirectory = [paths objectAtIndex:0];
  NSString *fullPath = [documentsDirectory stringByAppendingPathComponent:@"contacts.plist"];
  [fileManager createFileAtPath:fullPath contents:self.dataFromAddressBook attributes:nil];
}

- (NSData *)dataFromAddressBook {
  NSMutableArray *buf = [NSMutableArray array];
  for (ABPerson *person in [[[ABAddressBook alloc] initWithABRef:ABAddressBookCreate()] allPeople]) {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    NSMutableArray *phones = [NSMutableArray array];
    NSMutableArray *emails = [NSMutableArray array];
    [dic setValue:[person valueForProperty:kABPersonFirstNameProperty] forKey:@"first_name"];
    [dic setValue:[person valueForProperty:kABPersonLastNameProperty] forKey:@"last_name"];
    [dic setValue:[NSNumber numberWithInt:person.recordID] forKey:@"record_id"];
    ABMultiValue *mVal = [person valueForProperty:kABPersonPhoneProperty];
    for (NSInteger i=0; i<mVal.count; i++) {
      [phones addObject:[mVal valueAtIndex:i]];
    }
    [dic setValue:phones forKey:@"phones"];
    mVal = [person valueForProperty:kABPersonEmailProperty];
    for (NSInteger i=0; i<mVal.count; i++) {
      [emails addObject:[mVal valueAtIndex:i]];
    }
    [buf addObject:dic];
    [dic setValue:phones forKey:@"emails"];
  }
  NSString *error = nil;
  NSData *data = [NSPropertyListSerialization dataFromPropertyList:buf format:NSPropertyListBinaryFormat_v1_0 errorDescription:&error];
  if(error) NSLog(@"%@", error);
  return data;
}



@end
