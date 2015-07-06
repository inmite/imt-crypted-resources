
/*
  main.m
  pngcrypt

  Created by Nikolay Kapustin on 18.06.15.
  Copyright (c) 2015 Nikolay Kapustin. All rights reserved.

 The MIT License (MIT)

 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 documentation files (the "Software"), to deal in the Software without restriction, including without limitation the
 rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to
 permit persons to whom the Software is furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the
 Software.
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE
 WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
 COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
 OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import <Foundation/Foundation.h>
#import "CryptedResources.h"

void printHelp();
BOOL isReachFile(NSString* fileName);
BOOL cryptFile(NSString* sourceFileName, NSString* destinationFileName, NSString *key);

int main(int argc, const char * argv[]) {
	@autoreleasepool {
		NSArray* args = [[NSProcessInfo processInfo] arguments];
		if ([args count] == 1 || [args count] > 5) {
			printHelp();
			return 1;
		}
		if ([[args[1] lowercaseString] isEqualToString:@"help"]) {
			printHelp();
		}
		else{
			NSString *keyFile = args[1];
			NSError *error;
			NSString *key = [NSString stringWithContentsOfFile:keyFile encoding:NSUTF8StringEncoding error:&error];
			if (!key) {
				printf("%s", [@"Sorry, unable to load key file." UTF8String]);
				return 1;
			}
			NSString *newFileExtention = @"CRI";
			NSString *sourcePathFolder = [[NSFileManager defaultManager] currentDirectoryPath];
			NSString *destinationPathFolder = [[NSFileManager defaultManager] currentDirectoryPath];
			
			if ([args count] > 2){
				NSString* sourcePathFolder_Verify = args[2];
				if (![sourcePathFolder_Verify isEqualToString:[NSString string]] || isReachFile(sourcePathFolder_Verify))
					sourcePathFolder = sourcePathFolder_Verify;
			}
			
			if ([args count] > 3){
				NSString* destinationPathFolder_Verify = args[3];
				if (![destinationPathFolder_Verify isEqualToString:[NSString string]] || isReachFile(destinationPathFolder_Verify))
					destinationPathFolder = destinationPathFolder_Verify;
			}
			if ([args count] > 4){
				if ([[args[4] lowercaseString] isEqualToString:@"png"]){
					printf("%s", [@"Sorry, but new extension parameter will be ignored. Use other than PNG." UTF8String]);
					return 1;
				}
				else
					newFileExtention = args[4];
			}
			
			NSFileManager *localFileManager=[[NSFileManager alloc] init];
			NSDirectoryEnumerator *dirEnum = [localFileManager enumeratorAtPath:sourcePathFolder];
			
			NSString *file;
			while ((file = [dirEnum nextObject])) {
				if ([[[file pathExtension] lowercaseString] isEqualToString: @"png"]) {
					// process the file
					NSString *newFileName = [[file stringByDeletingPathExtension] stringByAppendingPathExtension:newFileExtention];
					cryptFile([sourcePathFolder stringByAppendingPathComponent:file], [destinationPathFolder stringByAppendingPathComponent:newFileName], key);
				}
			}
		}
	}
    return 0;
}

BOOL cryptFile(NSString* sourceFileName, NSString* destinationFileName, NSString *key){
	NSError *err;
	NSData *imageData = [NSData dataWithContentsOfFile:sourceFileName options:NSDataReadingUncached error:&err];
	if (!imageData){
		NSString *message = [NSString stringWithFormat:@"%@ %@", @"Unable to load image source.", err.localizedDescription];
		printf("%s\n", [message UTF8String]);
		return NO;
	}
	NSData *encryptedData = [NSData aes256cryptedDataWithData:imageData hexKey:key];
	
	BOOL result = [encryptedData writeToFile:destinationFileName options:NSDataWritingWithoutOverwriting error:&err];
	if (!result){
		printf("%s\n", [err.localizedDescription UTF8String]);
		return NO;
	}
	return YES;
}

void printHelp(){
	NSString* helpText =
	@"pngcrypt ver. 0.1\n"
	@"A simple tool for encrypt (AES256) PNG image files.\n"
	@"\n"
	@"Usage:\n"
	@"  pngcrypt <key_file> [original_path_folder] [destination_path_folder] [new_extension_file] - all PNG images from [original_path_folder] will be encrypted with <key_file> key and put into [destination_path_folder].\n"
	
	@"  If any of source or destination path parameter not set, tool operate with current folder.\n"
	@"  By default for new created crypted file used CRI extension.\n"
	@"\n"
	@"  pngcrypt help - prints this text\n"
	@"\n"
	@"NOTES\n"
	@"  Currently this program does not support any type of files. Only PNG.\n";
	printf("%s", [helpText UTF8String]);
}

BOOL isReachFile(NSString* fileName){
	return [[NSFileManager defaultManager] isReadableFileAtPath:fileName];
}