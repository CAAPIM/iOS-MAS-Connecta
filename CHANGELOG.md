# Version 1.9.10

### Bug fixes
None.

### New features
None.

# Version 1.9.00

### Bug fixes
None.

### New features
None.

# Version 1.8.00

### Bug fixes
None.

### New features
None.

# Version 1.7.10

### Bug fixes
None.

### New features
None.

# Version 1.7.00

### Bug fixes
None.

### New features
None.

# Version 1.6.10

### Bug fixes
- `MASMQTTClient` was unable to establish MQTT connection if the server presents a chain of certificates and the `msso_config.json` file contains only leaf certificate. The Mobile SDK now properly establishes MQTT connection with leaf certificate only in the configuration file. [US436059]

### New features
None.

# Version 1.6.00

### Bug fixes
- `MASMQTTClient` was unable to reestablish an MQTT connection when the user logged out, and then logged in with a different account. The Mobile SDK now properly handles session changes for the MQTT connection. [US408725]
- The Mobile SDK MQTT connection was unable to establish a mutual SSL connection with a public CA certificate. The Mobile SDK can now establish mutual SSL with a public CA certificate when the **entire certificate chain** is exported in a JSON configuration. [US399506]
- When parsing the payload of an MQTT message in an array format, the Mobile SDK threw an exception. The Mobile SDK now properly parses the message payload. [DE333766]

### New features
None.

# Version 1.5.00

NOTE: From this version on the frameworks changed to Dynamic instead of Static library

### Bug fixes
- Enhanced Pub/Sub and Messaging callback and error message. [US317131]

### New Features
- The SDK supports dynamic framework. All you need to do is update your Xcode settings. [US367604]

# Version 1.4.00

### Bug fixes
- SDK was not returning an error when unsubscribing the topic if there is no network connection. . [DE272675]
- SDK did not handle wildcarding when subscribing/unsubscribing the topic. [US299604]

# Version 1.3.01

### Bug fixes
- Fixed a bug where MASConnecta framework fails to parse the message payload that is not JSON format. [DE255873]
- Removed NSAssertion to validate parameters and replaced with proper NSError return. [US263636]

### New features

# Version 1.2.03

- Release tag to align with MASFoundation framework.
- ***No fixes for this framework***

### New features

# Version 1.2.01

### Bug fixes
 
- The /error topic message that was sent from MAG no longer impacts the SDK. [MCT-433]
- The parameter validation failed to validate nil object. [MCT-435]
- Version number and version string returend incorrect values. [MCT-437]
- Removed unsupported interfaces in MASUser to send a message to device and group. [MCT-403]

### New features

None.

### Deprecated methods

None. 


# Version 1.2.00

### Bug fixes

- .

### New features

- .

### Deprecated methods

- .


 [mag]: https://docops.ca.com/mag
 [mas.ca.com]: http://mas.ca.com/
 [docs]: http://mas.ca.com/docs/
 [blog]: http://mas.ca.com/blog/

 [releases]: ../../releases
 [contributing]: /CONTRIBUTING.md
 [license-link]: /LICENSE

