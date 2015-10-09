//
//  WSCoreDataManagerTests.m
//  WSCoreDataManagerTests
//
//  Created by Riley Crebs on 10/8/15.
//  Copyright © 2015 Incravo. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "ModelManager.h"

@interface WSCoreDataManagerTests : XCTestCase
@property (nonatomic, strong) ModelManager *mm;
@end

@implementation WSCoreDataManagerTests

- (void)setUp {
    [super setUp];
    [ModelManager setDefaultMOMName:@"TestData"];
    [ModelManager setDefaultStoreName:@"TestData"];
    _mm = [[ModelManager alloc] initWithNewSession];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    _mm = nil;
    [super tearDown];
}

- (void)testFindCreateEntity_ShouldCreateObjectSuccessfully {
    NSArray *objectNames = @[@"hewi", @"dewi", @"loui"];
    NSArray *coreDataObjects = [self.mm findOrCreateEntity:@"TestObject"
                                              entityIdName:@"name"
                                                 entityIds:objectNames];
    XCTAssertEqual([objectNames count], [coreDataObjects count]);
}

- (void)testFindCreateEntity_WithAlreadyCreatedEntities_ShouldCreateObjectSuccessfully {
    NSArray *objectNames = @[@"hewi", @"dewi", @"loui"];
    NSArray *coreDataObjects = [self.mm findOrCreateEntity:@"TestObject"
                                              entityIdName:@"name"
                                                 entityIds:objectNames];
    XCTAssertEqual([objectNames count], [coreDataObjects count]);
    
    NSArray *secondObjectNames = @[@"Larry", @"Curly", @"Moe"];
    NSMutableArray *combinedNames = [NSMutableArray arrayWithArray:objectNames];
    [combinedNames addObjectsFromArray:secondObjectNames];
    
    NSArray *nextCollectionOfObject = [self.mm findOrCreateEntity:@"TestObject"
                                              entityIdName:@"name"
                                                 entityIds:combinedNames];
    XCTAssertEqual([nextCollectionOfObject count], [combinedNames count]);
    
    for (NSInteger i = 0; i < [coreDataObjects count]; ++i) {
        XCTAssertTrue([nextCollectionOfObject containsObject:coreDataObjects[i]]);
    }
}

@end
