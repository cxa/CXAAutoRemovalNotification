//
//  NSObject+CXAAutoRemovalNotification.h
//
//  Created by CHEN Xian’an on 12/22/14.
//  Copyright (c) 2014 CHEN Xian’an <xianan.chen@gmail.com>. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (CXAAutoRemovalNotification)

- (void)cxa_addObserverForName:(NSString *)name object:(id)obj queue:(NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *note))block;
- (void)cxa_addObserverForName:(NSString *)name usingBlock:(void (^)(NSNotification *note))block;


@end
