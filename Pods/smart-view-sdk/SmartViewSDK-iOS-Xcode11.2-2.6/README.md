# SmartViewSDK iOS APIs 

The iOS APIs provide methods and functionalities of the Smart View for iOS to users. With these APIs, we can communicate with Samsung Smart TV using an iOS device.

For more information, see the [Samsung Developers](http://developer.samsung.com/tv/develop/extension-libraries/smart-view-sdk/introduction/)

The swift API is used for mobile applications, to connect to SmartTV applications. 

## Jazzy Docs
API reference docs are [online API GUIDE](https://smartviewsdk.github.io/API-GUIDE/ios-api/docs/) and included  'docs'

## Introduction

To facilitate communication between a iOS mobile device and Samsung Smart TV, the Smart View provides API’s for discovery, launch and communicate processes.

> **iOS APIs are provided as a dynamic library framework which implies that the applications using the framework can be submitted in the App Store only if their deployment target is iOS 8.0 or higher.**


#### Steps:
##### 1. Discovery
    Discover compatible Samsung Smart TVs on your local network

##### 2. Launch
    Launch the installed app on TV

##### 3. Connect
    Connect and communicate with a TV application and other mobile devices


## Discovery
You can discover a compatible Samsung Smart TV on your network using the ServiceSearch class. The workflow is as follows :

- Start the Discovery Process.
- Listen for notifications indicating services add/removed or implementing a ServiceSearchDelegate.
- Stop the Discovery Process.


While discovering compatible TVs, you should display a list of discovered services to the user, allow them to select one and then communicate with the service selected. At any time you can get the list of the last discovered services.

### Code Snippet with Examples (Swift):<code>
	let serviceSearch = Service.search()
	init () {
    // The delegate is implemented as a weak reference
    serviceSearch.delegate = self
    serviceSearch.start()
	}

	// MARK: - ServiceSearchDelegate -

	func onServiceFound(service: Service) {
	    // Update your UI by using the serviceDiscovery.services array
	}
	
	func onServiceLost(service: Service) {
	    // Update your UI by using the serviceDiscovery.services array
	}
	
	// After the user connects to a device stop the search by calling
	serviceSearch.search( )</code> 
Alternatively, you can subscribe for notifications (Please unsubscribe when you are done).<code>

	var didFindServiceObserver: AnyObject? = nil
	var didRemoveServiceObserver: AnyObject? = nil

	func listenForNotifications()
	{
    didFindServiceObserver = NSNotificationCenter.defaultCenter().addObserverForName(MSDidFindService, object: serviceSearch, queue: NSOperationQueue.mainQueue( )) { (notification) -> Void in
        let serviceSearch = notification.object as? ServiceSearch
        let service = notification.userInfo["service"] as? Service
    }

    didRemoveServiceObserver = NSNotificationCenter.defaultCenter().addObserverForName(MSDidRemoveService, object: serviceSearch, queue: NSOperationQueue.mainQueue( )) { (notification) -> Void in
        let serviceSearch = notification.object as? ServiceSearch
        let service = notification.userInfo["service"] as? Service
    }
	}
</code>
If you want to use notifications, closures and the main queue for your notification you can use the equivalent  
convenience method call.

<code>	

	public func on(notificationName: String, performClosure: (NSNotification!) -> void) -> AnyObject
	public func off(observer: AnyObject)
</code>
On selecting a service from the list of available services, you can interact with the service to get additional  
information about the device or you can either start, stop, install, and retrieve information about applications.  
Both installed applications and cloud applications can be launched.

### BLE Device Discovery

SmartView framework supports discovery of Samsung devices via Bluetooth Low Energy in the surrounding area. BLE   
discovery allows user to see the list of available TVs that user can connect with. BLE discovery does not support  
retrieving the Service objects using Bluetooth currently.  

The following example demonstrates how to launch BLE discovery and get the discovered devices.  
Launch the search for BLE devices:
<code>

	let serviceSearch = Service.search()        
	serviceSearch.startUsingBLE()

Implement corresponding delegate method to handle the discovery events:
<code>

	func onFoundOnlyBLE(NameOfTV: String)
	{
    print("Found BLE device: \(NameOfTV)")
    // Update your UI...
	}
</code>

### Launch

Once you have a selected device or “service” , you can now interact with both installed TV apps and Cloud apps.  

<b>Working With Installed TV Apps</b>  
Before you can work with an installed TV app, you must first know the “ID” of the TV application you want to work  
with.If your TV app is still in development, you can use the folder name of your app as the id. Once the TV app  
 has been released into Samsung Apps, you must use the supplied app id.
 
There are four core functions for working with installed apps

 1. Service.createApplication (id: AnyObject, channelURI: String, args: [String:AnyObject]?) : Get reference to  
   your TV app by app ID
 2. application.start (completionHandler: ((success: Bool, error: NSError?) -> Void)?) : Launch the TV app
 3. application.stop (completionHandler: ((success: Bool, error: NSError?) -> Void)?) : Terminate the TV app
 4. application.install (completionHandler: ((success: Bool, error: NSError?) -> Void)?) : Install the TV app.

<code>

	let uri: NSURL = app.getConfig().getWebAppUri();
	let channelID: String = "com.samsung.multiscreen.helloworld"

	let msApplication = service.createApplication(uri, channelURI: channelID, args: nil)!
	msApplication.connectionTimeout = 5.0

	// Launch the application without connecting to it
	msApplication.start() { (success, error) -> Void in
    if success  {
        print("App started")
    } else {
        print("App cannot start: \(error)")
    }
	}
</code>

### Connect
You need to be connected to TV to communicate with any application. If you connect an application without calling  
start() method it will be launched automatically before connecting.
<code>

	let uri: NSURL = app.getConfig().getWebAppUri();
	let channelID: String = "com.samsung.multiscreen.helloworld"

	let msApplication = service.createApplication(uri, channelURI: channelID, args: nil)!
	msApplication.connectionTimeout = 5.0
	msApplication.connect(attrs) { (client, error) -> Void in
    if client != nil {
        print("App connected")
    } else {
        print("App cannot connect: \(error)")
    }
	}
</code>

### WoW (Wake on Wireless LAN)
1.How to get MAC Address:
<code>

    service!.getDeviceInfo(5, completionHandler:
    {
            (deviceInfo, error) -> Void in         

                let device = deviceInfo!["device"]

                let wifi = device!["wifiMac"]

    })
</code>

2.Wake up TV:

<code>
	Service.WakeOnWirelessLan(macAddr)
</code>

3.Wake up TV and connect:
<code>

	//Default timeout for connection is used Service.DEFAULT_WOW_TIMEOUT_VALUE:NSTimeInterval = 6
    
    Service.WakeOnWirelessAndConnect(macAddr, uri, completionHandler: {(service, error) -> Void in
            if(service != nil)
            {
            let url = NSURL(string: "http://dev-multiscreen-examples.s3-website-us-west-1.amazonaws.com/examples/helloworld/tv/")

            let app = service?.createApplication(url!, channelURI: "com.samsung.multiscreen.msf20", args: nil)

            app?.delegate = self

            app?.connect()
        }
    })

	//Connect using custom timeout
	//let timeout:NSTimeInterval = 12

      Service.WakeOnWirelessAndConnect(macAddr, uri, timeout, completionHandler: {(service, error) -> Void in
                 .....      
         })

</code>

## License ##

Copyright (c) 2017 Samsung Electronics

Permission is hereby granted, free of charge, to any person obtaining a copy  
of this software and associated documentation files (the "Software"), to deal  
in the Software without restriction, including without limitation the rights  
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell  
copies of the Software, and to permit persons to whom the Software is  
furnished to do so, subject to the following conditions:  

The above copyright notice and this permission notice shall be included in  
all copies or substantial portions of the Software.  

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR  
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,  
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE  
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER  
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,  
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN  
THE SOFTWARE.
