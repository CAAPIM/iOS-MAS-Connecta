# Version 4.0.00

### Bug fixes
- Fixes the issue where SDK was not returning any error while unsubscribing the topic if there is no network connection. [DE272675]
- Fixes the issue where SDK was not able to handle wildcard while subscribing/unsubscribing the topic. [US299604]

# Version 1.3

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

