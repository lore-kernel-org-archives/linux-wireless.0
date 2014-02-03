Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f182.google.com ([209.85.215.182]:46062 "EHLO
	mail-ea0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557AbaBCU7q (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Feb 2014 15:59:46 -0500
Received: by mail-ea0-f182.google.com with SMTP id r15so3966033ead.41
        for <linux-wireless@vger.kernel.org>; Mon, 03 Feb 2014 12:59:45 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 52/62] iwlwifi: fix kerneldoc format
Date: Mon,  3 Feb 2014 22:57:58 +0200
Message-Id: <1391461088-8082-52-git-send-email-egrumbach@gmail.com> (sfid-20140203_223008_019237_31EBB0D5)
In-Reply-To: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
References: <CANUX_P2BFLVRL-DFsTWA56zLJsRcn_dZhVdCChaQs2ZLWiBv3g@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/iwl-op-mode.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/iwl-op-mode.h b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
index f83b244..5d78207 100644
--- a/drivers/net/wireless/iwlwifi/iwl-op-mode.h
+++ b/drivers/net/wireless/iwlwifi/iwl-op-mode.h
@@ -159,7 +159,7 @@ void iwl_opmode_deregister(const char *name);
 
 /**
  * struct iwl_op_mode - operational mode
- * @ops - pointer to its own ops
+ * @ops: pointer to its own ops
  *
  * This holds an implementation of the mac80211 / fw API.
  */
-- 
1.7.9.5

