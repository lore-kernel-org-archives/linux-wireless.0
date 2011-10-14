Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:58717 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932518Ab1JNUoh (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 16:44:37 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 3/6] iwlwifi: HW rev for 105 and 135 series
Date: Fri, 14 Oct 2011 12:54:45 -0700
Message-Id: <1318622088-14679-4-git-send-email-wey-yi.w.guy@intel.com> (sfid-20111014_224447_933107_F4EE4620)
In-Reply-To: <1318622088-14679-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1318622088-14679-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Set the HW rev. for both 105 and 135 series

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-csr.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index b9f3267..fbc3095 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -284,8 +284,8 @@
 #define CSR_HW_REV_TYPE_6x35	       CSR_HW_REV_TYPE_6x05
 #define CSR_HW_REV_TYPE_2x30	       (0x00000C0)
 #define CSR_HW_REV_TYPE_2x00	       (0x0000100)
-#define CSR_HW_REV_TYPE_200	       (0x0000110)
-#define CSR_HW_REV_TYPE_230	       (0x0000120)
+#define CSR_HW_REV_TYPE_105	       (0x0000110)
+#define CSR_HW_REV_TYPE_135	       (0x0000120)
 #define CSR_HW_REV_TYPE_NONE           (0x00001F0)
 
 /* EEPROM REG */
-- 
1.7.0.4

