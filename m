Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:58017 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755900Ab3GOLqx (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Jul 2013 07:46:53 -0400
From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
To: stable@vger.kernel.org
Cc: linux-wireless@vger.kernel.org
Subject: [PATCH RESEND 3.9 4/4] iwlwifi: bump required firmware API version for 3160/7260
Date: Mon, 15 Jul 2013 14:46:44 +0300
Message-Id: <1373888804-3077-5-git-send-email-emmanuel.grumbach@intel.com> (sfid-20130715_134659_846441_E36D00AF)
In-Reply-To: <1373888804-3077-1-git-send-email-emmanuel.grumbach@intel.com>
References: <1373888804-3077-1-git-send-email-emmanuel.grumbach@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

commit a2d0909a687b4d250cc2b7481072e361678745ba upstream.

As the firmware API has changed significantly and we don't
have support code for the old APIs, bump the version to be
able to release the version 7 API firmware.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
---
 drivers/net/wireless/iwlwifi/pcie/7000.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/pcie/7000.c b/drivers/net/wireless/iwlwifi/pcie/7000.c
index 6e35b2b..25c33b0 100644
--- a/drivers/net/wireless/iwlwifi/pcie/7000.c
+++ b/drivers/net/wireless/iwlwifi/pcie/7000.c
@@ -31,16 +31,16 @@
 #include "cfg.h"
 
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

