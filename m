Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:48833 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751184AbbKOTeK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Nov 2015 14:34:10 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 2/4] iwlwifi: bump firmware API to 19
Date: Sun, 15 Nov 2015 21:34:03 +0200
Message-Id: <1447616045-31484-2-git-send-email-emmanuel.grumbach@intel.com> (sfid-20151115_203419_348999_73435913)
In-Reply-To: <1447616045-31484-1-git-send-email-emmanuel.grumbach@intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E8EAF98@hasmsx107.ger.corp.intel.com>
 <1447616045-31484-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This firmware will be the first firmware to support
3168. It hasn't been released yet.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c | 2 +-
 drivers/net/wireless/iwlwifi/iwl-8000.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 1a73c7a..bf88ec3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -69,7 +69,7 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL7260_UCODE_API_MAX	17
+#define IWL7260_UCODE_API_MAX	19
 
 /* Oldest version we won't warn about */
 #define IWL7260_UCODE_API_OK	13
diff --git a/drivers/net/wireless/iwlwifi/iwl-8000.c b/drivers/net/wireless/iwlwifi/iwl-8000.c
index 0116e5a..9bcc0bf 100644
--- a/drivers/net/wireless/iwlwifi/iwl-8000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-8000.c
@@ -69,7 +69,7 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL8000_UCODE_API_MAX	17
+#define IWL8000_UCODE_API_MAX	19
 
 /* Oldest version we won't warn about */
 #define IWL8000_UCODE_API_OK	13
-- 
2.5.0

