Request manager for iOS
============
---
# About
Request manager is a simple way to run network requests. It requires only instance of NSURLRequest (or NSMutableURLRequest).
All requests are stored in the queue. Request manager pulls the head request from queue and run it. And so on until queue is empty.

# Installation
## Add as git submodule
```  
cd <project source directory>
git submodule add https://github.com/belkevich/requestmanager.git <request manager directory>
git submodule update --init --recursive
```
Add `<request manager directory>` to your XCode project. Then add `SystemConfiguration.framework` to project `Target` -> `Build phases` -> `Link Binary With Libraries`

# Using
## Send request with delegate
Sending request with delegate is an better way to manage requests. Because source code looks clear. You should use it in most cases.
```objective-c
#import "NSURLRequest+RequestManager.h"
...
- ...
{
    ...
    NSURLRequest *request = [NSURLRequest requestWithURL:someURL];
    [request startWithDelegate:self];
    ...
}
...
- (void)request:(NSURLRequest *)request didReceiveResponse:(id)response
{
    // do some response routine
    ...
}
...
- (void)request:(NSURLRequest *)request didReceiveError:(NSError *)error
{
    // handle error
    ...
}
...
```
### Note
> Request delegate isn't retained by request manager. It means that if you don't sure that request completes before delegate deallocated you must cancel request 

## Send request with blocks
It looks shorter but code isn't as clear as with delegate.
```objective-c
#import "NSURLRequest+RequestManager.h"
...
- ...
{
    ...
    NSURLRequest *request = [NSURLRequest requestWithURL:someURL];
    [request startWithCompleteBlock:^(NSHTTPURLResponse *response, id data)
    {
        // do some response routine
        ...
    }                     failBlock:^(NSError *error, BOOL isUnreachable)
    {
        // handle error
        ...         
    }];
    ...
}

```
### Note
> Beware of retain cycles when using `self`

## Parse received data
If received data needs to be parsed asynchronously, use `parsing block`
```objective-c
...
NSURLRequest *request = [NSURLRequest requestWithURL:someURL];
[request startWithDelegate:self
              parsingBlock:^id(NSData *data)
{
    // do some parsing on data
    ...
}];
```
### Note
> All actions in block will run in background thread! Try to avoid calling objects used in main thread. Otherwise you should synchronize calls

## Cancel request
Request will be removed from requests queue. Connection will be dropped if it runs
```objective-c
[request cancelRequest];
```

## Internet reachability
Sometimes it can be useful to restart unfinished request when internet connection become available. But when internet lost, request will be removed from queue. To avoid this you can restart request by implementing optional method of `ABRequestDelegate`
```objective-c
...
- (void)requestDidBecomeUnreachable:(NSURLRequest *)request
{
    // restart request
    // it will be added to the end of requests queue
    [request startWithDelegate:self];
    ...
}
```
### Note
> If you don't implement this method delegate will receive `request:didReceiveError:` on internet connection lost

## Request creation
It's easy to create request with `ABRequestFactory`
```objective-c
ABRequestFactory *factory = [ABRequestFactory requestFactory];
NSMutableURLRequest *requestGET = [factory createGETRequest:url];
NSMutableURLRequest *requestPOST = [factory createPOSTRequest:url data:data];
NSMutableURLRequest *requestPUT = [factory createPUTRequest:url data:data];
NSMutableURLRequest *requestDELETE = [factory createDELETERequest:url];
NSMutableURLRequest *requestCustom = [factory createRequest:url method:@"method" data:data];
```

# Request manager specs
[Here is BDD specs](https://github.com/belkevich/requestmanager-spec) 