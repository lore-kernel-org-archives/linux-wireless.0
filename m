Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:17817 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1751136AbdAWWEH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 23 Jan 2017 17:04:07 -0500
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, luciano.coelho@intel.com
Date: Tue, 24 Jan 2017 00:03:32 +0200
Message-Id: <20170123220350.25305-8-luca@coelho.fi> (sfid-20170123_230424_278037_5A58B36D)
In-Reply-To: <20170123220350.25305-1-luca@coelho.fi>
References: <20170123220350.25305-1-luca@coelho.fi>
Subject: [PATCH 07/25] iwlwifi: mvm: bump max API to 28
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luca Coelho <luciano.coelho@intel.com>

We skipped one release, so bump twice, to 28.

Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-7000.c | 4 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c | 4 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-a000.c | 2 +-
 4 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
index d4b73dedf89b..a72e58623d3a 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
@@ -73,8 +73,8 @@
 /* Highest firmware API version supported */
 #define IWL7260_UCODE_API_MAX	17
 #define IWL7265_UCODE_API_MAX	17
-#define IWL7265D_UCODE_API_MAX	26
-#define IWL3168_UCODE_API_MAX	26
+#define IWL7265D_UCODE_API_MAX	28
+#define IWL3168_UCODE_API_MAX	28
 
 /* Lowest firmware API version supported */
 #define IWL7260_UCODE_API_MIN	17
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
index d02ca1491d16..df0fc24e99e1 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
@@ -70,8 +70,8 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL8000_UCODE_API_MAX	26
-#define IWL8265_UCODE_API_MAX	26
+#define IWL8000_UCODE_API_MAX	28
+#define IWL8265_UCODE_API_MAX	28
 
 /* Lowest firmware API version supported */
 #define IWL8000_UCODE_API_MIN	17
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
index ff850410d897..a5f0c0bf85ec 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
@@ -55,7 +55,7 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL9000_UCODE_API_MAX	26
+#define IWL9000_UCODE_API_MAX	28
 
 /* Lowest firmware API version supported */
 #define IWL9000_UCODE_API_MIN	17
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
index ea1618525878..82f18d967c40 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-a000.c
@@ -55,7 +55,7 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL_A000_UCODE_API_MAX	26
+#define IWL_A000_UCODE_API_MAX	28
 
 /* Lowest firmware API version supported */
 #define IWL_A000_UCODE_API_MIN	24
-- 
2.11.0
