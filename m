Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:24351 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbZJWUms (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Oct 2009 16:42:48 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 16/18] iwlwifi: update lowest API version support for 6x00 & 6x50 series
Date: Fri, 23 Oct 2009 13:42:34 -0700
Message-Id: <1256330556-20997-17-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
References: <1256330556-20997-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Wey-Yi Guy <wey-yi.w.guy@intel.com>

For 6x00 and 6x50 series devices, APIv4 is the lowest firmware version
driver can support. This is also the lowest API version available to the
public so there is no need for backward compatibility support for the
earlier API versions.

Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-6000.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-6000.c b/drivers/net/wireless/iwlwifi/iwl-6000.c
index f5639b4..32466d3 100644
--- a/drivers/net/wireless/iwlwifi/iwl-6000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-6000.c
@@ -52,8 +52,8 @@
 #define IWL6050_UCODE_API_MAX 4
 
 /* Lowest firmware API version supported */
-#define IWL6000_UCODE_API_MIN 1
-#define IWL6050_UCODE_API_MIN 1
+#define IWL6000_UCODE_API_MIN 4
+#define IWL6050_UCODE_API_MIN 4
 
 #define IWL6000_FW_PRE "iwlwifi-6000-"
 #define _IWL6000_MODULE_FIRMWARE(api) IWL6000_FW_PRE #api ".ucode"
-- 
1.5.6.3

