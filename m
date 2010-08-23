Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:27344 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753758Ab0HWOx1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Aug 2010 10:53:27 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 01/26] iwlwifi: update out-of-date comments
Date: Mon, 23 Aug 2010 07:56:52 -0700
Message-Id: <1282575437-23270-2-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1282575437-23270-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

No functional changes, update comments to match current file structure

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-3945-hw.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-5000-hw.h |    2 +-
 drivers/net/wireless/iwlwifi/iwl-6000-hw.h |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
index 7c731a7..a4a3194 100644
--- a/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-3945-hw.h
@@ -62,7 +62,7 @@
  *****************************************************************************/
 /*
  * Please use this file (iwl-3945-hw.h) only for hardware-related definitions.
- * Please use iwl-3945-commands.h for uCode API definitions.
+ * Please use iwl-commands.h for uCode API definitions.
  * Please use iwl-3945.h for driver implementation definitions.
  */
 
diff --git a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
index 146e643..3975e45 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-5000-hw.h
@@ -62,7 +62,7 @@
  *****************************************************************************/
 /*
  * Please use this file (iwl-5000-hw.h) only for hardware-related definitions.
- * Use iwl-5000-commands.h for uCode API definitions.
+ * Use iwl-commands.h for uCode API definitions.
  */
 
 #ifndef __iwl_5000_hw_h__
diff --git a/drivers/net/wireless/iwlwifi/iwl-6000-hw.h b/drivers/net/wireless/iwlwifi/iwl-6000-hw.h
index ddba399..47891e1 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000-hw.h
+++ b/drivers/net/wireless/iwlwifi/iwl-6000-hw.h
@@ -62,7 +62,7 @@
  *****************************************************************************/
 /*
  * Please use this file (iwl-6000-hw.h) only for hardware-related definitions.
- * Use iwl-5000-commands.h for uCode API definitions.
+ * Use iwl-commands.h for uCode API definitions.
  */
 
 #ifndef __iwl_6000_hw_h__
-- 
1.7.0.4

