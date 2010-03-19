Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:55370 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751854Ab0CSVON (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Mar 2010 17:14:13 -0400
From: Reinette Chatre <reinette.chatre@intel.com>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Ben Cahill <ben.m.cahill@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>
Subject: [PATCH 1/9] iwlagn: Add Flow-handler (FH) register dump for 4965.
Date: Fri, 19 Mar 2010 14:14:03 -0700
Message-Id: <1269033251-17545-2-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1269033251-17545-1-git-send-email-reinette.chatre@intel.com>
References: <1269033251-17545-1-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ben Cahill <ben.m.cahill@intel.com>

FH register dump debug feature was recently added for 5000 and later;
4965 can use it also.

Signed-off-by: Ben Cahill <ben.m.cahill@intel.com>
Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-4965.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-4965.c b/drivers/net/wireless/iwlwifi/iwl-4965.c
index 644aacf..271576a 100644
--- a/drivers/net/wireless/iwlwifi/iwl-4965.c
+++ b/drivers/net/wireless/iwlwifi/iwl-4965.c
@@ -2187,6 +2187,7 @@ static struct iwl_lib_ops iwl4965_lib = {
 	.load_ucode = iwl4965_load_bsm,
 	.dump_nic_event_log = iwl_dump_nic_event_log,
 	.dump_nic_error_log = iwl_dump_nic_error_log,
+	.dump_fh = iwl_dump_fh,
 	.set_channel_switch = iwl4965_hw_channel_switch,
 	.apm_ops = {
 		.init = iwl_apm_init,
-- 
1.6.3.3

