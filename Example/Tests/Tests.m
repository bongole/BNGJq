//
//  BNGJqTests.m
//  BNGJqTests
//
//  Created by bongole on 07/17/2014.
//  Copyright (c) 2014 bongole. All rights reserved.
//

#import "BNGJq.h"

SpecBegin(InitialSpecs)

describe(@"these will fail", ^{
/*
    it(@"can do maths", ^{
        expect(1).to.equal(2);
    });

    it(@"can read", ^{
        expect(@"number").to.equal(@"string");
    });
    
    it(@"will wait and fail", ^AsyncBlock {
        
    });
 */
});

describe(@"these will pass", ^{
    
    it(@"can search wellformed json", ^{
        NSString *json = @"{\"a\": [ {\"b\": 1 }, {\"b\": 2 }, {\"b\": 3 } ]}";
        
        BNGJq *jq = [[BNGJq alloc] initWithJSONString:json];
        NSMutableArray *arr = [@[] mutableCopy];
        bool r = [jq search:@".a[]" block:^(NSDictionary *d) {
            [arr addObject:d];
        }];
        
        expect(r).to.equal(YES);
        expect(arr[0][@"b"]).to.equal(1);
        expect(arr[1][@"b"]).to.equal(2);
        expect(arr[2][@"b"]).to.equal(3);
    });
    
    it(@"can't search broken json", ^{
        NSString *json = @"\"a\": [ {\"b\": 1 }, {\"b\": 2 }, {\"b\": 3 } ]}";
        
        BNGJq *jq = [[BNGJq alloc] initWithJSONString:json];
        bool r = [jq search:@".a[]" block:^(NSDictionary *d) {
        }];
        
        expect(r).to.equal(NO);
        expect(jq.error).toNot.equal(nil);
    });
});

SpecEnd
