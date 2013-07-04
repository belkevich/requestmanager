//
//  ABRequestFactorySpec.mm
//  RequestManagerSpec
//
//  Created by Alexey Belkevich on 3/31/13.
//  Copyright (c) 2013 okolodev. All rights reserved.
//

#import "ABRequestFactory.h"
#import "ABRequestOptions.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(RequestFactory)


describe(@"Request factory", ^
{
    __block NSString *path = nil;
    __block ABRequestFactory *factory = nil;

    beforeEach(^
               {
                   path = [[NSString alloc] initWithFormat:@"http://test.com"];
                   factory = [[ABRequestFactory alloc] init];
               });

    afterEach(^
              {
                  [path release];
                  [factory release];
              });

    it(@"should create GET-request", ^
    {
        NSMutableURLRequest *request = [factory createGETRequest:path];
        [request.URL absoluteString] should equal(path);
        request.HTTPMethod should equal(@"GET");
        request.HTTPBody should be_nil;
    });

    it(@"should create POST-request", ^
    {
        NSData *data = [NSData data];
        NSMutableURLRequest *request = [factory createPOSTRequest:path body:data];
        [request.URL absoluteString] should equal(path);
        request.HTTPMethod should equal(@"POST");
        request.HTTPBody should equal(data);
    });

    it(@"should create PUT-request ", ^
    {
        NSData *data = [NSData data];
        NSMutableURLRequest *request = [factory createPUTRequest:path body:data];
        [request.URL absoluteString] should equal(path);
        request.HTTPMethod should equal(@"PUT");
        request.HTTPBody should equal(data);
    });

    it(@"should can create DELETE-request", ^
    {
        NSMutableURLRequest *request = [factory createDELETERequest:path];
        [request.URL absoluteString] should equal(path);
        request.HTTPMethod should equal(@"DELETE");
        request.HTTPBody should be_nil;
    });
});

describe(@"Request factory options", ^
{
    __block ABRequestOptions *options = nil;
    __block ABRequestFactory *factory = nil;

    beforeEach(^
               {
                   options = [[ABRequestOptions alloc] init];
                   options.basePath = @"http://test.com/";
                   options.timeout = 10.f;
                   options.cookies = NO;
                   options.cache = NSURLRequestReturnCacheDataDontLoad;
                   options.headers = @{@"header" : @"header value"};
                   factory = [[ABRequestFactory alloc] init];
                   factory.options = options;
               });

    afterEach(^
              {
                  [options release];
                  [factory release];
              });

    it(@"should add path after base path", ^
    {
        NSMutableURLRequest *request = [factory createGETRequest:@"path"];
        [request.URL absoluteString] should equal(@"http://test.com/path");
    });

    it(@"should replace invalid URL symbols", ^
    {
        NSMutableURLRequest *request = [factory createGETRequest:@" path "];
        [request.URL absoluteString] should equal(@"http://test.com/%20path%20");
    });

    it(@"should throw exception on invalid path", ^
    {
        options.basePath = nil;
        ^{
            [factory createGETRequest:nil];
        } should raise_exception;
    });

    it(@"should set timeout", ^
    {
        NSMutableURLRequest *request = [factory createGETRequest:@"path"];
        request.timeoutInterval should equal(options.timeout);
    });

    it(@"should set cookies handling", ^
    {
        NSMutableURLRequest *request = [factory createGETRequest:@"path"];
        request.HTTPShouldHandleCookies should equal(options.cookies);
    });

    it(@"should set cache policy", ^
    {
        NSMutableURLRequest *request = [factory createGETRequest:@"path"];
        request.cachePolicy should equal(options.cache);
    });

    it(@"should set HTTP headers", ^
    {
        NSMutableURLRequest *request = [factory createGETRequest:@"path"];
        request.allHTTPHeaderFields should equal(options.headers);
    });
});

SPEC_END