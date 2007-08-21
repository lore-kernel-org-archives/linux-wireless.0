Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:58327 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932088AbXHUPHs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 21 Aug 2007 11:07:48 -0400
Message-Id: <20070821150043.519474000@sipsolutions.net>
References: <20070821145905.689978000@sipsolutions.net>
Date: Tue, 21 Aug 2007 16:59:15 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: Jiri Benc <jbenc@suse.cz>, Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: [PATCH 10/27] ralink drivers: remove IEEE80211_HW_DATA_NULLFUNC_ACK
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The flag will be removed from mac80211 because it is unused.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: rt2400-devel@lists.sourceforge.net
Cc: Ivo van Doorn <ivdoorn@gmail.com>

---
 drivers/net/wireless/rt2x00/rt2400pci.c |    1 -
 drivers/net/wireless/rt2x00/rt2500pci.c |    1 -
 drivers/net/wireless/rt2x00/rt2500usb.c |    1 -
 drivers/net/wireless/rt2x00/rt61pci.c   |    1 -
 drivers/net/wireless/rt2x00/rt73usb.c   |    1 -
 5 files changed, 5 deletions(-)

--- wireless-dev.orig/drivers/net/wireless/rt2x00/rt2400pci.c	2007-08-21 14:40:09.045923881 +0200
+++ wireless-dev/drivers/net/wireless/rt2x00/rt2400pci.c	2007-08-21 14:40:11.605923881 +0200
@@ -1449,7 +1449,6 @@ static void rt2400pci_probe_hw_mode(stru
 	 */
 	rt2x00dev->hw->flags =
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-	    IEEE80211_HW_DATA_NULLFUNC_ACK |
 	    IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 	    IEEE80211_HW_MONITOR_DURING_OPER |
 	    IEEE80211_HW_NO_PROBE_FILTERING;
--- wireless-dev.orig/drivers/net/wireless/rt2x00/rt2500pci.c	2007-08-21 14:40:09.055923881 +0200
+++ wireless-dev/drivers/net/wireless/rt2x00/rt2500pci.c	2007-08-21 14:40:11.615923881 +0200
@@ -1747,7 +1747,6 @@ static void rt2500pci_probe_hw_mode(stru
 	 */
 	rt2x00dev->hw->flags =
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-	    IEEE80211_HW_DATA_NULLFUNC_ACK |
 	    IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 	    IEEE80211_HW_MONITOR_DURING_OPER |
 	    IEEE80211_HW_NO_PROBE_FILTERING;
--- wireless-dev.orig/drivers/net/wireless/rt2x00/rt2500usb.c	2007-08-21 14:40:07.405923881 +0200
+++ wireless-dev/drivers/net/wireless/rt2x00/rt2500usb.c	2007-08-21 14:40:11.685923881 +0200
@@ -1468,7 +1468,6 @@ static void rt2500usb_probe_hw_mode(stru
 	    IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
 	    IEEE80211_HW_RX_INCLUDES_FCS |
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-	    IEEE80211_HW_DATA_NULLFUNC_ACK |
 	    IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 	    IEEE80211_HW_MONITOR_DURING_OPER |
 	    IEEE80211_HW_NO_PROBE_FILTERING;
--- wireless-dev.orig/drivers/net/wireless/rt2x00/rt61pci.c	2007-08-21 14:40:09.055923881 +0200
+++ wireless-dev/drivers/net/wireless/rt2x00/rt61pci.c	2007-08-21 14:40:11.685923881 +0200
@@ -2120,7 +2120,6 @@ static void rt61pci_probe_hw_mode(struct
 	 */
 	rt2x00dev->hw->flags =
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-	    IEEE80211_HW_DATA_NULLFUNC_ACK |
 	    IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 	    IEEE80211_HW_MONITOR_DURING_OPER |
 	    IEEE80211_HW_NO_PROBE_FILTERING;
--- wireless-dev.orig/drivers/net/wireless/rt2x00/rt73usb.c	2007-08-21 14:40:07.425923881 +0200
+++ wireless-dev/drivers/net/wireless/rt2x00/rt73usb.c	2007-08-21 14:40:11.695923881 +0200
@@ -1714,7 +1714,6 @@ static void rt73usb_probe_hw_mode(struct
 	rt2x00dev->hw->flags =
 	    IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
-	    IEEE80211_HW_DATA_NULLFUNC_ACK |
 	    IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 	    IEEE80211_HW_MONITOR_DURING_OPER |
 	    IEEE80211_HW_NO_PROBE_FILTERING;

-- 

