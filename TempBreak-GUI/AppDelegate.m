/**
 * TempBreak - Jailbreak Interface & GUI Template.
 * Copyright (C) 2014  Louis Kremer
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 **/

#import "AppDelegate.h"
#import "MobileDevice_mod.h"

static AppDelegate *load;
struct am_device* device;
struct am_device_notification *notification;

void notification_callback(struct am_device_notification_callback_info *info, int cookie) {
	if (info->msg == ADNCI_MSG_CONNECTED) {
		device = info->dev;
		AMDeviceConnect(device);
		AMDevicePair(device);
		AMDeviceValidatePairing(device);
		AMDeviceStartSession(device);
		[load check];
	} else if (info->msg == ADNCI_MSG_DISCONNECTED) {
		[load disconnected];
	} else {
	}
}

@implementation AppDelegate

@synthesize window, loadingInd, deviceDetails, device2details, jb, progressbar, ex, loading, onecell, twocell, status, mored2;

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    return YES;
}

- (IBAction)exit:(id)sender {
    [[NSApplication sharedApplication] terminate:nil];
}

- (NSString *)DeviceValue:(NSString *)value {
	return (__bridge NSString *)(AMDeviceCopyValue(device, 0, (__bridge CFStringRef)(value)));
}

- (void)deviceCallback {
    [onecell setHidden: YES];
    [twocell setHidden: YES];
    [loading setHidden: YES];
	[loadingInd setHidden:YES];
}

- (IBAction)twitter:(id)sender {
    [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://twitter.com/cal0x"]];
}

- (void)disconnected {
    [onecell setHidden: YES];
    [twocell setHidden: YES];
    [loading setHidden: YES];
    [loading setHidden: NO];
    [loading startAnimation: self];
    jb.enabled = NO;
	[deviceDetails setStringValue:@"Device disconnected"];
    [device2details setStringValue:@"More Device Information"];
    [mored2 setStringValue:@"More Device Information"];
    
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [onecell setHidden: YES]; [twocell setHidden: YES]; [ex setHidden:YES];
    [loading setHidden: YES]; [loadingInd setHidden: NO]; [loadingInd startAnimation: self];
    jb.enabled = NO; load = self;
    AMDeviceNotificationSubscribe(notification_callback, 0, 0, 0, &notification);
}

- (IBAction)fi:(id)sender {
        [[NSWorkspace sharedWorkspace] openURL:[NSURL URLWithString:@"http://cal0x.com"]];
}

- (void)check {
    
    NSString *deviceName = [self DeviceValue:@"DeviceName"];
	NSString *model = [self DeviceValue:@"ModelNumber"];
	NSString *devicetype = [self DeviceValue:@"ProductType"];
	NSString *firmwareVersion = [self DeviceValue:@"ProductVersion"];
	NSString *support;
    NSString *unknow = @"Unknown";
    
    [onecell setHidden: YES];
    [twocell setHidden: YES];
    [loading setHidden: YES];
    [loadingInd setHidden: NO];
    [loadingInd startAnimation: self];
    
	if ([devicetype isEqualToString:@"iPhone1,1"]) {
		devicetype = @"iPhone 2G";
	} else if ([devicetype isEqualToString:@"iPhone1,2"]) {
		devicetype = @"iPhone 3G";
	} else if ([devicetype isEqualToString:@"iPhone2,1"]) {
		devicetype = @"iPhone 3G[S]";
	} else if ([devicetype isEqualToString:@"iPhone3,1"]) {
		devicetype = @"iPhone 4";
        support = @"is supported";
        jb.enabled = YES;
    } else if ([devicetype isEqualToString:@"iPhone4,1"]) {
		devicetype = @"iPhone 4s";
        support = @"is supported";
        jb.enabled = YES;
    } else if ([devicetype isEqualToString:@"iPhone6,2"]) {
		devicetype = @"iPhone 5s";
        support = @"is supported";
        jb.enabled = YES;
	} else if ([devicetype isEqualToString:@"iPad1,1"]) {
		devicetype = @"iPad 1G";
	} else {
		devicetype = @"Unknown";
	}
	
	if (devicetype == unknow) {
		NSString *complete = [NSString stringWithFormat:@"%@ Mode/Device Detected",devicetype];
		[deviceDetails setStringValue:complete];
	} else {
        [loading setHidden: YES];
		[loadingInd setHidden:YES];
		NSString *complete = [NSString stringWithFormat:@"%@ %@ %@ %@", devicetype, @"on iOS", firmwareVersion, support];
        NSString *complete2 = [NSString stringWithFormat:@"Device Name: %@ ", deviceName];
        NSString *complete3 = [NSString stringWithFormat:@"Model Number: %@", model];
        [mored2 setStringValue:complete3];
		[deviceDetails setStringValue:complete];
        [device2details setStringValue:complete2];
        	}
}

- (void)done {
    NSRunAlertPanel(@"TempBreak", @"Thanks for using TempBreak", @"Sure!", NULL, NULL);
    [status setStringValue:@"D o n e !  Your iDevice was successfully jailbroken."];
    [onecell setHidden: YES];
    [twocell setHidden: YES];
    [progressbar stopAnimation: self];
    [jb setHidden:YES];
    [ex setHidden:NO];
}

- (IBAction)jailbreak:(id)sender {
    [jb setTitle:@"Jailbreaking ..."];
    [progressbar setIndeterminate:YES];
    [progressbar setHidden: NO];
    [progressbar startAnimation: self];
    [onecell setHidden: YES];
    [twocell setHidden: YES];
    sleep(3);
	[load done];
}
@end
