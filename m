Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f43.google.com ([74.125.82.43]:35534 "EHLO
	mail-wm0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063AbcE0LZk (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 May 2016 07:25:40 -0400
Received: by mail-wm0-f43.google.com with SMTP id a136so68103227wme.0
        for <linux-wireless@vger.kernel.org>; Fri, 27 May 2016 04:25:39 -0700 (PDT)
From: Eduardo Abinader <eabinader@ocedo.com>
To: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Cc: Eduardo Abinader <eduardo.abinader@riverbed.com>,
	johannes.berg@intel.com
Subject: [PATCH] cfg80211: remove extra space on alpha2 definition
Date: Fri, 27 May 2016 13:25:31 +0200
Message-Id: <1464348331-585-1-git-send-email-eduardo.abinader@riverbed.com> (sfid-20160527_132544_344992_D6BD620E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just small adjustment.

Signed-off-by: Eduardo Abinader <eduardo.abinader@riverbed.com>
---
 net/wireless/reg.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/wireless/reg.c b/net/wireless/reg.c
index 5dbac37..5e3394d 100644
--- a/net/wireless/reg.c
+++ b/net/wireless/reg.c
@@ -217,7 +217,7 @@ static DECLARE_WORK(reg_work, reg_todo);
 /* We keep a static world regulatory domain in case of the absence of CRDA */
 static const struct ieee80211_regdomain world_regdom = {
 	.n_reg_rules = 8,
-	.alpha2 =  "00",
+	.alpha2 = "00",
 	.reg_rules = {
 		/* IEEE 802.11b/g, channels 1..11 */
 		REG_RULE(2412-10, 2462+10, 40, 6, 20, 0),
-- 
2.5.0

