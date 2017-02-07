Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57978 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754288AbdBGOdc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Feb 2017 09:33:32 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH] wil6210: include moduleparam.h
Date: Tue,  7 Feb 2017 15:33:28 +0100
Message-Id: <20170207143328.22529-1-johannes@sipsolutions.net> (sfid-20170207_153335_648991_048987D0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

This now declares a module parameter, so include the necessary
header file for that.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/ath/wil6210/cfg80211.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/ath/wil6210/cfg80211.c b/drivers/net/wireless/ath/wil6210/cfg80211.c
index 6aa3ff4240a9..035ff5974058 100644
--- a/drivers/net/wireless/ath/wil6210/cfg80211.c
+++ b/drivers/net/wireless/ath/wil6210/cfg80211.c
@@ -15,6 +15,7 @@
  */
 
 #include <linux/etherdevice.h>
+#include <linux/moduleparam.h>
 #include "wil6210.h"
 #include "wmi.h"
 
-- 
2.9.3
