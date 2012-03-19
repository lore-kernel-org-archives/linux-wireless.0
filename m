Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb05.tieto.com ([131.207.168.36]:50221 "EHLO ebb05.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759077Ab2CTOkN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Mar 2012 10:40:13 -0400
From: Michal Kazior <michal.kazior@tieto.com>
Date: Mon, 19 Mar 2012 11:36:46 +0100
Subject: [RFC 08/12] mac80211: introduce IEEE80211_HW_SUPPORTS_MULTI_CHANNEL
To: <linux-wireless@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <8ddd58c3-b1d2-44b3-8fb6-a9368814653b@FIVLA-EXHUB02.eu.tieto.com> (sfid-20120320_154023_532477_CDEA420A)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
---
 include/net/mac80211.h |    5 ++++-
 1 files changed, 4 insertions(+), 1 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index c114b18..f7f0252 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -1130,6 +1130,9 @@ enum sta_notify_cmd {
  * @IEEE80211_HW_MFP_CAPABLE:
  *	Hardware supports management frame protection (MFP, IEEE 802.11w).
  *
+ * @IEEE80211_HW_SUPPORTS_MULTI_CHANNEL
+ *	Hardware supports concurrent multi-channel operation.
+ *
  * @IEEE80211_HW_SUPPORTS_STATIC_SMPS:
  *	Hardware supports static spatial multiplexing powersave,
  *	ie. can turn off all but one chain even on HT connections
@@ -1196,7 +1199,7 @@ enum ieee80211_hw_flags {
 	IEEE80211_HW_PS_NULLFUNC_STACK			= 1<<11,
 	IEEE80211_HW_SUPPORTS_DYNAMIC_PS		= 1<<12,
 	IEEE80211_HW_MFP_CAPABLE			= 1<<13,
-	/* reuse bit 14 */
+	IEEE80211_HW_SUPPORTS_MULTI_CHANNEL		= 1<<14,
 	IEEE80211_HW_SUPPORTS_STATIC_SMPS		= 1<<15,
 	IEEE80211_HW_SUPPORTS_DYNAMIC_SMPS		= 1<<16,
 	IEEE80211_HW_SUPPORTS_UAPSD			= 1<<17,
-- 
1.7.0.4

