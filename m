Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:42518 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751392AbdHETnn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 5 Aug 2017 15:43:43 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Liad Kaufman <liad.kaufman@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  5 Aug 2017 22:43:20 +0300
Message-Id: <20170805194331.17426-9-luca@coelho.fi> (sfid-20170805_214356_240356_DF0C9A50)
In-Reply-To: <20170805194331.17426-1-luca@coelho.fi>
References: <20170805194331.17426-1-luca@coelho.fi>
Subject: [PATCH 08/19] iwlwifi: fix a000 RF_ID define
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Liad Kaufman <liad.kaufman@intel.com>

One of the defines has a wrong value.

Fixes: 1afb0ae42174 ("iwlwifi: allow combining different phy images with mac images")
Signed-off-by: Liad Kaufman <liad.kaufman@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-csr.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
index c6c1876c1ad4..560de9de5232 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-csr.h
@@ -356,7 +356,7 @@ enum {
 #define CSR_HW_REV_TYPE_NONE		(0x00001F0)
 
 /* RF_ID value */
-#define CSR_HW_RF_ID_TYPE_JF		(0x00105000)
+#define CSR_HW_RF_ID_TYPE_JF		(0x00105100)
 #define CSR_HW_RF_ID_TYPE_HR		(0x0010A000)
 #define CSR_HW_RF_ID_TYPE_HRCDB		(0x00109000)
 
-- 
2.13.2
