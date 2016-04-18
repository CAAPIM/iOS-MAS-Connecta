# MASConnecta

[![Build Status](https://travis-ci.org/mobile-web-messaging/MQTTKit.svg)](https://thesource.l7tech.com/thesource/Matterhorn/client-sdk/ios/trunk/Connecta)

The MASConnecta framework is the Messaging solution of the MAS SDK. It extends classes from the MASFoundation for real time messaging features. MASConnecta lets you create messaging applications and pub/sub solutions.

This framework is part of the **iOS CA Mobile App Services SDK.** Other frameworks in the SDK include:

- [MASFoundation](https://github-isl-01.ca.com/MAS/iOS-MAS-Foundation)
- [MASIdentityManagement](https://github-isl-01.ca.com/MAS/iOS-MAS-IdentityManagement)
- [MASStorage](https://github-isl-01.ca.com/MAS/iOS-MAS-Storage)

MASConnecta uses the following third-party libraries:

-  [Mosquitto 1.2.3](http://mosquitto.org) (MQTT protocol)


## Install By Manually Importing the Framework

1. Open your project in Xcode.
2. On your ```Project target```, go to the ```General``` tab and import the framework in the ```Embedded Binaries``` section.


## Usage

MASConnecta can be used in two different ways:

Manually - The framework expose objects that allow expert developers to manually create your own MQTTClient object, optionally establish connection with a host using SSL/TLS, set up login and password, and subscribe or publish direct to a topic.

Automatically - After MASConnecta is added to a project, some objects from the MASFoundation framework automatically displays messaging methods. This saves development time and makes the code cleaner. You write just a few lines of code, and the framework automatically handles all of the settings for the connection to the server. 

Import the `MASConnecta.h` header file to any class that you want to use or to the `.pch` file if your project has one.

```
#import <MASConnecta/MASConnecta.h>
```


###Sending Messages

```
//Authenticated users have the ability to send messages to another user
MASUser *myUser = [MASUser currentUser];

MASUser *userB = Some user retrieved from the server

[myUser sendMessage:@"Hello World" toUser:userB];

```

```
//Authenticated users have the ability to send messages to a group
MASUser *myUser = [MASUser currentUser];
[myUser sendMessage:@"Hello World" toGroup:@"group123"];

```

```
//Authenticated users have the ability to send messages to a device
MASUser *myUser = [MASUser currentUser];

MASDevice *deviceB = Some device retrieved from the server

[myUser sendMessage:@"Hello World" toDevice:deviceB];

```

```
//Authenticated users have the ability to send messages to a topic
MASUser *myUser = [MASUser currentUser];
[myUser sendMessage:@"Hello World" toTopic:@"topic123"];

```

### Start Listening to Messages

Start listening to my messages

```
- (void)viewDidLoad
{
	//
	//Get the current authenticated user
	//
	MASUser *myUser = [MASUser currentUser];
	
    //
    //Listen to Messages sent to my User
    //
    [myUser startlisteningToMyMessages:^(BOOL success, NSError *error) {
        
        if (success) {
            
            NSLog(@"Success subscribing to myUser topic!");
        }
        else {
            
            NSLog(@"%@",error.localizedDescription);
        }
    }];
}

```

Start listening to messages from a specific topic 

```
- (void)viewDidLoad
{
	//
	//Get the current authenticated user
	//
	MASUser *myUser = [MASUser currentUser];
	
	//
	//Listen to Messages sent to a topic
	//
	[myUser startListeningToMessagesFromTopic:@"topic123" completion:nil];
}
```

Start listening to messages from a specific group

```
- (void)viewDidLoad
{
	//
	//Get the current authenticated user
	//
	MASUser *myUser = [MASUser currentUser];
	
	//
	//Listen to Messages sent to a topic
	//
	[myUser startListeningToMessagesFromGroup:@"group123" completion:nil];
}

```

### Stop Listening To Messages

Stop listening to my messages

```
- (void)viewDidLoad
{
	//
	//Get the current authenticated user
	//
	MASUser *myUser = [MASUser currentUser];
	
    //
    //Stop Listening to Messages sent to my User
    //
    [myUser stoplisteningToMyMessages:nil];
}

```

Stop listening to messages from a specific topic 

```
- (void)viewDidLoad
{
	//
	//Get the current authenticated user
	//
	MASUser *myUser = [MASUser currentUser];
	
	//
	//Stop Listening to Messages from topic
	//
	[myUser stopListeningToMessagesFromTopic:@"topic123" completion:nil];
}
```

Stop listening to messages from a specific group

```
- (void)viewDidLoad
{
	//
	//Get the current authenticated user
	//
	MASUser *myUser = [MASUser currentUser];
	
	//
	//Stop Listening to Messages from Group
	//
	[myUser stopListeningToMessagesFromGroup:@"group123" completion:nil];
}

```

###Handling Incoming Messages

Using Notifications

```
- (void)viewDidLoad
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didReceiveMessageNotification:)
                                                 name:MASConnectaOperationDidReceiveMessageNotification
                                               object:nil];
}
```

```
- (void)didReceiveMessageNotification:(NSNotification *)notification
{    
    //Get the Message Object from the notification
    MASMQTTMessage *newMessage = notification.object;   
}
```

