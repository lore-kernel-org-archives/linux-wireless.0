Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f52.google.com ([209.85.210.52]:33307 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab2CaSZZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 31 Mar 2012 14:25:25 -0400
Received: by dake40 with SMTP id e40so813161dak.11
        for <linux-wireless@vger.kernel.org>; Sat, 31 Mar 2012 11:25:24 -0700 (PDT)
From: Javier Cardona <javier@cozybit.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Javier Cardona <javier@cozybit.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	devel@lists.open80211s.org, ashok@cozybit.com,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: [PATCH] mac80211: Set the correct values for hwmp (1) and airtimeLinkMetric (1)
Date: Sat, 31 Mar 2012 11:25:20 -0700
Message-Id: <1333218320-29837-1-git-send-email-javier@cozybit.com> (sfid-20120331_202528_928002_3C0D0F97)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Per sections 8.4.2.100.2 and 8.4.2.100.3 of Std 802.11-2012

Signed-off-by: Javier Cardona <javier@cozybit.com>
---
 include/linux/ieee80211.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
index 210e2c3..e8f75af 100644
--- a/include/linux/ieee80211.h
+++ b/include/linux/ieee80211.h
@@ -1448,7 +1448,7 @@ enum ieee80211_tdls_actioncode {
  * be specified in a vendor specific information element
  */
 enum {
-	IEEE80211_PATH_PROTOCOL_HWMP = 0,
+	IEEE80211_PATH_PROTOCOL_HWMP = 1,
 	IEEE80211_PATH_PROTOCOL_VENDOR = 255,
 };
 
@@ -1460,7 +1460,7 @@ enum {
  * specified in a vendor specific information element
  */
 enum {
-	IEEE80211_PATH_METRIC_AIRTIME = 0,
+	IEEE80211_PATH_METRIC_AIRTIME = 1,
 	IEEE80211_PATH_METRIC_VENDOR = 255,
 };
 
-- 
1.7.5.4

