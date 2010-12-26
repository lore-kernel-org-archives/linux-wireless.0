Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:32206 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752437Ab0LZS1v (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 26 Dec 2010 13:27:51 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 1/3] iwlwifi: remove extra string
Date: Sun, 26 Dec 2010 10:17:56 -0800
Message-Id: <1293387478-3297-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1293387478-3297-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1293387478-3297-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For "led_mode" module parameters, string "led_mode" is duplicated twice,
remove one.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-led.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-led.c b/drivers/net/wireless/iwlwifi/iwl-led.c
index 516e557..46ccdf4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-led.c
+++ b/drivers/net/wireless/iwlwifi/iwl-led.c
@@ -45,7 +45,7 @@
 /* default: IWL_LED_BLINK(0) using blinking index table */
 static int led_mode;
 module_param(led_mode, int, S_IRUGO);
-MODULE_PARM_DESC(led_mode, "led mode: 0=system default, "
+MODULE_PARM_DESC(led_mode, "0=system default, "
 		"1=On(RF On)/Off(RF Off), 2=blinking");
 
 static const struct {
-- 
1.7.0.4

