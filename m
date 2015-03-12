Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:14617 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754525AbbCLNFt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2015 09:05:49 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 20/49] iwlwifi: bump API to 13 for devices that use iwlmvm
Date: Thu, 12 Mar 2015 15:04:05 +0200
Message-Id: <1426165474-25586-20-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150312_140755_135316_BD4AD587)
In-Reply-To: <1426164431.19690.4.camel@egrumbacBox>
References: <1426164431.19690.4.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This new firmware will come out soon.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c | 8 ++++----
 drivers/net/wireless/iwlwifi/iwl-8000.c | 4 ++--
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 0597a9c..36e786f 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -69,12 +69,12 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL7260_UCODE_API_MAX	12
-#define IWL3160_UCODE_API_MAX	12
+#define IWL7260_UCODE_API_MAX	13
+#define IWL3160_UCODE_API_MAX	13
 
 /* Oldest version we won't warn about */
-#define IWL7260_UCODE_API_OK	10
-#define IWL3160_UCODE_API_OK	10
+#define IWL7260_UCODE_API_OK	12
+#define IWL3160_UCODE_API_OK	12
 
 /* Lowest firmware API version supported */
 #define IWL7260_UCODE_API_MIN	10
diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index d8dfa6d..9c396a4 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -69,10 +69,10 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL8000_UCODE_API_MAX	12
+#define IWL8000_UCODE_API_MAX	13
 
 /* Oldest version we won't warn about */
-#define IWL8000_UCODE_API_OK	10
+#define IWL8000_UCODE_API_OK	12
 
 /* Lowest firmware API version supported */
 #define IWL8000_UCODE_API_MIN	10
-- 
1.9.1

