Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:56356 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932236AbaLBSLy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:11:54 -0500
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	<stable@vger.kernel.org>
Subject: [PATCH 21/26] iwlwifi: mvm: update values for Smart Fifo
Date: Tue,  2 Dec 2014 20:11:12 +0200
Message-Id: <1417543877-24193-21-git-send-email-egrumbach@gmail.com> (sfid-20141202_191200_706905_EE5F30D5)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Interoperability issues were identified and root caused to
the Smart Fifo watermarks. These issues arose with
NetGear R7000. Fix this.

Cc: <stable@vger.kernel.org> [3.14+]
Fixes: 1f3b0ff8ecce ("iwlwifi: mvm: Add Smart FIFO support")
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api.h b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
index 01d6f9e..88af6dd 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api.h
@@ -1615,7 +1615,7 @@ enum iwl_sf_scenario {
 #define SF_NUM_TIMEOUT_TYPES 2		/* Aging timer and Idle timer */
 
 /* smart FIFO default values */
-#define SF_W_MARK_SISO 4096
+#define SF_W_MARK_SISO 6144
 #define SF_W_MARK_MIMO2 8192
 #define SF_W_MARK_MIMO3 6144
 #define SF_W_MARK_LEGACY 4096
-- 
1.9.1

