Lightweight and extensible request manager for iOS/OS X
============

## About
Request manager is a simple way to run network requests. It requires only instance of NSURLRequest (or NSMutableURLRequest). All requests are stored in the queue. Request manager pulls the head request from queue and run it. And so on until queue is empty.

---

## Installation
The recommended way to install **Request Manager** in your project is via [CocoaPods](http://cocoapods.org/). It's very easy. Just add `requestmanager` pod to your Podfile

---

## Using
#### Send request with blocks
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
    }                     failBlock:^(NSError *error)
    {
        // handle error
        ...         
    }];
    ...
}

```
###### Note
> Beware of retain cycles when using `self`

---

#### Send request with delegate
```objective-c
#import "NSURLRequest+RequestManager.h"
...
- (...
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

###### Note for manual memory of management
> Request delegate isn't retained by request manager. It means that if you don't sure that request completes before delegate deallocated you must cancel request 

---

#### Parse received data
If received data needs to be parsed asynchronously, use `start with parsing block`
Here is example of JSON-response parsing
```objective-c
...
NSURLRequest *request = [NSURLRequest requestWithURL:someURL];
[request startWithCompletedBlock:^(NSHTTPURLResponse *response, id result)
{
    // do something with parse JSON-object
    ...
}                    failedBlock:^(NSError *error)
{
    // handle error
    ...
}                   parsingBlock:^id(NSData *data)
{
    // parse data to JSON object
    id response = [NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingMutableContainers
                                                    error:nil];
    return response;
}];
```

And the same with `delegate`
```objective-c
...
NSURLRequest *request = [NSURLRequest requestWithURL:someURL];
[request startWithDelegate:self
              parsingBlock:^id(NSData *data)
{
    // parse data to JSON object
    id response = [NSJSONSerialization JSONObjectWithData:data
                                                  options:NSJSONReadingMutableContainers
                                                    error:nil];
    return response;
}];
```
###### Warning
> All actions in block will run in background thread! Try to avoid calling objects of main thread. Otherwise you should synchronize calls

---

#### Cancel request
Request will be removed from requests queue. Connection will be dropped if it runs
```objective-c
[request cancelRequest];
```

---

#### Create request
It's easy to create request with `ABRequestFactory`
```objective-c
ABRequestFactory *factory = [ABRequestFactory requestFactory];
NSMutableURLRequest *requestGET = [factory createGETRequest:path];
NSMutableURLRequest *requestPOST = [factory createPOSTRequest:path data:data];
NSMutableURLRequest *requestPUT = [factory createPUTRequest:path data:data];
NSMutableURLRequest *requestDELETE = [factory createDELETERequest:path];
NSMutableURLRequest *requestCustom = [factory createRequest:path method:@"custom_method" data:data];
```

###### Note
> Use `[ABRequestFactory sharedInstance]` if you don't want instantiate it every time

---

#### Request options
Create requests with custom options: base host path, request timeout interval, should handle cookies, cache policy, HTTP headers
```objective-c
ABRequestFactory *factory = [ABRequestFactory requestFactory];
factory.options.basePath = @"https://api.my-service.com/";
factory.options.timeout = 30.f;
factory.cookies = NO;
factory.cache = NSURLRequestReturnCacheDataDontLoad;
factory.headers = @{@"Content-Type", @"application/json"};
NSMutableURLRequest *request = [factory createGETRequest:@"news"]
```

###### Note
> Default `ABRequestFactory` options are same as default `NSURLRequest` options

---

## Advanced using

Here are some advanced features of `ABRequestManager`
#### Request wrapper
Every request in **Request Manager** wrapped into `ABRequestWrapper`. Sometimes it's better to use wrapper instead of raw request.
```objective-c
ABRequestWrapper *wrapper = [[ABRequestWrapper alloc] initWithURLRequest:request];
// set completed and failed blocks
[wrapper setCompletedBlock:^(ABRequestWrapper *wrapper, id result)
{
    // do some completion actions
    ...
}              failedBlock:^(ABRequestWrapper *wrapper)
{
    // show error
    ...
}];
// set parsing block
[wrapper setParsingBlock:^id(ABRequestWrapper *wrapper)
{
    id result = nil;
    // do parsing
    ...
    return result;
}];

```

---

#### Request manager instance
You aren't limited to only one `sharedInstance`. You can use custom instance of `ABRequestManager`. But in that case, you should use `ABRequestWrapper` instead of `NSMutableURLRequest`
```objective-c
ABRequestManager *manager = [[ABRequestManager alloc] init];
ABRequestWrapper *wrapper = [[ABRequestWrapper alloc] initWithURLRequest:request];
[wrapper setCompletedBlock:^(ABRequestWrapper *wrapper, id result)
{
    MyModel *model = [[MyModel alloc] initWithData:wrapper.data];
    [self updateViewWithModel:model];
}              failedBlock:^(ABRequestWrapper *wrapper)
{
    [UIAlertView showError:wrapper.error.localizedDescription];
}];
[manager addRequestWrapper:wrapper];

```

--- 

#### Request manager queue
Here is good example of complex task with easy solution. Imagine. Application deal with API that requires access via token. When token is expired it returns HTTP-code [401](http://en.wikipedia.org/wiki/List_of_HTTP_status_codes#4xx_Client_Error). And if application received this code, it should send 'get access token' request. And then retry last request.
```objective-c
ABRequestWrapper *wrapper = [[ABRequestWrapper alloc] initWithURLRequest:request];
[wrapper setCompletedBlock:^(ABRequestWrapper *wrapper, id result)
{
    if (wrapper.response.statusCode == 200)
    {
        // everything is OK, do something with result 
        ...
    }
    else if (wrapper.response.statusCode == 401)
    {
        // send 'get access token'
        ABRequestWrapper *getTokenWrapper= [self getAccessTokenRequestWrapper];
        [[ABRequestManager sharedInstance] addRequestWrapperFirst:getTokenWrapper];
        // retry current requeset
        [[ABRequestManager sharedInstance] addRequestWrapper:wrapper];
    }
    else
    {
        // handle other status codes
        ...
    }
}              failedBlock:^(ABRequestWrapper *wrapper)
{
    [UIAlertView showError:wrapper.error.localizedDescription];
}];

```

---

#### Request reachability
First of all you can set host which reachability should be checked.
```objective-c
...
{
    ...
    [[ABRequestManager sharedInstance] setReachabilityCheckHost:@"https://api.myhost.com"];
    ...
}
...
```

###### Note
> Default reachability check host is "http://google.com"

---

Sometimes it can be useful to restart unfinished request when internet connection become available. But when host unreachable, request will be removed from queue. To avoid this you can restart request by implementing optional method of `ABRequestDelegate`
```objective-c
- (void)requestWrapperDidBecomeUnreachable:(ABRequestWrapper *)wrapper
{    
    // restarting request
    [[ABRequestManager sharedInstance] addRequestWrapperFirst:wrapper];
}
```
###### Note
> If you don't implement this method delegate will receive `requestWrapper:didFail:` on internet connection lost

---

## Specs
![Build status](https://api.travis-ci.org/belkevich/requestmanager.png) 

---

## Updates
Stay tuned with **Request Manager** updates on [@okolodev](https://twitter.com/okolodev)
