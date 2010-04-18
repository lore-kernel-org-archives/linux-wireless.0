Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from coco.cs.washington.edu ([128.208.3.82]:49115 "EHLO
	coco.cs.washington.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754796Ab0DRRBZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 18 Apr 2010 13:01:25 -0400
Received: from [10.0.1.5] (c-24-19-11-255.hsd1.wa.comcast.net [24.19.11.255])
	(authenticated bits=0)
	by coco.cs.washington.edu (8.14.3/8.14.3/1.10) with ESMTP id o3IGRwrh025515
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-wireless@vger.kernel.org>; Sun, 18 Apr 2010 09:28:18 -0700
	(envelope-from dhalperi@cs.washington.edu)
From: Daniel Halperin <dhalperi@cs.washington.edu>
Content-Type: text/plain; charset=us-ascii
Subject: [PATCH] mac80211: fix typo in comments
Date: Sun, 18 Apr 2010 09:28:18 -0700
Message-Id: <ADAD4779-B8BD-429E-9AB7-1869142576E6@cs.washington.edu>
To: linux-wireless@vger.kernel.org
Mime-Version: 1.0 (Apple Message framework v1078)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The flag is called IEEE80211_TX_STAT_AMPDU rather than using the whole word
STATUS.

Signed-off-by: Daniel Halperin <dhalperi@cs.washington.edu>
---
 include/net/mac80211.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index dcf3c5f..ecf2273 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -395,11 +395,11 @@ struct ieee80211_tx_rate {
  * @status: union for status data
  * @driver_data: array of driver_data pointers
  * @ampdu_ack_len: number of acked aggregated frames.
- * 	relevant only if IEEE80211_TX_STATUS_AMPDU was set.
+ * 	relevant only if IEEE80211_TX_STAT_AMPDU was set.
  * @ampdu_ack_map: block ack bit map for the aggregation.
- * 	relevant only if IEEE80211_TX_STATUS_AMPDU was set.
+ * 	relevant only if IEEE80211_TX_STAT_AMPDU was set.
  * @ampdu_len: number of aggregated frames.
- * 	relevant only if IEEE80211_TX_STATUS_AMPDU was set.
+ * 	relevant only if IEEE80211_TX_STAT_AMPDU was set.
  * @ack_signal: signal strength of the ACK frame
  */
 struct ieee80211_tx_info {
-- 
1.5.4.3

			
