Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f181.google.com ([209.85.212.181]:45175 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613AbaLBSLd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2014 13:11:33 -0500
Received: by mail-wi0-f181.google.com with SMTP id r20so21818502wiv.14
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2014 10:11:32 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 07/26] iwlwifi: mvm: BT Coex - change the MPLUT registers' value
Date: Tue,  2 Dec 2014 20:10:58 +0200
Message-Id: <1417543877-24193-7-git-send-email-egrumbach@gmail.com> (sfid-20141202_191138_557534_9A5DACEA)
In-Reply-To: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
References: <0BA3FCBA62E2DC44AF3030971E174FB31B5A7D27@hasmsx107.ger.corp.intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

This impacts the partition between BT and Wifi.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/constants.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/constants.h b/drivers/net/wireless/iwlwifi/mvm/constants.h
index 1716031..3bd9347 100644
--- a/drivers/net/wireless/iwlwifi/mvm/constants.h
+++ b/drivers/net/wireless/iwlwifi/mvm/constants.h
@@ -94,8 +94,8 @@
 #define IWL_MVM_BT_COEX_MPLUT			1
 #define IWL_MVM_BT_COEX_RRC			1
 #define IWL_MVM_BT_COEX_TTC			1
-#define IWL_MVM_BT_COEX_MPLUT_REG0		0x2e402280
-#define IWL_MVM_BT_COEX_MPLUT_REG1		0x7711a751
+#define IWL_MVM_BT_COEX_MPLUT_REG0		0x28412201
+#define IWL_MVM_BT_COEX_MPLUT_REG1		0x11118451
 #define IWL_MVM_BT_COEX_ANTENNA_COUPLING_THRS	30
 #define IWL_MVM_FW_MCAST_FILTER_PASS_ALL	0
 #define IWL_MVM_FW_BCAST_FILTER_PASS_ALL	0
-- 
1.9.1

