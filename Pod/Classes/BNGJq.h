//
//  BNGJq.h
//  Pods
//
//  Created by bongole on 7/17/14.
//
//

#import <Foundation/Foundation.h>

@interface BNGJq : NSObject
@property NSString *error;


- (bool)search:(NSString*)pattern block:(void (^)(id))iteratorBlock;
- (id)initWithJSONString:(NSString *)src;
- (id)initWithJSONData:(NSData *)src;

@end
