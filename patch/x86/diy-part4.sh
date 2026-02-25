#!/bin/bash
#
# Copyright (c) 2019-2020 P3TERX <https://p3terx.com>
#
# This is free software, licensed under the MIT License.
# See /LICENSE for more information.
#
# https://github.com/P3TERX/Actions-OpenWrt
# File name: diy-part2.sh
# Description: OpenWrt DIY script part 2 (After Update feeds)
#

# Modify default IP
sed -i 's/192.168.1.1/192.168.10.1/g' package/base-files/files/bin/config_generate
# passwall
git clone --depth=1 https://github.com/Openwrt-Passwall/openwrt-passwall-packages package/passwall-packages
git clone --depth=1 https://github.com/Openwrt-Passwall/openwrt-passwall2 package/passwall2 
git clone --depth=1 https://github.com/Openwrt-Passwall/openwrt-passwall package/passwall
git clone --depth=1 https://github.com/gSpotx2f/luci-app-cpu-status.git package/luci-app-cpu-status
git clone --depth=1 https://github.com/gSpotx2f/luci-app-temp-status.git package/luci-app-temp-status
# 删除已有配置
#rm -rf configfiles/template/.config_x86-64
rm -rf routermain.json
#rm -rf package/kernel/mt76
#cp -f $GITHUB_WORKSPACE/patch/x86/router2305.json router2305.json
cp -f $GITHUB_WORKSPACE/patch/x86/router2305.json routermain.json
#cp -f $GITHUB_WORKSPACE/patch/x86/config_x86-64-latest.txt configfiles/template/.config_x86-64
cp -rf $GITHUB_WORKSPACE/patch/x86 configfiles

# 添加config
echo "
CONFIG_ISO_IMAGES=y
CONFIG_VDI_IMAGES=y
CONFIG_VMDK_IMAGES=y
CONFIG_LUCI_LANG_zh_Hans=y
CONFIG_PACKAGE_ttyd=y
CONFIG_PACKAGE_nlbwmon=y
CONFIG_PACKAGE_luci-i18n-base-zh-cn=y
CONFIG_PACKAGE_luci-app-ttyd=y
CONFIG_PACKAGE_luci-app-nlbwmon=y
CONFIG_PACKAGE_luci-app-p910nd=y
CONFIG_PACKAGE_luci-app-upnp=y
CONFIG_PACKAGE_luci-app-wol=y
CONFIG_PACKAGE_luci-theme-argon=y
CONFIG_PACKAGE_luci-app-ksmbd=y
CONFIG_PACKAGE_luci-app-ddns=y
CONFIG_PACKAGE_luci-app-commands=y
CONFIG_PACKAGE_luci-app-statistics=y
CONFIG_PACKAGE_luci-app-temp-status=y
CONFIG_PACKAGE_luci-app-cpu-status=y 
#CONFIG_PACKAGE_luci-app-passwall=y

#
# Configuration
#
# CONFIG_PACKAGE_luci-app-passwall_Iptables_Transparent_Proxy is not set
#CONFIG_PACKAGE_luci-app-passwall_Nftables_Transparent_Proxy=y
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Haproxy is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Hysteria is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_NaiveProxy is not set
#CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Libev_Client=y
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Libev_Server is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Client is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Shadowsocks_Rust_Server is not set
#CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ShadowsocksR_Libev_Client=y
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_ShadowsocksR_Libev_Server is not set
#CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Simple_Obfs=y
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_SingBox is not set
#CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Trojan_Plus=y
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_tuic_client is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_V2ray_Geodata is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_V2ray_Plugin is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Xray is not set
# CONFIG_PACKAGE_luci-app-passwall_INCLUDE_Xray_Plugin is not set

CONFIG_PACKAGE_kmod-rtl8821ae=y
CONFIG_PACKAGE_kmod-rtl8xxxu=y
CONFIG_PACKAGE_kmod-rtlwifi=y
# CONFIG_PACKAGE_RTLWIFI_DEBUG is not set
CONFIG_PACKAGE_kmod-rtlwifi-btcoexist=y
CONFIG_PACKAGE_kmod-rtlwifi-pci=y
CONFIG_PACKAGE_kmod-rtw88=y
# CONFIG_PACKAGE_RTW88_DEBUG is not set
# CONFIG_PACKAGE_RTW88_DEBUGFS is not set
# CONFIG_PACKAGE_kmod-rtw88-8723de is not set
CONFIG_PACKAGE_kmod-rtw88-8821c=y
CONFIG_PACKAGE_kmod-rtw88-8821ce=y
CONFIG_PACKAGE_kmod-rtw88-8821cu=y
CONFIG_PACKAGE_kmod-rtw88-8822b=y
CONFIG_PACKAGE_kmod-rtw88-8822be=y
CONFIG_PACKAGE_kmod-rtw88-8822bu=y
CONFIG_PACKAGE_kmod-rtw88-8822c=y
CONFIG_PACKAGE_kmod-rtw88-8822ce=y
CONFIG_PACKAGE_kmod-rtw88-8822cu=y
CONFIG_PACKAGE_kmod-rtw88-pci=y
CONFIG_PACKAGE_kmod-rtw88-usb=y
" >> configfiles/template/.config_x86-64

echo "staging_dir/host/bin/python 创建软链接"
rm -rf $GITHUB_WORKSPACE/openwrt/staging_dir/host/bin/python
ln -s /usr/bin/python $GITHUB_WORKSPACE/openwrt/staging_dir/host/bin/python
$GITHUB_WORKSPACE/openwrt/staging_dir/host/bin/python --version

echo "staging_dir/host/bin/python3 创建软链接"
rm -rf $GITHUB_WORKSPACE/openwrt/staging_dir/host/bin/python3
ln -s /usr/bin/python $GITHUB_WORKSPACE/openwrt/staging_dir/host/bin/python3
$GITHUB_WORKSPACE/openwrt/staging_dir/host/bin/python3 --version

#更新golang到1.25
rm -rf feeds/packages/lang/golang
git clone https://github.com/kenzok8/golang -b 1.25 feeds/packages/lang/golang

# 禁止进入默认配置
#sed -i "s/make defconfig/#make defconfig/g" build
# 禁止build对argon主题修改
sed -i 's/"$model_argon >/open.png" >/g' build
# 解决ubim uqmi报错
sed -i "s/LUCI_DEPENDS/#LUCI_DEPENDS/g" feeds/luci/protocols/luci-proto-mbim/Makefile
sed -i "s/LUCI_DEPENDS/#LUCI_DEPENDS/g" feeds/luci/protocols/luci-proto-qmi/Makefile
