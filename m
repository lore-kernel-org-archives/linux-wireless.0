Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:63818 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753451AbcAGMrv (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jan 2016 07:47:51 -0500
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 06/21] iwlwifi: set max firmware version of 7265 to 17
Date: Thu,  7 Jan 2016 14:47:26 +0200
Message-Id: <1452170861-10060-6-git-send-email-emmanuel.grumbach@intel.com> (sfid-20160107_134901_328039_4738963B)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB32E9836B4@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Just like 7260, 7265 will not have firmware releases newer
than iwlwifi-7265-17.ucode. 7265D is still supported in
latest firmware releases.

Fixes: 628a2918afe4 ("iwlwifi: separate firmware version for 7260 devices")
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-7000.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
index fd9064b..d15117c 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
@@ -72,7 +72,7 @@
 
 /* Highest firmware API version supported */
 #define IWL7260_UCODE_API_MAX	17
-#define IWL7265_UCODE_API_MAX	19
+#define IWL7265_UCODE_API_MAX	17
 #define IWL7265D_UCODE_API_MAX	19
 
 /* Oldest version we won't warn about */
-- 
2.5.0

