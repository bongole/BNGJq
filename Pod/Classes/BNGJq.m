//
//  BNGJq.m
//  Pods
//
//  Created by bongole on 7/17/14.
//
//

#import "BNGJq.h"
#include <jq.h>

static void jq_err_func(void *p, jv msg){
    BNGJq *this = (__bridge BNGJq *)(p);
    const char *str = jv_string_value(msg);
    this.error = [[NSString alloc] initWithUTF8String:str];
}

@interface BNGJq()
@property NSData *src;
@end

#define BUFSIZE 1024

@implementation BNGJq

- (id)initWithJSONString:(NSString *)src
{
    self = [super init];
    _src = [src dataUsingEncoding:NSUTF8StringEncoding];
    _error = nil;
    
    return self;
}

- (id)initWithJSONData:(NSData *)src
{
    self = [super init];
    _src = src;
    _error = nil;
    
    return self;
}

- (id)toJSON:(NSString*)src
{
    NSString *d = [NSString stringWithFormat:@"[%@]", src];
    NSData *data = [d dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *a = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return a[0];
}

- (bool)search:(NSString*)pattern block:(void (^)(id))iteratorBlock
{
    jq_state *jq_state = jq_init();
    jq_set_error_cb(jq_state, jq_err_func, (__bridge void *)(self));
    
    if( !jq_compile(jq_state, [pattern cStringUsingEncoding:NSUTF8StringEncoding]) ){
        _error = @"pattern compile error";
        jq_teardown(&jq_state);
        return NO;
    }
    
    struct jv_parser *parser = jv_parser_new(0);
    
    jv_parser_set_buf(parser, (const char*)[_src bytes], (int)[_src length], 0);
    jv value;
    for (value = jv_parser_next(parser);
         jv_is_valid(value);
         value = jv_parser_next(parser)
         ){
        
        jq_start(jq_state, value, 0);
        jv result;
        for (result = jq_next(jq_state);
             jv_is_valid(result);
             result = jq_next(jq_state)) {
            jv dumped = jv_dump_string(result, 0);
            NSString *r = [[NSString alloc] initWithCString:jv_string_value(dumped) encoding:NSUTF8StringEncoding];
            iteratorBlock([self toJSON:r]);
        }
        
        jv_free(result);
    }
    
    if( jv_invalid_has_msg(jv_copy(value)) ){
        jv msg = jv_invalid_get_msg(value);
        self.error = [[NSString alloc] initWithCString:jv_string_value(msg) encoding:NSUTF8StringEncoding];
        jv_free(msg);
    }
    else{
        jv_free(value);
    }
    
    if( self.error != nil ){
        return NO;
    }
    
    jv_parser_free(parser);
    jq_teardown(&jq_state);
    
    return YES;
}

@end
