Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:32405 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754677Ab0I2A4z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 Sep 2010 20:56:55 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 5/5] iwlagn: API v5 for 6050 series device
Date: Tue, 28 Sep 2010 17:56:58 -0700
Message-Id: <1285721818-10281-6-git-send-email-wey-yi.w.guy@intel.com>
In-Reply-To: <1285721818-10281-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1285721818-10281-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For 6050 series device, change the supported API version

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index 51444c8..4d45932 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -51,7 +51,7 @@
 
 /* Highest firmware API version supported */
 #define IWL6000_UCODE_API_MAX 4
-#define IWL6050_UCODE_API_MAX 4
+#define IWL6050_UCODE_API_MAX 5
 #define IWL6000G2_UCODE_API_MAX 5
 
 /* Lowest firmware API version supported */
-- 
1.7.0.4

