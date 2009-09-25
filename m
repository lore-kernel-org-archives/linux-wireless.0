Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:1107 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752374AbZIYVY3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Sep 2009 17:24:29 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Huaxu Wan <huaxu.wan@linux.intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 8/8] iwlwifi: add module firmware info for 1000 series
Date: Fri, 25 Sep 2009 14:24:28 -0700
Message-Id: <1253913868-8400-9-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1253913868-8400-1-git-send-email-reinette.chatre@intel.com>
References: <1253913868-8400-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Huaxu Wan <huaxu.wan@linux.intel.com>

The module firmware information of 1000 series is missing from iwlagn.

Signed-off-by: Huaxu Wan <huaxu.wan@linux.intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-1000.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-1000.c b/drivers/net/wireless/iwlwifi/iwl-1000.c
index 9dfd4c4..af91dba 100644
--- a/drivers/net/wireless/iwlwifi/iwl-1000.c
+++ b/drivers/net/wireless/iwlwifi/iwl-1000.c
@@ -189,3 +189,4 @@ struct iwl_cfg iwl1000_bg_cfg = {
 	.chain_noise_num_beacons = IWL_CAL_NUM_BEACONS,
 };
 
+MODULE_FIRMWARE(IWL1000_MODULE_FIRMWARE(IWL1000_UCODE_API_MAX));
-- 
1.5.6.3

