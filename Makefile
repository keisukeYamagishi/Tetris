config:
	bundle install
debug:
	xcodebuild \
	-sdk iphoneos \
	-configuration Debug \
	-project Tetris.xcodeproj \
	-scheme Tetris \
	build CODE_SIGNING_ALLOWED=NO

test:
	xcodebuild \
	-sdk iphoneos \
	-configuration Debug \
	-project Tetris.xcodeproj \
	-scheme Tetris \
	-destination 'platform=iOS Simulator,name=iPhone 14 Pro,OS=16.2' \
	clean test CODE_SIGNING_ALLOWED=NO

code-coverage:
	 slather coverage -s --scheme Tetris --configuration debug Tetris.xcodeproj