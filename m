Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail2.candelatech.com ([208.74.158.173]:58744 "EHLO
        mail2.candelatech.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751448AbdBXA3K (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 23 Feb 2017 19:29:10 -0500
From: greearb@candelatech.com
To: linux-wireless@vger.kernel.org
Cc: Ben Greear <greearb@candelatech.com>
Subject: [PATCH 100/306] mac80211-hwsim: remove dmesg spam about get-survey.
Date: Thu, 23 Feb 2017 16:28:24 -0800
Message-Id: <1487896109-23851-2-git-send-email-greearb@candelatech.com> (sfid-20170224_012922_949353_E2FF91A1)
In-Reply-To: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
References: <1487896109-23851-1-git-send-email-greearb@candelatech.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Greear <greearb@candelatech.com>

This message just fills up dmesg and/or kernel logs and does
not provide any useful information.

Signed-off-by: Ben Greear <greearb@candelatech.com>
---
 drivers/net/wireless/mac80211_hwsim.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/mac80211_hwsim.c b/drivers/net/wireless/mac80211_hwsim.c
index af53317..b8189b9 100644
--- a/drivers/net/wireless/mac80211_hwsim.c
+++ b/drivers/net/wireless/mac80211_hwsim.c
@@ -1848,7 +1848,7 @@ static int mac80211_hwsim_get_survey(
 {
 	struct ieee80211_conf *conf = &hw->conf;
 
-	wiphy_debug(hw->wiphy, "%s (idx=%d)\n", __func__, idx);
+	/* wiphy_debug(hw->wiphy, "%s (idx=%d)\n", __func__, idx); */
 
 	if (idx != 0)
 		return -ENOENT;
-- 
2.4.11
