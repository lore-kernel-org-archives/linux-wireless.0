Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:48538 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752001AbdLBQ3G (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 2 Dec 2017 11:29:06 -0500
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Sat,  2 Dec 2017 18:28:45 +0200
Message-Id: <20171202162858.4167-3-luca@coelho.fi> (sfid-20171202_172953_767295_1278C15F)
In-Reply-To: <20171202162858.4167-1-luca@coelho.fi>
References: <20171202162858.4167-1-luca@coelho.fi>
Subject: [PATCH 02/15] iwlwifi: bump FW API to 36 for 8000 and up
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Load version 36 of the API for these devices, if available.  We
skipped version 35.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/22000.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c  | 4 ++--
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c  | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
index 28f6e63b9b67..48f6f80eb24b 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/22000.c
@@ -55,7 +55,7 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL_22000_UCODE_API_MAX	34
+#define IWL_22000_UCODE_API_MAX	36
 
 /* Lowest firmware API version supported */
 #define IWL_22000_UCODE_API_MIN	24
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/8000.c b/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
index 9bb7c19d48eb..3f4d9bac9f73 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
@@ -70,8 +70,8 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL8000_UCODE_API_MAX	34
-#define IWL8265_UCODE_API_MAX	34
+#define IWL8000_UCODE_API_MAX	36
+#define IWL8265_UCODE_API_MAX	36
 
 /* Lowest firmware API version supported */
 #define IWL8000_UCODE_API_MIN	22
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
index e7e75b458005..90a1d14cf7d2 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
@@ -55,7 +55,7 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL9000_UCODE_API_MAX	34
+#define IWL9000_UCODE_API_MAX	36
 
 /* Lowest firmware API version supported */
 #define IWL9000_UCODE_API_MIN	30
-- 
2.15.0
