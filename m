Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:62736 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752627Ab3ABOWH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 09:22:07 -0500
From: Julian Wollrath <jwollrath@web.de>
To: linux-wireless@vger.kernel.org
Cc: Julian Wollrath <jwollrath@web.de>
Subject: [PATCH] Fix typo in debug output of rtl8192c and rtl8723ae
Date: Wed,  2 Jan 2013 15:21:56 +0100
Message-Id: <1357136516-8841-1-git-send-email-jwollrath@web.de> (sfid-20130102_152211_661525_99394621)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Julian Wollrath <jwollrath@web.de>
---
 drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c |    2 +-
 drivers/net/wireless/rtlwifi/rtl8723ae/phy.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c b/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
index 1d5d360..246e535 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
+++ b/drivers/net/wireless/rtlwifi/rtl8192c/phy_common.c
@@ -692,7 +692,7 @@ u8 rtl92c_phy_sw_chnl(struct ieee80211_hw *hw)
 	if (!(is_hal_stop(rtlhal)) && !(RT_CANNOT_IO(hw))) {
 		rtl92c_phy_sw_chnl_callback(hw);
 		RT_TRACE(rtlpriv, COMP_CHAN, DBG_LOUD,
-			 "sw_chnl_inprogress false schdule workitem\n");
+			 "sw_chnl_inprogress false schedule workitem\n");
 		rtlphy->sw_chnl_inprogress = false;
 	} else {
 		RT_TRACE(rtlpriv, COMP_CHAN, DBG_LOUD,
diff --git a/drivers/net/wireless/rtlwifi/rtl8723ae/phy.c b/drivers/net/wireless/rtlwifi/rtl8723ae/phy.c
index 39cc793..3d8536b 100644
--- a/drivers/net/wireless/rtlwifi/rtl8723ae/phy.c
+++ b/drivers/net/wireless/rtlwifi/rtl8723ae/phy.c
@@ -1106,7 +1106,7 @@ u8 rtl8723ae_phy_sw_chnl(struct ieee80211_hw *hw)
 	if (!(is_hal_stop(rtlhal)) && !(RT_CANNOT_IO(hw))) {
 		rtl8723ae_phy_sw_chnl_callback(hw);
 		RT_TRACE(rtlpriv, COMP_CHAN, DBG_LOUD,
-			 "sw_chnl_inprogress false schdule workitem\n");
+			 "sw_chnl_inprogress false schedule workitem\n");
 		rtlphy->sw_chnl_inprogress = false;
 	} else {
 		RT_TRACE(rtlpriv, COMP_CHAN, DBG_LOUD,
-- 
1.7.10.4

