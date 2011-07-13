Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54005 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965029Ab1GMIla (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 04:41:30 -0400
Message-Id: <20110713084032.913600502@sipsolutions.net> (sfid-20110713_104140_074814_17C4F719)
Date: Wed, 13 Jul 2011 10:39:13 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 05/11] b43: remove wireless extensions inclusions
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
 drivers/net/wireless/b43/main.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/wireless/b43/main.c	2011-07-13 10:09:54.000000000 +0200
+++ b/drivers/net/wireless/b43/main.c	2011-07-13 10:09:56.000000000 +0200
@@ -37,7 +37,6 @@
 #include <linux/if_arp.h>
 #include <linux/etherdevice.h>
 #include <linux/firmware.h>
-#include <linux/wireless.h>
 #include <linux/workqueue.h>
 #include <linux/skbuff.h>
 #include <linux/io.h>


