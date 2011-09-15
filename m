Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:38702 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934544Ab1IOTcI (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Sep 2011 15:32:08 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 17/27] iwlagn: Makefile whitespace cleanup
Date: Thu, 15 Sep 2011 11:46:44 -0700
Message-Id: <1316112414-6341-18-git-send-email-wey-yi.w.guy@intel.com> (sfid-20110915_213319_653766_20B3F4D2)
In-Reply-To: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1316112414-6341-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/Makefile |   20 ++++++++++----------
 1 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/Makefile b/drivers/net/wireless/iwlwifi/Makefile
index a7e954b..8fa59cd 100644
--- a/drivers/net/wireless/iwlwifi/Makefile
+++ b/drivers/net/wireless/iwlwifi/Makefile
@@ -5,17 +5,17 @@ iwlagn-objs		+= iwl-agn-ucode.o iwl-agn-tx.o
 iwlagn-objs		+= iwl-agn-lib.o iwl-agn-calib.o iwl-io.o
 iwlagn-objs		+= iwl-agn-tt.o iwl-agn-sta.o
 
-iwlagn-objs 		+= iwl-core.o iwl-eeprom.o iwl-power.o
-iwlagn-objs 		+= iwl-rx.o iwl-sta.o
-iwlagn-objs 		+= iwl-scan.o iwl-led.o
-iwlagn-objs             += iwl-agn-rxon.o
-iwlagn-objs             += iwl-5000.o
-iwlagn-objs             += iwl-6000.o
-iwlagn-objs             += iwl-1000.o
-iwlagn-objs             += iwl-2000.o
-iwlagn-objs             += iwl-pci.o
+iwlagn-objs		+= iwl-core.o iwl-eeprom.o iwl-power.o
+iwlagn-objs		+= iwl-rx.o iwl-sta.o
+iwlagn-objs		+= iwl-scan.o iwl-led.o
+iwlagn-objs		+= iwl-agn-rxon.o
+iwlagn-objs		+= iwl-5000.o
+iwlagn-objs		+= iwl-6000.o
+iwlagn-objs		+= iwl-1000.o
+iwlagn-objs		+= iwl-2000.o
+iwlagn-objs		+= iwl-pci.o
 iwlagn-objs		+= iwl-trans.o
-iwlagn-objs             += iwl-trans-pcie.o iwl-trans-pcie-rx.o iwl-trans-pcie-tx.o
+iwlagn-objs		+= iwl-trans-pcie.o iwl-trans-pcie-rx.o iwl-trans-pcie-tx.o
 
 iwlagn-$(CONFIG_IWLWIFI_DEBUGFS) += iwl-debugfs.o
 iwlagn-$(CONFIG_IWLWIFI_DEVICE_TRACING) += iwl-devtrace.o
-- 
1.7.0.4

