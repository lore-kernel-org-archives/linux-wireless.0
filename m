Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:39253 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752356AbbHRH6h (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 03:58:37 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 23/26] iwlwifi: bump mvm firmware API to 16
Date: Tue, 18 Aug 2015 10:57:33 +0300
Message-Id: <1439884656-18146-23-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150818_100109_154053_690D5CBD)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8110F8@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The driver is now able to handle -16.ucode.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c | 2 +-
 drivers/net/wireless/iwlwifi/iwl-8000.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index fa35da4..413b63e 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -69,7 +69,7 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL7260_UCODE_API_MAX	15
+#define IWL7260_UCODE_API_MAX	16
 
 /* Oldest version we won't warn about */
 #define IWL7260_UCODE_API_OK	12
diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 92709ad..8324bc8 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -69,7 +69,7 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL8000_UCODE_API_MAX	15
+#define IWL8000_UCODE_API_MAX	16
 
 /* Oldest version we won't warn about */
 #define IWL8000_UCODE_API_OK	12
-- 
2.1.4

