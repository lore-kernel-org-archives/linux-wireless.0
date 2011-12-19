Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nick.hrz.tu-chemnitz.de ([134.109.228.11]:42236 "EHLO
	nick.hrz.tu-chemnitz.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753086Ab1LSOPF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Dec 2011 09:15:05 -0500
From: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
To: linux-wireless@vger.kernel.org
Cc: linville@tuxdriver.com, Johannes Berg <johannes@sipsolutions.net>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
Subject: [PATCH 1/2] iw: add nl80211 bitrates
Date: Mon, 19 Dec 2011 15:14:58 +0100
Message-Id: <1324304099-18327-4-git-send-email-siwu@hrz.tu-chemnitz.de> (sfid-20111219_151511_500947_7847EB2C)
In-Reply-To: <1324304099-18327-1-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1324304099-18327-1-git-send-email-siwu@hrz.tu-chemnitz.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Signed-off-by: Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>
---
 nl80211.h |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/nl80211.h b/nl80211.h
index a187606..445e0e4 100644
--- a/nl80211.h
+++ b/nl80211.h
@@ -2395,12 +2395,15 @@ enum nl80211_key_attributes {
  *	in an array of rates as defined in IEEE 802.11 7.3.2.2 (u8 values with
  *	1 = 500 kbps) but without the IE length restriction (at most
  *	%NL80211_MAX_SUPP_RATES in a single array).
+ * @NL80211_TXRATE_MCS: HT (MCS) rates allowed for TX rate selection
+ *      in an array of MCS numbers.
  * @__NL80211_TXRATE_AFTER_LAST: internal
  * @NL80211_TXRATE_MAX: highest TX rate attribute
  */
 enum nl80211_tx_rate_attributes {
 	__NL80211_TXRATE_INVALID,
 	NL80211_TXRATE_LEGACY,
+	NL80211_TXRATE_MCS,
 
 	/* keep last */
 	__NL80211_TXRATE_AFTER_LAST,
-- 
1.7.7.3

