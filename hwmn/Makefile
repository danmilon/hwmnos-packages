include $(TOPDIR)/rules.mk

PKG_NAME:=hwmn
PKG_VERSION:=0.1
PKG_RELEASE:=1
PKG_MAINTAINER:=Dan Milon <i@danmilon.me>
PKG_LICENSE:=GPLv2

include $(INCLUDE_DIR)/package.mk

define Package/hwmn
  SECTION:=HWMN
  CATEGORY:=HWMN
  SUBMENU:=3. Applications
  TITLE:=HWMN easy configuration
  DEPENDS:=+luci-ssl +luci-mod-admin-full +babeld +luci-lib-nixio \
           +dnsmasq-full +mtr +ip-full +kmod-nf-nathelper-extra
  PKGARCH:=all
  MAINTAINER:=Dan Milon <i@danmilon.me>
endef

define Package/hwmn/description
HWMN easy configuration
endef

define Build/Compile
endef

define Package/hwmn/install
	$(CP) ./files/* $(1)
endef

$(eval $(call BuildPackage,hwmn))
