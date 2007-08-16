Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from crystal.sipsolutions.net ([195.210.38.204]:43811 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764941AbXHPQ3z (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 16 Aug 2007 12:29:55 -0400
Message-Id: <20070816162931.924947000@sipsolutions.net>
References: <20070816162908.030659000@sipsolutions.net>
Date: Thu, 16 Aug 2007 18:29:09 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net,
	Ivo van Doorn <ivdoorn@gmail.com>
Subject: [PATCH 1/4] ralink drivers: remove IEEE80211_HW_DATA_NULLFUNC_ACK
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The flag will be removed from mac80211 because it is unused.

Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
Cc: rt2400-devel@lists.sourceforge.net
Cc: Ivo van Doorn <ivdoorn@gmail.com>

---
 drivers/net/wireless/rt2400pci.c |    1 -
 drivers/net/wireless/rt2500pci.c |    1 -
 drivers/net/wireless/rt2500usb.c |    1 -
 drivers/net/wireless/rt61pci.c   |    1 -
 drivers/net/wireless/rt73usb.c   |    1 -
 5 files changed, 5 deletions(-)

--- wireless-dev.orig/drivers/net/wireless/rt2400pci.c	2007-08-16 18:18:27.243468950 +0200
+++ wireless-dev/drivers/net/wireless/rt2400pci.c	2007-08-16 18:18:43.093468950 +0200
@@ -1446,7 +1446,6 @@ static void rt2400pci_probe_hw_mode(stru
 	rt2x00dev->hw->flags =
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 	    IEEE80211_HW_WEP_INCLUDE_IV |
-	    IEEE80211_HW_DATA_NULLFUNC_ACK |
 	    IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 	    IEEE80211_HW_MONITOR_DURING_OPER |
 	    IEEE80211_HW_NO_PROBE_FILTERING;
--- wireless-dev.orig/drivers/net/wireless/rt2500pci.c	2007-08-16 18:19:14.133468950 +0200
+++ wireless-dev/drivers/net/wireless/rt2500pci.c	2007-08-16 18:19:16.323468950 +0200
@@ -1691,7 +1691,6 @@ static void rt2500pci_probe_hw_mode(stru
 	rt2x00dev->hw->flags =
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 	    IEEE80211_HW_WEP_INCLUDE_IV |
-	    IEEE80211_HW_DATA_NULLFUNC_ACK |
 	    IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 	    IEEE80211_HW_MONITOR_DURING_OPER |
 	    IEEE80211_HW_NO_PROBE_FILTERING;
--- wireless-dev.orig/drivers/net/wireless/rt2500usb.c	2007-08-16 18:19:14.233468950 +0200
+++ wireless-dev/drivers/net/wireless/rt2500usb.c	2007-08-16 18:19:17.883468950 +0200
@@ -1422,7 +1422,6 @@ static void rt2500usb_probe_hw_mode(stru
 	    IEEE80211_HW_RX_INCLUDES_FCS |
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 	    IEEE80211_HW_WEP_INCLUDE_IV |
-	    IEEE80211_HW_DATA_NULLFUNC_ACK |
 	    IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 	    IEEE80211_HW_MONITOR_DURING_OPER |
 	    IEEE80211_HW_NO_PROBE_FILTERING;
--- wireless-dev.orig/drivers/net/wireless/rt61pci.c	2007-08-16 18:18:27.143468950 +0200
+++ wireless-dev/drivers/net/wireless/rt61pci.c	2007-08-16 18:18:41.373468950 +0200
@@ -2215,7 +2215,6 @@ static void rt61pci_probe_hw_mode(struct
 	rt2x00dev->hw->flags =
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 	    IEEE80211_HW_WEP_INCLUDE_IV |
-	    IEEE80211_HW_DATA_NULLFUNC_ACK |
 	    IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 	    IEEE80211_HW_MONITOR_DURING_OPER |
 	    IEEE80211_HW_NO_PROBE_FILTERING;
--- wireless-dev.orig/drivers/net/wireless/rt73usb.c	2007-08-16 18:18:27.033468950 +0200
+++ wireless-dev/drivers/net/wireless/rt73usb.c	2007-08-16 18:18:39.603468950 +0200
@@ -1682,7 +1682,6 @@ static void rt73usb_probe_hw_mode(struct
 	    IEEE80211_HW_HOST_GEN_BEACON_TEMPLATE |
 	    IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING |
 	    IEEE80211_HW_WEP_INCLUDE_IV |
-	    IEEE80211_HW_DATA_NULLFUNC_ACK |
 	    IEEE80211_HW_NO_TKIP_WMM_HWACCEL |
 	    IEEE80211_HW_MONITOR_DURING_OPER |
 	    IEEE80211_HW_NO_PROBE_FILTERING;

-- 

