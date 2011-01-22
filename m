Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47747 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754942Ab1AVASX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 19:18:23 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 09/14] iwlwifi: add hw rev for 2000 series devices
Date: Fri, 21 Jan 2011 16:06:44 -0800
Message-Id: <1295654809-5790-10-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

2000 series device has different HW rev, add it

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-csr.h |    9 +++++++--
 1 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index cb77c0f..6c2b2df 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -290,7 +290,7 @@
 
 
 /* HW REV */
-#define CSR_HW_REV_TYPE_MSK            (0x00000F0)
+#define CSR_HW_REV_TYPE_MSK            (0x00001F0)
 #define CSR_HW_REV_TYPE_3945           (0x00000D0)
 #define CSR_HW_REV_TYPE_4965           (0x0000000)
 #define CSR_HW_REV_TYPE_5300           (0x0000020)
@@ -303,7 +303,12 @@
 #define CSR_HW_REV_TYPE_6150           (0x0000084)
 #define CSR_HW_REV_TYPE_6x05	       (0x00000B0)
 #define CSR_HW_REV_TYPE_6x30	       CSR_HW_REV_TYPE_6x05
-#define CSR_HW_REV_TYPE_NONE           (0x00000F0)
+#define CSR_HW_REV_TYPE_6x35	       CSR_HW_REV_TYPE_6x05
+#define CSR_HW_REV_TYPE_2x30	       (0x00000C0)
+#define CSR_HW_REV_TYPE_2x00	       (0x0000100)
+#define CSR_HW_REV_TYPE_200	       (0x0000110)
+#define CSR_HW_REV_TYPE_230	       (0x0000120)
+#define CSR_HW_REV_TYPE_NONE           (0x00001F0)
 
 /* EEPROM REG */
 #define CSR_EEPROM_REG_READ_VALID_MSK	(0x00000001)
-- 
1.7.0.4

