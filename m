Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54009 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965100Ab1GMIld (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 04:41:33 -0400
Message-Id: <20110713084033.892965342@sipsolutions.net> (sfid-20110713_104137_017623_915AFC34)
Date: Wed, 13 Jul 2011 10:39:15 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 07/11] rndis_wlan: remove wireless extensions inclusions
References: <20110713083908.713123063@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

linux/wireless.h and net/iw_handler.h headers are
for wireless extensions only, so mac80211 drivers
shouldn't be including them.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/rndis_wlan.c |    2 --
 1 file changed, 2 deletions(-)

--- a/drivers/net/wireless/rndis_wlan.c	2011-07-13 10:27:00.000000000 +0200
+++ b/drivers/net/wireless/rndis_wlan.c	2011-07-13 10:27:55.000000000 +0200
@@ -36,13 +36,11 @@
 #include <linux/mii.h>
 #include <linux/usb.h>
 #include <linux/usb/cdc.h>
-#include <linux/wireless.h>
 #include <linux/ieee80211.h>
 #include <linux/if_arp.h>
 #include <linux/ctype.h>
 #include <linux/spinlock.h>
 #include <linux/slab.h>
-#include <net/iw_handler.h>
 #include <net/cfg80211.h>
 #include <linux/usb/usbnet.h>
 #include <linux/usb/rndis_host.h>


