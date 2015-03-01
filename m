Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:24060 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753018AbbCATcS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 1 Mar 2015 14:32:18 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Luciano Coelho <luciano.coelho@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 14/31] iwlwifi: deprecate -9.ucode for 3160 / 7260 / 7265
Date: Sun,  1 Mar 2015 21:31:27 +0200
Message-Id: <1425238304-498-14-git-send-email-emmanuel.grumbach@intel.com> (sfid-20150301_203417_487184_1D25A004)
In-Reply-To: <1425238186.30202.5.camel@egrumbacBox>
References: <1425238186.30202.5.camel@egrumbacBox>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luciano Coelho <luciano.coelho@intel.com>

This firmware is not supported anymore.  Stop loading this firmware.

Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c | 4 ++--
 drivers/net/wireless/iwlwifi/iwl-8000.c | 2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 97e38d2..0597a9c 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -77,8 +77,8 @@
 #define IWL3160_UCODE_API_OK	10
 
 /* Lowest firmware API version supported */
-#define IWL7260_UCODE_API_MIN	9
-#define IWL3160_UCODE_API_MIN	9
+#define IWL7260_UCODE_API_MIN	10
+#define IWL3160_UCODE_API_MIN	10
 
 /* NVM versions */
 #define IWL7260_NVM_VERSION		0x0a1d
diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 2f7fe81..d8dfa6d 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -75,7 +75,7 @@
 #define IWL8000_UCODE_API_OK	10
 
 /* Lowest firmware API version supported */
-#define IWL8000_UCODE_API_MIN	9
+#define IWL8000_UCODE_API_MIN	10
 
 /* NVM versions */
 #define IWL8000_NVM_VERSION		0x0a1d
-- 
1.9.1

