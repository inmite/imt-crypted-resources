Mobile library and tool for encrypted resources
===============================================

This is a project for utility library and tools for resource encryption on iOS. It
basically encrypts resources using a XOR function with a key provided in the binary,
drawing resources unreadable for a regular users or modarate attackers.

How to use 
----------

The project contains a simple tool written in Java that can be used to encrypt or decrypt
files, as such:

    $ java -jar crypted-resource-java-tool.jar gen 16
    ffa17e84f481201844724a4e1c1b981e
    
    $ java -jar crypted-resource-java-tool.jar xor input.png output.cri ffa17e84f481201844724a4e1c1b981e

The command above stores the crypted version of <code>input.png</code> to the file
<code>output.cri</code>, using <code>ffa17e84f481201844724a4e1c1b981e</code> as the key
for encryption.

Also, there is a sample iOS project that demonstrates the use of the client side library.
All library files are under <code>Lib/CryptedResources</code> groupd in the project. To
use the library, just drag and drop the <code>Lib/CryptedResources</code> group to your
project.

Basically, you need to visit <code>CryptedConstants.h</code> file and put the generated
key there:

    #define DEFAULT_KEY @"ffa17e84f481201844724a4e1c1b981e"

From this moment, you are able to call the specific methods on <code>UIImage</code>,
<code>NSString</code> and <code>NSData</code>, for example:

    #import "CryptedResources.h"
    
    // ...
    
    self.image = [UIImage cryptedImageNamed:@"output.cri"];
    self.text  = [NSString cryptedStringWithContentsOfFile:@"crypted_text.crs"
                                                  encoding:NSUTF8StringEncoding];
    self.data  = [NSData cryptedDataWithData:originalData];
    
Alternatively, you can provide an individual key (in hexadecimal string format) for each
of the resources, for example as such:

    self.data  = [NSData cryptedDataWithData:originalData symKey:@"1234567890abcdef"];

See the header files for more detailed information on what methods are available.

Licence
-------

This software is shared under the IHL ("Inmite Happiness License"), which is derived from
[MIT license](http://en.wikipedia.org/wiki/MIT_License "MIT License at Wikipedia")
completely, except for you have to follow [@inmite](http://twitter.com/inmite) if you are
[happy](http://en.wikipedia.org/wiki/Happiness) using the software of matter.

F.A.Q
-----

**Why do I need to encrypt bundle resources in the mobile app?**

There might be several reasons for resource encryption. The first one is preventing
someone with moderate skills from stealing them from your application. Designing icons and
app graphics is hard - stealing them is unfair.

There are also more advanced reasons for resource encryption. If you write an application
which uses an image wizard as an introduction, replacing image might instruct a user to
perform an incorrect task (such as call a malicious number). These types of attacks play
role in application with high security concerns, such as mobile banking or insurance apps.