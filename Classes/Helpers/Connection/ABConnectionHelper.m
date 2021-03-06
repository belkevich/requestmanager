//
//  ABConnectionHelper.m
//  Request Manager
//
//  Created by Alexey Belkevich on 12/30/12.
//  Copyright (c) 2012 Okolodev. All rights reserved.
//

#import "ABConnectionHelper.h"


@implementation ABConnectionHelper

#pragma mark -
#pragma mark main routine

- (id)initWithRequest:(NSURLRequest *)aRequest
             delegate:(NSObject <ABConnectionDelegate> *)aDelegate
{
    self = [super init];
    if (self)
    {
        request = aRequest;
        delegate = aDelegate;
    }
    return self;
}

- (void)dealloc
{
    [self connectionDataRelease];
}

#pragma mark -
#pragma mark actions

- (void)start
{
    [self connectionDataRelease];
    NSLog(@"%s Sending Request:\n%@\n%@", __func__, [request.URL absoluteString],
          [request allHTTPHeaderFields]);
    connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)stop
{
    [self connectionDataRelease];
}

#pragma mark -
#pragma mark NSURLConnection delegate methods

- (void)connection:(NSURLConnection *)aConnection didReceiveResponse:(NSURLResponse *)aResponse
{
    receivedData = [[NSMutableData alloc] init];
    receivedResponse = (NSHTTPURLResponse *)aResponse;
    NSLog(@"%s Received response:\n%@", __func__, [[receivedResponse allHeaderFields] description]);
}

- (void)connection:(NSURLConnection *)aConnection didReceiveData:(NSData *)data
{
	data ? [receivedData appendData:data] : NSLog(@"%s Received empty data", __func__);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection
{
    NSString *dataString = [[NSString alloc] initWithData:receivedData
                                                 encoding:NSUTF8StringEncoding];
    NSLog(@"%s Received:\n%@", __func__, dataString ? dataString : @"binary data");
    NSData *data = receivedData;
    NSHTTPURLResponse *response = receivedResponse;
	[self connectionDataRelease];
    [delegate connectionDidReceiveData:data response:response];
}

- (void)connection:(NSURLConnection *)aConnection didFailWithError:(NSError *)error
{
	NSLog(@"%s Connection failed with error:\n%@\n%@", __func__, [error localizedDescription],
          [error localizedFailureReason]);
	[self connectionDataRelease];
    [delegate connectionDidFail:error];
}

#pragma mark -
#pragma mark private

- (void)connectionDataRelease
{
    [connection cancel];
    connection = nil;
    receivedResponse = nil;
    receivedData = nil;
}

@end
