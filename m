Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f68.google.com ([209.85.192.68]:36606 "EHLO
	mail-qg0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752631AbcB2BIY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 28 Feb 2016 20:08:24 -0500
Received: by mail-qg0-f68.google.com with SMTP id 14so9669113qgg.3
        for <linux-wireless@vger.kernel.org>; Sun, 28 Feb 2016 17:08:24 -0800 (PST)
Received: from hash ([2001:470:1d:6db:230:48ff:fe9d:9c89])
        by smtp.gmail.com with ESMTPSA id s77sm1905940qkl.29.2016.02.28.17.08.22
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 28 Feb 2016 17:08:22 -0800 (PST)
From: Bob Copeland <me@bobcopeland.com>
To: linux-wireless@vger.kernel.org
Cc: Bob Copeland <me@bobcopeland.com>
Subject: [PATCH 3/3] ath9k_htc: fix up indents with spaces
Date: Sun, 28 Feb 2016 20:07:57 -0500
Message-Id: <1456708077-19652-3-git-send-email-me@bobcopeland.com> (sfid-20160229_020828_872684_E6DFA5F3)
In-Reply-To: <1456708077-19652-1-git-send-email-me@bobcopeland.com>
References: <1456708077-19652-1-git-send-email-me@bobcopeland.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Use tabs here.  Found by smatch.

Signed-off-by: Bob Copeland <me@bobcopeland.com>
---
 drivers/net/wireless/ath/ath9k/htc_drv_init.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_init.c b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
index 8647ab77c019..c2249ad54085 100644
--- a/drivers/net/wireless/ath/ath9k/htc_drv_init.c
+++ b/drivers/net/wireless/ath/ath9k/htc_drv_init.c
@@ -262,11 +262,11 @@ static void ath9k_multi_regread(void *hw_priv, u32 *addr,
 	__be32 tmpval[8];
 	int i, ret;
 
-       for (i = 0; i < count; i++) {
-	       tmpaddr[i] = cpu_to_be32(addr[i]);
-       }
+	for (i = 0; i < count; i++) {
+		tmpaddr[i] = cpu_to_be32(addr[i]);
+	}
 
-       ret = ath9k_wmi_cmd(priv->wmi, WMI_REG_READ_CMDID,
+	ret = ath9k_wmi_cmd(priv->wmi, WMI_REG_READ_CMDID,
 			   (u8 *)tmpaddr , sizeof(u32) * count,
 			   (u8 *)tmpval, sizeof(u32) * count,
 			   100);
@@ -275,9 +275,9 @@ static void ath9k_multi_regread(void *hw_priv, u32 *addr,
 			"Multiple REGISTER READ FAILED (count: %d)\n", count);
 	}
 
-       for (i = 0; i < count; i++) {
-	       val[i] = be32_to_cpu(tmpval[i]);
-       }
+	for (i = 0; i < count; i++) {
+		val[i] = be32_to_cpu(tmpval[i]);
+	}
 }
 
 static void ath9k_regwrite_multi(struct ath_common *common)
-- 
2.6.1

