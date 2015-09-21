Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:45737 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756490AbbIUU7O (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Sep 2015 16:59:14 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
	Luciano Coelho <luciano.coelho@intel.com>
Date: Mon, 21 Sep 2015 23:58:48 +0300
Message-Id: <1442869141-31637-8-git-send-email-luca@coelho.fi> (sfid-20150921_230041_157321_27CA5549)
In-Reply-To: <1442868938.27148.361.camel@coelho.fi>
References: <1442868938.27148.361.camel@coelho.fi>
Subject: [PATCH 08/21] iwlwifi: mvm: don't load -12.ucode anymore
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

-13.ucode has been published long ago. Deprecate old
versions of the firmware.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Signed-off-by: Luciano Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c | 4 ++--
 drivers/net/wireless/iwlwifi/iwl-8000.c | 4 ++--
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 6951aba..22c2430 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -72,11 +72,11 @@
 #define IWL7260_UCODE_API_MAX	17
 
 /* Oldest version we won't warn about */
-#define IWL7260_UCODE_API_OK	12
+#define IWL7260_UCODE_API_OK	13
 #define IWL3165_UCODE_API_OK	13
 
 /* Lowest firmware API version supported */
-#define IWL7260_UCODE_API_MIN	12
+#define IWL7260_UCODE_API_MIN	13
 #define IWL3165_UCODE_API_MIN	13
 
 /* NVM versions */
diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 197abe4..6efef46 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -72,10 +72,10 @@
 #define IWL8000_UCODE_API_MAX	17
 
 /* Oldest version we won't warn about */
-#define IWL8000_UCODE_API_OK	12
+#define IWL8000_UCODE_API_OK	13
 
 /* Lowest firmware API version supported */
-#define IWL8000_UCODE_API_MIN	12
+#define IWL8000_UCODE_API_MIN	13
 
 /* NVM versions */
 #define IWL8000_NVM_VERSION		0x0a1d
-- 
2.5.1

