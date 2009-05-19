Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:42233 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751361AbZESVt4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 17:49:56 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Jay Sternberg <jay.e.sternberg@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH v2.6.30 and w-t] iwlwifi: update 5000 ucode support to version 2 of API
Date: Tue, 19 May 2009 14:56:36 -0700
Message-Id: <1242770196-31072-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jay Sternberg <jay.e.sternberg@linux.intel.com>

enable iwl driver to support 5000 ucode having version 2 of API

Signed-off-by: Jay Sternberg <jay.e.sternberg@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
This ucode indicates an API change. The backward compatibility support
can already be found in 2.6.30 and wireless-testing in commit
964c32bdc88b3d15dce34bb9ed0903e78e95fd57 "iwlwifi: correct API command
overlap"

Announcement of ucode availability to follow shortly.

 drivers/net/wireless/iwlwifi/iwl-5000.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-5000.c b/drivers/net/wireless/iwlwifi/iwl-5000.c
index e61b67d..3681315 100644
--- a/drivers/net/wireless/iwlwifi/iwl-5000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-5000.c
@@ -46,7 +46,7 @@
 #include "iwl-6000-hw.h"
 
 /* Highest firmware API version supported */
-#define IWL5000_UCODE_API_MAX 1
+#define IWL5000_UCODE_API_MAX 2
 #define IWL5150_UCODE_API_MAX 2
 
 /* Lowest firmware API version supported */
-- 
1.5.6.3

