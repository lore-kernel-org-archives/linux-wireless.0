Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:36344 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1753422AbdF2Sbu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Jun 2017 14:31:50 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 29 Jun 2017 21:30:27 +0300
Message-Id: <20170629183027.15408-16-luca@coelho.fi> (sfid-20170629_203159_007182_1C64CB2D)
In-Reply-To: <20170629183027.15408-1-luca@coelho.fi>
References: <20170629183027.15408-1-luca@coelho.fi>
Subject: [PATCH 15/15] iwlwifi: bump MAX API for 8000/9000/A000 to 33
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Bump the maximum API supported by these device families to 33.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c | 4 ++--
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/a000.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/8000.c b/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
index 766bb2037b94..5081720608af 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
@@ -70,8 +70,8 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL8000_UCODE_API_MAX	31
-#define IWL8265_UCODE_API_MAX	31
+#define IWL8000_UCODE_API_MAX	33
+#define IWL8265_UCODE_API_MAX	33
 
 /* Lowest firmware API version supported */
 #define IWL8000_UCODE_API_MIN	22
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
index 42daaddfa740..b4ecd1fe1374 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
@@ -55,7 +55,7 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL9000_UCODE_API_MAX	31
+#define IWL9000_UCODE_API_MAX	33
 
 /* Lowest firmware API version supported */
 #define IWL9000_UCODE_API_MIN	30
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/a000.c b/drivers/net/wireless/intel/iwlwifi/cfg/a000.c
index 2940c0a6c3d6..98f24cd1b44f 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/a000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/a000.c
@@ -55,7 +55,7 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL_A000_UCODE_API_MAX	31
+#define IWL_A000_UCODE_API_MAX	33
 
 /* Lowest firmware API version supported */
 #define IWL_A000_UCODE_API_MIN	24
-- 
2.11.0
