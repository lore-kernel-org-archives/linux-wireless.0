Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:50550 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1754809AbdDKMiL (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 11 Apr 2017 08:38:11 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 11 Apr 2017 15:37:22 +0300
Message-Id: <20170411123742.12214-6-luca@coelho.fi> (sfid-20170411_144103_462142_AB1FA53B)
In-Reply-To: <20170411123742.12214-1-luca@coelho.fi>
References: <20170411123742.12214-1-luca@coelho.fi>
Subject: [PATCH 05/25] iwlwifi: mvm: bump max API to 30
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-7000.c | 4 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c | 4 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-a000.c | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
index a72e58623d3a..aeefd42d23ad 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
@@ -73,8 +73,8 @@
 /* Highest firmware API version supported */
 #define IWL7260_UCODE_API_MAX	17
 #define IWL7265_UCODE_API_MAX	17
-#define IWL7265D_UCODE_API_MAX	28
-#define IWL3168_UCODE_API_MAX	28
+#define IWL7265D_UCODE_API_MAX	30
+#define IWL3168_UCODE_API_MAX	30
 
 /* Lowest firmware API version supported */
 #define IWL7260_UCODE_API_MIN	17
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
index b7953bf55f6f..b9718c0cf174 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
@@ -70,8 +70,8 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL8000_UCODE_API_MAX	28
-#define IWL8265_UCODE_API_MAX	28
+#define IWL8000_UCODE_API_MAX	30
+#define IWL8265_UCODE_API_MAX	30
 
 /* Lowest firmware API version supported */
 #define IWL8000_UCODE_API_MIN	17
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
index ca119bd8a32b..da58ece2286a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
@@ -55,7 +55,7 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL9000_UCODE_API_MAX	28
+#define IWL9000_UCODE_API_MAX	30
 
 /* Lowest firmware API version supported */
 #define IWL9000_UCODE_API_MIN	17
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
index 15dd7f6137c8..20739e92aef6 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
@@ -55,7 +55,7 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL_A000_UCODE_API_MAX	28
+#define IWL_A000_UCODE_API_MAX	30
 
 /* Lowest firmware API version supported */
 #define IWL_A000_UCODE_API_MIN	24
-- 
2.11.0
