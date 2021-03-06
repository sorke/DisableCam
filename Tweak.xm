
//static NSString* const filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Library/Preferences/"] stringByAppendingPathComponent:[NSString stringWithFormat: @"com.ridan.disablecam.plist"]];
static NSString* const filePath = @"/var/mobile/Library/Preferences/com.ridan.disablecam.plist";
static NSMutableDictionary* plist = [[NSMutableDictionary alloc] initWithContentsOfFile:filePath];
static BOOL hasCamera = [[plist objectForKey:@"hasCamera"]boolValue];
static BOOL isDir = NO;


%hook  PLCameraController
- (BOOL)hasRearCamera
{
	if([[NSFileManager defaultManager] fileExistsAtPath: filePath isDirectory: &isDir] && !isDir)
		return hasCamera;
	return %orig;
}
- (BOOL)hasFrontCamera
{
	if([[NSFileManager defaultManager] fileExistsAtPath: filePath isDirectory: &isDir] && !isDir)
		return !hasCamera;
	return %orig;
}
- (void)_setCameraMode:(int)arg1 cameraDevice:(int)arg2
{
	if([[NSFileManager defaultManager] fileExistsAtPath: filePath isDirectory: &isDir] && !isDir) {
		%orig(arg1,hasCamera);
	}else{
		%orig;
	}
}
%end
//snapchat
%hook AVCamCaptureManager
- (id)backFacingCamera
{
	if([[NSFileManager defaultManager] fileExistsAtPath: filePath isDirectory: &isDir] && !isDir)
		if (hasCamera)return nil;
	return %orig;
}
- (id)frontFacingCamera
{
	if([[NSFileManager defaultManager] fileExistsAtPath: filePath isDirectory: &isDir] && !isDir)
		if(!hasCamera)return nil;
	return %orig;
}

%end
%hook AVCameraViewController
/*- (void)frontCameraButtonPressed
{
	%orig;
}*/
//this removes the camera button
- (unsigned int)cameraCount
{
		return 1;
}

%end
