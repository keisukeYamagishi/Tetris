debug:
	xcodebuild \
	-sdk iphoneos \
	-configuration Debug \
	-project Tetris.xcodeproj \
	-scheme Tetris \
	build CODE_SIGNING_ALLOWED=NO
