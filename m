Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:47419 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1162380AbaDCHDy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Apr 2014 03:03:54 -0400
Received: from potku.adurom.net (a91-155-131-35.elisa-laajakaista.fi [91.155.131.35])
	by emh01.mail.saunalahti.fi (Postfix) with ESMTP id AAD6490266
	for <linux-wireless@vger.kernel.org>; Thu,  3 Apr 2014 10:03:46 +0300 (EEST)
Subject: [PATCH] cfg80211: update comment about WIPHY_FLAG_CUSTOM_REGULATORY
To: linux-wireless@vger.kernel.org
From: Kalle Valo <kvalo@qca.qualcomm.com>
Date: Thu, 03 Apr 2014 10:03:45 +0300
Message-ID: <20140403070345.28730.75836.stgit@potku.adurom.net> (sfid-20140403_090457_092805_E553137B)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit a2f73b6c5db3c ("cfg80211: move regulatory flags to their own variable")
renamed WIPHY_FLAG_CUSTOM_REGULATORY to REGULATORY_CUSTOM_REG, but missed to
update one comment.

Signed-off-by: Kalle Valo <kvalo@qca.qualcomm.com>
---
 include/net/cfg80211.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
index f3539a15c411..0442504b9164 100644
--- a/include/net/cfg80211.h
+++ b/include/net/cfg80211.h
@@ -3600,7 +3600,7 @@ int regulatory_hint(struct wiphy *wiphy, const char *alpha2);
  * default channel settings will be disregarded. If no rule is found for a
  * channel on the regulatory domain the channel will be disabled.
  * Drivers using this for a wiphy should also set the wiphy flag
- * WIPHY_FLAG_CUSTOM_REGULATORY or cfg80211 will set it for the wiphy
+ * REGULATORY_CUSTOM_REG or cfg80211 will set it for the wiphy
  * that called this helper.
  */
 void wiphy_apply_custom_regulatory(struct wiphy *wiphy,

