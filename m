Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:54140 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1954152AbdDYUXH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Apr 2017 16:23:07 -0400
From: Luca Coelho <luca@coelho.fi>
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Dor Shaish <dor.shaish@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Date: Tue, 25 Apr 2017 23:22:24 +0300
Message-Id: <20170425202243.7844-7-luca@coelho.fi> (sfid-20170425_222323_899143_546E24B7)
In-Reply-To: <20170425202243.7844-1-luca@coelho.fi>
References: <20170425202243.7844-1-luca@coelho.fi>
Subject: [PATCH 06/25] iwlwifi: mvm: freeze 7265D and 3168 on API version 29
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Dor Shaish <dor.shaish@intel.com>

iwl7265D and iwl3168 are frozen on API version 29.
Set the MAX API allowed level to 29 from now on.

Signed-off-by: Dor Shaish <dor.shaish@intel.com>
Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
---
 drivers/net/wireless/intel/iwlwifi/iwl-7000.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
index aeefd42d23ad..3b3e076571d6 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-7000.c
@@ -73,8 +73,8 @@
 /* Highest firmware API version supported */
 #define IWL7260_UCODE_API_MAX	17
 #define IWL7265_UCODE_API_MAX	17
-#define IWL7265D_UCODE_API_MAX	30
-#define IWL3168_UCODE_API_MAX	30
+#define IWL7265D_UCODE_API_MAX	29
+#define IWL3168_UCODE_API_MAX	29
 
 /* Lowest firmware API version supported */
 #define IWL7260_UCODE_API_MIN	17
-- 
2.11.0
