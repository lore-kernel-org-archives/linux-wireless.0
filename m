Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.12]:46934 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750756AbbFBTKZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2015 15:10:25 -0400
From: Jakub Kicinski <moorray3@wp.pl>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Jakub Kicinski <kubakici@wp.pl>
Subject: [PATCH] mac80211: remove obsolete sentence from documentation
Date: Tue,  2 Jun 2015 21:10:13 +0200
Message-Id: <1433272213-6346-1-git-send-email-moorray3@wp.pl> (sfid-20150602_211029_482359_34035E78)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jakub Kicinski <kubakici@wp.pl>

FIF_PROMISC_IN_BSS was removed in commit df1404650ccb
("mac80211: remove support for IFF_PROMISC").

Signed-off-by: Jakub Kicinski <kubakici@wp.pl>
---
 include/net/mac80211.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/net/mac80211.h b/include/net/mac80211.h
index 2f8b7decace0..e117119927ec 100644
--- a/include/net/mac80211.h
+++ b/include/net/mac80211.h
@@ -2591,8 +2591,7 @@ void ieee80211_free_txskb(struct ieee80211_hw *hw, struct sk_buff *skb);
  *
  * @FIF_OTHER_BSS: pass frames destined to other BSSes
  *
- * @FIF_PSPOLL: pass PS Poll frames, if PROMISC_IN_BSS is not set then only
- * 	those addressed to this station.
+ * @FIF_PSPOLL: pass PS Poll frames
  *
  * @FIF_PROBE_REQ: pass probe request frames
  */
-- 
2.1.0

