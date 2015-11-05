export ARCHS = armv7 arm64
export TARGET = iphone:clang:latest:7.0

include theos/makefiles/common.mk

TWEAK_NAME = DKRevealLoader
DKRevealLoader_FILES = Tweak.xm
DKRevealLoader_FRAMEWORKS = Foundation UIKit

include $(THEOS_MAKE_PATH)/tweak.mk

all::
	$(shell mkdir -p layout/Library/Application\ Support/DKRevealLoader/)
	$(shell cp /Applications/Reveal.app/Contents/SharedSupport/iOS-Libraries/libReveal.dylib layout/Library/Application\ Support/DKRevealLoader/)

after-install::
	install.exec "killall -9 SpringBoard"
