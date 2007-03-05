Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.227]:19155 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636AbXCEEVs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Mar 2007 23:21:48 -0500
Received: by wr-out-0506.google.com with SMTP id 37so1226619wra
        for <linux-wireless@vger.kernel.org>; Sun, 04 Mar 2007 20:21:48 -0800 (PST)
Message-ID: <a44ae5cd0703042021o434e42b1vea6fd90376824917@mail.gmail.com>
Date: Sun, 4 Mar 2007 20:21:42 -0800
From: "Miles Lane" <miles.lane@gmail.com>
To: "Andrew Morton" <akpm@osdl.org>,
	LKML <linux-kernel@vger.kernel.org>,
	linux-wireless@vger.kernel.org,
	"Michael Buesch" <mbuesch@freenet.de>
Subject: 2.6.21-rc2-mm1 -- WARNING: "pcmcia_access_configuration_register" [drivers/ssb/ssb.ko] undefined!
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

WARNING: "pcmcia_access_configuration_register" [drivers/ssb/ssb.ko] undefined!
WARNING: "pccard_parse_tuple"
[drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
WARNING: "pcmcia_register_driver"
[drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
WARNING: "pccard_get_tuple_data"
[drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
WARNING: "pcmcia_request_configuration"
[drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
WARNING: "pcmcia_request_window"
[drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
WARNING: "pccard_get_first_tuple"
[drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
WARNING: "pcmcia_release_window"
[drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
WARNING: "pcmcia_map_mem_page"
[drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
WARNING: "pcmcia_unregister_driver"
[drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
WARNING: "pcmcia_disable_device"
[drivers/net/wireless/mac80211/bcm43xx/bcm43xx-mac80211.ko] undefined!
make[1]: *** [__modpost] Error 1

#
# PCCARD (PCMCIA/CardBus) support
#
# CONFIG_PCCARD is not set

CONFIG_BCM43XX_MAC80211=m
CONFIG_BCM43XX_MAC80211_PCI=y
CONFIG_BCM43XX_MAC80211_PCMCIA=y
CONFIG_BCM43XX_MAC80211_DEBUG=y
CONFIG_BCM43XX_MAC80211_DMA=y
CONFIG_BCM43XX_MAC80211_PIO=y
CONFIG_BCM43XX_MAC80211_DMA_AND_PIO_MODE=y
# CONFIG_BCM43XX_MAC80211_DMA_MODE is not set
# CONFIG_BCM43XX_MAC80211_PIO_MODE is not set
# CONFIG_RT2X00 is not set
# CONFIG_ADM8211 is not set
# CONFIG_P54_COMMON is not set
# CONFIG_ZD1211RW_MAC80211 is not set
# CONFIG_RTL818X is not set
# CONFIG_RTL8187 is not set
CONFIG_NET_WIRELESS=y

CONFIG_MAC80211=m
CONFIG_MAC80211_LEDS=y
CONFIG_MAC80211_DEBUG=y
CONFIG_MAC80211_VERBOSE_DEBUG=y
CONFIG_MAC80211_LOWTX_FRAME_DUMP=y
CONFIG_TKIP_DEBUG=y
CONFIG_MAC80211_DEBUG_COUNTERS=y
CONFIG_HOSTAPD_WPA_TESTING=y
CONFIG_MAC80211_IBSS_DEBUG=y
CONFIG_MAC80211_VERBOSE_PS_DEBUG=y
# CONFIG_IEEE80211 is not set
CONFIG_WIRELESS_EXT=y
CONFIG_CFG80211=y
CONFIG_CFG80211_WEXT_COMPAT=y
CONFIG_NL80211=y
