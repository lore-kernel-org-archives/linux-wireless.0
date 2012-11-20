Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42069 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751904Ab2KTVot (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Nov 2012 16:44:49 -0500
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 02/10] nl80211: add documentation for channel type
Date: Tue, 20 Nov 2012 22:45:08 +0100
Message-Id: <1353447916-17304-3-git-send-email-johannes@sipsolutions.net> (sfid-20121120_224452_604703_7A99B4EB)
In-Reply-To: <1353447916-17304-1-git-send-email-johannes@sipsolutions.net>
References: <1353447916-17304-1-git-send-email-johannes@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 include/uapi/linux/nl80211.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
index 43cd6fa..82b5ad3 100644
--- a/include/uapi/linux/nl80211.h
+++ b/include/uapi/linux/nl80211.h
@@ -2438,6 +2438,15 @@ enum nl80211_ac {
 #define NL80211_TXQ_Q_BE	NL80211_AC_BE
 #define NL80211_TXQ_Q_BK	NL80211_AC_BK
 
+/**
+ * enum nl80211_channel_type - channel type
+ * @NL80211_CHAN_NO_HT: 20 MHz, non-HT channel
+ * @NL80211_CHAN_HT20: 20 MHz HT channel
+ * @NL80211_CHAN_HT40MINUS: HT40 channel, secondary channel
+ *	below the control channel
+ * @NL80211_CHAN_HT40PLUS: HT40 channel, secondary channel
+ *	above the control channel
+ */
 enum nl80211_channel_type {
 	NL80211_CHAN_NO_HT,
 	NL80211_CHAN_HT20,
-- 
1.8.0

