debug:
	xcodebuild \
	-sdk iphoneos \
	-configuration Debug \
	-project Swiris.xcodeproj \
	-scheme Swiris \
	build CODE_SIGNING_ALLOWED=NO