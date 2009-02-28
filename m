Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:23899 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752878AbZB1AQt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 19:16:49 -0500
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/6] iwlwifi: update 5150 API version to support new firmware
Date: Fri, 27 Feb 2009 16:21:19 -0800
Message-Id: <1235780484-27979-2-git-send-email-reinette.chatre@intel.com> (sfid-20090228_011656_639672_E9122DB3)
In-Reply-To: <1235780484-27979-1-git-send-email-reinette.chatre@intel.com>
References: <1235780484-27979-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@linux.intel.com>

update API to support new numbering that is used for other newer devices.
5150 ucode has not been released yet, so the first released API will be v2.
For those who do have a v1 API the driver does have backward compatibility
support new value of REPLY_TX_POWER_DBM_CMD

Signed-off-by: Jay Sternberg <jay.e.sternberg@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index ab39f4a..08c19be 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -47,7 +47,7 @@
 
 /* Highest firmware API version supported */
 #define IWL5000_UCODE_API_MAX 1
-#define IWL5150_UCODE_API_MAX 1
+#define IWL5150_UCODE_API_MAX 2
 
 /* Lowest firmware API version supported */
 #define IWL5000_UCODE_API_MIN 1
-- 
1.5.6.3

