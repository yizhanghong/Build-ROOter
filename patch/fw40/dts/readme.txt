target\linux\ramips\dts
target\linux\ramips\image

sed -i "s/make defconfig/#make defconfig/g" build

define Device/fw40
  $(Device/dsa-migration)
  $(Device/uimage-lzma-loader)
  IMAGE_SIZE := 32448k
  DEVICE_VENDOR := Doonink
  DEVICE_MODEL := FW40
  DEVICE_VARIANT := 32M
  DEVICE_PACKAGES := mod-usb-ledtrig-usbport\
		kmod-mt7603 kmod-mt76x2 \
		kmod-usb3
  SUPPORTED_DEVICES +=fw40 doonink,fw40
endef
TARGET_DEVICES += fw40


{
"FW40": {
		"details": "Doonink Fw40",
		"type": "1",
		"build": "2203",
		"config": ".config_fw40",
		"image": "openwrt-ramips-mt7621-fw40-squashfs-sysupgrade.bin",
		"imagepath": "/ramips/mt7621/",
		"mod": "Doonink-FW40",
		"ext": "-upgrade.bin",
		"addons": [],
		"custom": {
			"name": {
				"model": "Doonink FW40"
			},
			"files": "/fw40/files/"
		}	
	}
}

{
"X86-64-EFI": {
		"details": "Generic x86 64 bit UEFI",
		"type": "4",
		"build": "2203",
		"config": ".config_x86-64-efi",
		"image1": "openwrt-x86-64-generic-ext4-combined-efi.img.gz",
		"image2": "openwrt-x86-64-generic-ext4-combined-efi.img",
		"imagepath": "/x86/64/",
		"mod": "x86-UEFI-64",
		"addons": ["readme.pdf"],
		"custom": {
			"name": {
				"model": "GWRT X86"
			},
			"files": "/x86/files/"
		}
	}
}