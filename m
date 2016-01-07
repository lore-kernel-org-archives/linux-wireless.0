Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48375 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753421AbcAGMrz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 07:47:55 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/21] iwlwifi: mvm: bump max API to 20
Date: Thu,  7 Jan 2016 14:47:27 +0200
Message-Id: <1452170861-10060-7-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160107_134853_769353_71AADA5A)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

7265D and up are now able to handle -20.ucode.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-7000.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-8000.c | 2 +-
 drivers/net/wireless/intel/iwlwifi/iwl-9000.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
index d15117c..e60cf14 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
@@ -73,7 +73,7 @@
 /* Highest firmware API version supported */
 #define IWL7260_UCODE_API_MAX	17
 #define IWL7265_UCODE_API_MAX	17
-#define IWL7265D_UCODE_API_MAX	19
+#define IWL7265D_UCODE_API_MAX	20
 
 /* Oldest version we won't warn about */
 #define IWL7260_UCODE_API_OK	13
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
index dee4458..c84a029 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-8000.c
@@ -69,7 +69,7 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL8000_UCODE_API_MAX	19
+#define IWL8000_UCODE_API_MAX	20
 
 /* Oldest version we won't warn about */
 #define IWL8000_UCODE_API_OK	13
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
index 0d2aa1d..ecbf482 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-9000.c
@@ -55,7 +55,7 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL9000_UCODE_API_MAX	16
+#define IWL9000_UCODE_API_MAX	20
 
 /* Oldest version we won't warn about */
 #define IWL9000_UCODE_API_OK	13
-- 
2.5.0

