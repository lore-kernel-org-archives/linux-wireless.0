Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54003 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965100Ab1GMIl3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Jul 2011 04:41:29 -0400
Message-Id: <20110713084032.538761142@sipsolutions.net> (sfid-20110713_104136_482728_698D7BDD)
Date: Wed, 13 Jul 2011 10:39:12 +0200
From: Johannes Berg <johannes@sipsolutions.net>
To: John Linville <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 04/11] ath5k: remove wireless extensions inclusions
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
 drivers/net/wireless/ath/ath5k/base.h |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/net/wireless/ath/ath5k/base.h	2011-07-13 10:07:03.000000000 +0200
+++ b/drivers/net/wireless/ath/ath5k/base.h	2011-07-13 10:07:07.000000000 +0200
@@ -43,7 +43,6 @@
 
 #include <linux/interrupt.h>
 #include <linux/list.h>
-#include <linux/wireless.h>
 #include <linux/if_ether.h>
 #include <linux/leds.h>
 #include <linux/rfkill.h>


