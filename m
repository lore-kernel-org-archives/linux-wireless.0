Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:46214 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751330AbdH3J1i (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 30 Aug 2017 05:27:38 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Wed, 30 Aug 2017 12:27:31 +0300
Message-Id: <20170830092731.5284-1-luca@coelho.fi> (sfid-20170830_112742_691396_6F46085D)
Subject: [PATCH] iwlwifi: mvm: bump API to 34 for 8000 and up
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

These devices support -34.ucode, so load it.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/cfg/8000.c | 4 ++--
 drivers/net/wireless/intel/iwlwifi/cfg/9000.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/cfg/a000.c | 2 +-
 3 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/8000.c b/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
index 5081720608af..2e6c52664cee 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/8000.c
@@ -70,8 +70,8 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL8000_UCODE_API_MAX	33
-#define IWL8265_UCODE_API_MAX	33
+#define IWL8000_UCODE_API_MAX	34
+#define IWL8265_UCODE_API_MAX	34
 
 /* Lowest firmware API version supported */
 #define IWL8000_UCODE_API_MIN	22
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
index 97208ce19f92..2babe0a1f18b 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/9000.c
@@ -55,7 +55,7 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL9000_UCODE_API_MAX	33
+#define IWL9000_UCODE_API_MAX	34
 
 /* Lowest firmware API version supported */
 #define IWL9000_UCODE_API_MIN	30
diff --git a/drivers/net/wireless/intel/iwlwifi/cfg/a000.c b/drivers/net/wireless/intel/iwlwifi/cfg/a000.c
index dcd35b5c9d24..76ba1f8bc72f 100644
--- a/drivers/net/wireless/intel/iwlwifi/cfg/a000.c
+++ b/drivers/net/wireless/intel/iwlwifi/cfg/a000.c
@@ -55,7 +55,7 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL_A000_UCODE_API_MAX	33
+#define IWL_A000_UCODE_API_MAX	34
 
 /* Lowest firmware API version supported */
 #define IWL_A000_UCODE_API_MIN	24
-- 
2.14.1
