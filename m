Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:47749 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab1AVASX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Jan 2011 19:18:23 -0500
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 08/14] iwlwifi: remove g2 from csr hw rev
Date: Fri, 21 Jan 2011 16:06:43 -0800
Message-Id: <1295654809-5790-9-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1295654809-5790-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Remove refernce of g2 and use offical number for hw rev.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-csr.h |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-csr.h b/drivers/net/wireless/iwlwifi/iwl-csr.h
index b80bf7d..cb77c0f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/iwlwifi/iwl-csr.h
@@ -300,8 +300,9 @@
 #define CSR_HW_REV_TYPE_1000           (0x0000060)
 #define CSR_HW_REV_TYPE_6x00           (0x0000070)
 #define CSR_HW_REV_TYPE_6x50           (0x0000080)
-#define CSR_HW_REV_TYPE_6x50g2         (0x0000084)
-#define CSR_HW_REV_TYPE_6x00g2         (0x00000B0)
+#define CSR_HW_REV_TYPE_6150           (0x0000084)
+#define CSR_HW_REV_TYPE_6x05	       (0x00000B0)
+#define CSR_HW_REV_TYPE_6x30	       CSR_HW_REV_TYPE_6x05
 #define CSR_HW_REV_TYPE_NONE           (0x00000F0)
 
 /* EEPROM REG */
-- 
1.7.0.4

