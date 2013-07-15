Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:34251 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755713Ab3GOLpP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 07:45:15 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: stable@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH 3.10 3/3] iwlwifi: bump required firmware API version for 3160/7260
Date: Mon, 15 Jul 2013 14:45:00 +0300
Message-Id: <1373888700-3040-4-git-send-email-emmanuel.grumbach@intel.com> (sfid-20130715_134521_703782_02E10871)
In-Reply-To: <1373888700-3040-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1373888700-3040-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

commit a2d0909a687b4d250cc2b7481072e361678745ba upstream.

As the firmware API has changed significantly and we don't
have support code for the old APIs, bump the version to be
able to release the version 7 API firmware.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-7000.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-7000.c b/drivers/net/wireless/iwlwifi/iwl-7000.c
index 50263e8..dc94d44 100644
--- a/drivers/net/wireless/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-7000.c
@@ -67,16 +67,16 @@
 #include "iwl-agn-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL7260_UCODE_API_MAX	6
-#define IWL3160_UCODE_API_MAX	6
+#define IWL7260_UCODE_API_MAX	7
+#define IWL3160_UCODE_API_MAX	7
 
 /* Oldest version we won't warn about */
-#define IWL7260_UCODE_API_OK	6
-#define IWL3160_UCODE_API_OK	6
+#define IWL7260_UCODE_API_OK	7
+#define IWL3160_UCODE_API_OK	7
 
 /* Lowest firmware API version supported */
-#define IWL7260_UCODE_API_MIN	6
-#define IWL3160_UCODE_API_MIN	6
+#define IWL7260_UCODE_API_MIN	7
+#define IWL3160_UCODE_API_MIN	7
 
 /* NVM versions */
 #define IWL7260_NVM_VERSION		0x0a1d
-- 
1.7.10.4

