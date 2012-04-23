Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:58806 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755826Ab2DWVw5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 23 Apr 2012 17:52:57 -0400
From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes.berg@intel.com>,
	Wey-Yi Guy <wey-yi.w.guy@intel.com>
Subject: [PATCH 14/29] iwlwifi: move TIME_UNIT
Date: Mon, 23 Apr 2012 14:47:25 -0700
Message-Id: <1335217660-21950-15-git-send-email-wey-yi.w.guy@intel.com> (sfid-20120423_235304_157494_51E65E47)
In-Reply-To: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
References: <1335217660-21950-1-git-send-email-wey-yi.w.guy@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Johannes Berg <johannes.berg@intel.com>

We're getting rid of iwl-core.h, move TIME_UNIT out.

Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-agn.h  |    1 +
 drivers/net/wireless/iwlwifi/iwl-core.h |    2 --
 2 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-agn.h b/drivers/net/wireless/iwlwifi/iwl-agn.h
index 29d21c8..34900e6 100644
--- a/drivers/net/wireless/iwlwifi/iwl-agn.h
+++ b/drivers/net/wireless/iwlwifi/iwl-agn.h
@@ -82,6 +82,7 @@ extern struct iwl_lib_ops iwl6000_lib;
 extern struct iwl_lib_ops iwl6030_lib;
 
 
+#define TIME_UNIT		1024
 
 /*****************************************************
 * DRIVER STATUS FUNCTIONS
diff --git a/drivers/net/wireless/iwlwifi/iwl-core.h b/drivers/net/wireless/iwlwifi/iwl-core.h
index 6e5fb78..de7f6cd 100644
--- a/drivers/net/wireless/iwlwifi/iwl-core.h
+++ b/drivers/net/wireless/iwlwifi/iwl-core.h
@@ -72,8 +72,6 @@
 struct iwl_host_cmd;
 struct iwl_cmd;
 
-#define TIME_UNIT		1024
-
 /***************************
  *   L i b                 *
  ***************************/
-- 
1.7.0.4

