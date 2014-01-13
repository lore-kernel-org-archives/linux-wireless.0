Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:55927 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063AbaAMUWT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jan 2014 15:22:19 -0500
Received: by mail-ea0-f173.google.com with SMTP id o10so3573111eaj.4
        for <linux-wireless@vger.kernel.org>; Mon, 13 Jan 2014 12:22:17 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 12/18] iwlwifi: mvm: remove unused flags from add station command
Date: Mon, 13 Jan 2014 22:21:51 +0200
Message-Id: <1389644517-22807-12-git-send-email-egrumbach@gmail.com> (sfid-20140113_212225_827727_65E66991)
In-Reply-To: <52D44A46.4000805@gmail.com>
References: <52D44A46.4000805@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h |    3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h b/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
index 6bbbad4..1b60fdf 100644
--- a/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
+++ b/drivers/net/wireless/iwlwifi/mvm/fw-api-sta.h
@@ -97,9 +97,6 @@ enum iwl_sta_flags {
 					   STA_FLG_FLG_ANT_B),
 
 	STA_FLG_PS			= BIT(8),
-	STA_FLG_INVALID			= BIT(9),
-	STA_FLG_DLP_EN			= BIT(10),
-	STA_FLG_SET_ALL_KEYS		= BIT(11),
 	STA_FLG_DRAIN_FLOW		= BIT(12),
 	STA_FLG_PAN			= BIT(13),
 	STA_FLG_CLASS_AUTH		= BIT(14),
-- 
1.7.9.5

