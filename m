Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ea0-f174.google.com ([209.85.215.174]:49373 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab3LQUp3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Dec 2013 15:45:29 -0500
Received: by mail-ea0-f174.google.com with SMTP id b10so3132186eae.33
        for <linux-wireless@vger.kernel.org>; Tue, 17 Dec 2013 12:45:28 -0800 (PST)
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
Subject: [PATCH 31/36] iwlwifi: mvm: fixup Makefile
Date: Tue, 17 Dec 2013 22:44:34 +0200
Message-Id: <1387313079-28123-31-git-send-email-egrumbach@gmail.com> (sfid-20131217_214549_777147_8FA13D1F)
In-Reply-To: <52B0B72A.5070704@gmail.com>
References: <52B0B72A.5070704@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Emmanuel Grumbach <emmanuel.grumbach@intel.com>

debufs.o appeared twice in the Makefile. Fix that.

Signed-off-by: Emmanuel Grumbach <emmanuel.grumbach@intel.com>
---
 drivers/net/wireless/iwlwifi/mvm/Makefile |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/wireless/iwlwifi/mvm/Makefile b/drivers/net/wireless/iwlwifi/mvm/Makefile
index 3ea47ab..f98ec2b 100644
--- a/drivers/net/wireless/iwlwifi/mvm/Makefile
+++ b/drivers/net/wireless/iwlwifi/mvm/Makefile
@@ -4,7 +4,6 @@ iwlmvm-y += utils.o rx.o tx.o binding.o quota.o sta.o sf.o
 iwlmvm-y += scan.o time-event.o rs.o
 iwlmvm-y += power.o power_legacy.o bt-coex.o
 iwlmvm-y += led.o tt.o
-iwlmvm-$(CONFIG_IWLWIFI_DEBUGFS) += debugfs.o
 iwlmvm-$(CONFIG_IWLWIFI_DEBUGFS) += debugfs.o debugfs-vif.o
 iwlmvm-$(CONFIG_PM_SLEEP) += d3.o
 
-- 
1.7.9.5

