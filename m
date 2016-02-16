Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:34139 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750953AbcBPLhg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2016 06:37:36 -0500
Received: by mail-qk0-f182.google.com with SMTP id x1so65029627qkc.1
        for <linux-wireless@vger.kernel.org>; Tue, 16 Feb 2016 03:37:36 -0800 (PST)
Date: Tue, 16 Feb 2016 11:36:52 -0500
From: Janani Ravichandran <janani.rvchndrn@gmail.com>
To: outreachy-kernel@googlegroups.com
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH] staging: wilc1000: Remove trailing whitespace errors
Message-ID: <20160216163652.GA10221@janani-Inspiron-3521> (sfid-20160216_123740_065140_AAF395C1)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Remove trailing whitespace checkpatch errors.

Signed-off-by: Janani Ravichandran <janani.rvchndrn@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 drivers/staging/wilc1000/linux_mon.c      | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index d1eedfb..04337c7 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -3352,7 +3352,7 @@ static s32 host_int_get_assoc_res_info(struct wilc_vif *vif,
 		PRINT_ER("Failed to send association response config packet\n");
 		return -EINVAL;
 	}
-	
+
 	*pu32RcvdAssocRespInfoLen = wid.size;
 	return result;
 }
diff --git a/drivers/staging/wilc1000/linux_mon.c b/drivers/staging/wilc1000/linux_mon.c
index 21f35d7..9fcb497 100644
--- a/drivers/staging/wilc1000/linux_mon.c
+++ b/drivers/staging/wilc1000/linux_mon.c
@@ -302,7 +302,7 @@ struct net_device *WILC_WFI_init_mon_interface(const char *name, struct net_devi
 	struct WILC_WFI_mon_priv *priv;
 
 	/*If monitor interface is already initialized, return it*/
-	if (wilc_wfi_mon) 
+	if (wilc_wfi_mon)
 		return wilc_wfi_mon;
 
 	wilc_wfi_mon = alloc_etherdev(sizeof(struct WILC_WFI_mon_priv));
-- 
2.5.0

