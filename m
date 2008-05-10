Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.152]:54673 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753468AbYEJMKn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 May 2008 08:10:43 -0400
Received: by fg-out-1718.google.com with SMTP id 19so1148254fgg.17
        for <linux-wireless@vger.kernel.org>; Sat, 10 May 2008 05:10:43 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 5/5] mac80211: Match define names in comments with actual defines
Date: Sat, 10 May 2008 13:51:29 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <200805101349.19481.IvDoorn@gmail.com>
In-Reply-To: <200805101349.19481.IvDoorn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200805101351.30038.IvDoorn@gmail.com> (sfid-20080510_141529_173747_FC92DEBD)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The defines introduced in patch:
	mac80211: tx-info skb->cb
did not match the names wich were mentioned in the comment
above the defines.

Signed-off-by: Ivo van Doorn <IvDoorn@gmail.com>
---
 include/net/mac80211.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 1441105..684b42b 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -235,10 +235,10 @@ struct ieee80211_bss_conf {
  *	is handed to a driver.
  * @IEEE80211_TX_CTL_INJECTED: Frame was injected (NOT for driver use!)
  *
- * @IEEE80211_TX_STATUS_TX_FILTERED: The frame was not transmitted
+ * @IEEE80211_TX_STAT_TX_FILTERED: The frame was not transmitted
  *	because the destination STA was in powersave mode.
- * @IEEE80211_TX_STATUS_ACK: Frame was acknowledged
- * @IEEE80211_TX_STATUS_AMPDU: The frame was aggregated, so status
+ * @IEEE80211_TX_STAT_ACK: Frame was acknowledged
+ * @IEEE80211_TX_STAT_AMPDU: The frame was aggregated, so status
  * 	is for the whole aggregation.
  */
 enum mac80211_tx_control_flags {
-- 
1.5.5.1

