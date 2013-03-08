Sociocast
=========
A wrapper class for the Sociocast REST API.

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


#### To update from Testing Environment to Production, in SCAPIClient.h, update:
````
#define SOCIOCAST_BASEURL @"http://api-sandbox.sociocast.com/"
````

#### To update API Version, in SCAPIClient.h, update:
````
#define SOCIOCAST_VERSION @"1.0"
````
