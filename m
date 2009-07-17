Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga14.intel.com ([143.182.124.37]:12884 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964869AbZGQQac (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2009 12:30:32 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 09/14] iwlwifi: update 1000 series API version to match firmware
Date: Fri, 17 Jul 2009 09:30:22 -0700
Message-Id: <1247848227-24031-10-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1247848227-24031-9-git-send-email-reinette.chatre@intel.com>
References: <1247848227-24031-1-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-2-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-3-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-4-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-5-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-6-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-7-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-8-git-send-email-reinette.chatre@intel.com>
 <1247848227-24031-9-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@intel.com>

firmware file now contains build number so API needs to be updated.

Signed-off-by: Jay Sternberg <jay.e.sternberg@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 7da52f1..a899be9 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -46,7 +46,7 @@
 #include "iwl-5000-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL1000_UCODE_API_MAX 2
+#define IWL1000_UCODE_API_MAX 3
 
 /* Lowest firmware API version supported */
 #define IWL1000_UCODE_API_MIN 1
-- 
1.5.6.3

