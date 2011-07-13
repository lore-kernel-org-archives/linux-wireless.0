Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54017 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965108Ab1GMIlj (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 04:41:39 -0400
Message-Id: <20110713084035.825024502@sipsolutions.net> (sfid-20110713_104145_977087_36B89B62)
Date: Wed, 13 Jul 2011 10:39:19 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 11/11] mac80211: remove linux/wireless.h inclusion
References: <20110713083908.713123063@sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

linux/wireless.h is for wireless extensions only, so
mac80211 shouldn't include it since it uses cfg80211.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/net/mac80211.h |    1 -
 1 file changed, 1 deletion(-)

--- a/include/net/mac80211.h	2011-07-13 10:33:11.000000000 +0200
+++ b/include/net/mac80211.h	2011-07-13 10:33:14.000000000 +0200
@@ -16,7 +16,6 @@
 #include <linux/kernel.h>
 #include <linux/if_ether.h>
 #include <linux/skbuff.h>
-#include <linux/wireless.h>
 #include <linux/device.h>
 #include <linux/ieee80211.h>
 #include <net/cfg80211.h>


