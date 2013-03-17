![Alt text](/images/logo.png)

#Sociocast iOS Library

##Overview
The Sociocast iOS Librayr is a wrapper library for the Sociocast REST API. See the [Sociocast Developers Center](http://www.sociocast.com/dev-center/) for more details.


Make sure to link the following libraries by going to the project editor and selecting your application target. Select the Build Phases tab and expand the "Link Binary with Libraries" section. Click the plus button and choose the following two libraries to add to the phase:
* SystemConfiguration
* MobileCoreServices

#### Ensure that the necessary #import statements are in your Prefix.pch file.
````
#ifdef __OBJC__
    #import <Foundation/Foundation.h>
    #import <SystemConfiguration/SystemConfiguration.h>
    #import <MobileCoreServices/MobileCoreServices.h>
#endif
````

If your application has difficulty finding the Sociocast Wrapper Library, ensure that you've set the User Header Search Paths for your project. Open the Project Editor and select your application target. Select the Build Settings tab and search for "User Header Search Paths".

#### To update from Testing Environment to Production, in SCAPIClient.h, update:
````
#define SOCIOCAST_BASEURL @"http://api-sandbox.sociocast.com/"
````
to
````
#define SOCIOCAST_BASEURL @"http://api.sociocast.com/"
````

#### To update API Version, in SCAPIClient.h, update:
````
#define SOCIOCAST_VERSION @"1.0"
````
The Sociocast REST API Wrapper uses [AFNetworking](https://github.com/AFNetworking/AFNetworking), which is included in the repository.

#### XCode Appledoc documentation
To generate Appledoc-style documentation and auto-install in XCode, use [Appledoc](http://gentlebytes.com/appledoc/).
The following command will run and install documentation for the Sociocast REST API in XCode:
````
appledoc Appledoc.plist .
````
