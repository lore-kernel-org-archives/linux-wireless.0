Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:50845 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757397Ab1DHPuN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Apr 2011 11:50:13 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/16] iwlagn: remove more reference to legacy devices
Date: Fri,  8 Apr 2011 08:30:29 -0700
Message-Id: <1302276636-12802-10-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1302276636-12802-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove the reference to both 3945 and 4965 in LED code

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-led.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index c2862d4..0d90004 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -63,8 +63,8 @@ static const struct ieee80211_tpt_blink iwl_blink[] = {
 
 /*
  * Adjust led blink rate to compensate on a MAC Clock difference on every HW
- * Led blink rate analysis showed an average deviation of 0% on 3945,
- * 5% on 4965 HW and 20% on 5000 series and up.
+ * Led blink rate analysis showed an average deviation of 20% on 5000 series
+ * and up.
  * Need to compensate on the led on/off time per HW according to the deviation
  * to achieve the desired led frequency
  * The calculation is: (100-averageDeviation)/100 * blinkTime
-- 
1.7.0.4

