Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54944 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1752666AbcIOSNX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 15 Sep 2016 14:13:23 -0400
From: Luca Coelho <luca@coelho.fi>
To: kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Thu, 15 Sep 2016 21:11:26 +0300
Message-Id: <20160915181131.32213-20-luca@coelho.fi> (sfid-20160915_201346_798320_5D207841)
In-Reply-To: <1473962425.5664.41.camel@coelho.fi>
References: <1473962425.5664.41.camel@coelho.fi>
Subject: [PATCH 20/25] iwlwifi: mvm: bump max API to 26
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

The driver now support version 26 of the firmware APIs.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-7000.c | 4 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c | 4 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-a000.c | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
index 64690c14..aa575fb 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
@@ -73,8 +73,8 @@
 /* Highest firmware API version supported */
 #define IWL7260_UCODE_API_MAX	17
 #define IWL7265_UCODE_API_MAX	17
-#define IWL7265D_UCODE_API_MAX	24
-#define IWL3168_UCODE_API_MAX	24
+#define IWL7265D_UCODE_API_MAX	26
+#define IWL3168_UCODE_API_MAX	26
 
 /* Lowest firmware API version supported */
 #define IWL7260_UCODE_API_MIN	16
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
index cde4f26..990cf2b 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
@@ -70,8 +70,8 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL8000_UCODE_API_MAX	24
-#define IWL8265_UCODE_API_MAX	24
+#define IWL8000_UCODE_API_MAX	26
+#define IWL8265_UCODE_API_MAX	26
 
 /* Lowest firmware API version supported */
 #define IWL8000_UCODE_API_MIN	16
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
index 4d68985..a2c7946 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
@@ -55,7 +55,7 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL9000_UCODE_API_MAX	24
+#define IWL9000_UCODE_API_MAX	26
 
 /* Lowest firmware API version supported */
 #define IWL9000_UCODE_API_MIN	16
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
index 4d78232..ea16185 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
@@ -55,7 +55,7 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL_A000_UCODE_API_MAX	24
+#define IWL_A000_UCODE_API_MAX	26
 
 /* Lowest firmware API version supported */
 #define IWL_A000_UCODE_API_MIN	24
-- 
2.9.3
