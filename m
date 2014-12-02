Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:35215 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613AbaLBSLp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:11:45 -0500
Received: by mail-wi0-f172.google.com with SMTP id n3so28881258wiv.5
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 10:11:44 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: David Spinadel <david.spinadel@intel.com>,
	Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 15/26] iwlwifi: mvm: remove a dangling line of documentation
Date: Tue,  2 Dec 2014 20:11:06 +0200
Message-Id: <1417543877-24193-15-git-send-email-egrumbach@gmail.com> (sfid-20141202_191347_340691_56C9B534)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: David Spinadel <david.spinadel@intel.com>

Signed-off-by: David Spinadel <david.spinadel@intel.com>
Reviewed-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/mvm.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/mvm.h b/drivers/net/wireless/iwlwifi/mvm/mvm.h
index bb7953b..12be7f3 100644
--- a/drivers/net/wireless/iwlwifi/mvm/mvm.h
+++ b/drivers/net/wireless/iwlwifi/mvm/mvm.h
@@ -295,7 +295,6 @@ enum iwl_bt_force_ant_mode {
 * struct iwl_mvm_vif_bf_data - beacon filtering related data
 * @bf_enabled: indicates if beacon filtering is enabled
 * @ba_enabled: indicated if beacon abort is enabled
-* @last_beacon_signal: last beacon rssi signal in dbm
 * @ave_beacon_signal: average beacon signal
 * @last_cqm_event: rssi of the last cqm event
 * @bt_coex_min_thold: minimum threshold for BT coex
-- 
1.9.1

