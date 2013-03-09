Mobile library and tool for encrypted resources
===============================================

This is a project for utility library and tools for resource encryption on iOS. It
basically encrypts resources using a XOR function with a key provided in the binary,
drawing resources unreadable for a regular users or modarate attackers.

The project contains a simple tool written in Java that can be used to encrypt or decrypt
files, as such:

$ java -jar crypted-resource-java-tool.jar gen 16
2PoH6pYMeTeVGo7K0KLBEQ==

$ java -jar input.png output.cri 2PoH6pYMeTeVGo7K0KLBEQ==

Also, there is a sample iOS project that demonstrates the use of the client side library.

F.A.Q
-----

*Why do I need to encrypt bundle resources in the mobile app?*

There might be several reasons for resource encryption. The first one is preventing
someone with moderate skills from stealing them from your application. Designing icons and
app graphics is hard - stealing them is unfair.

There are also more advanced reasons for resource encryption. If you write an application
which uses an image wizard as an introduction, replacing image might instruct a user to
perform an incorrect task (such as call a malicious number). These types of attacks play
role in application with high security concerns, such as mobile banking or insurance apps.