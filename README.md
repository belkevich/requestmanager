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
Add `<request manager directory>` to your XCode project. 
Then add `SystemConfiguration.framework` to project `Target` -> `Build phases` -> `Link Binary With Libraries`

# Using
## Send request with delegate
Sending request with delegate is an better way to manage requests. Because source code looks clear.
You should use it in most cases.
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

## Send request with blocks
It looks shorter but code isn't as clear as with delegate. Also beware of retain cycles when using
`self` in blocks.
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

## Cancel request
Request will be removed from requests queue. Connection will be dropped if it runs
```objective-c
[request cancelRequest];
```
