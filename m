Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f195.google.com ([209.85.220.195]:34750 "EHLO
        mail-qk0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753031AbcKRTYT (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 18 Nov 2016 14:24:19 -0500
Received: by mail-qk0-f195.google.com with SMTP id y205so858488qkb.1
        for <linux-wireless@vger.kernel.org>; Fri, 18 Nov 2016 11:24:19 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC v2 08/11] ath10k: Added ATH10K_BUS_SDIO enum
Date: Fri, 18 Nov 2016 20:22:48 +0100
Message-Id: <1479496971-19174-9-git-send-email-erik.stromdahl@gmail.com> (sfid-20161118_205413_021519_A9B21F13)
In-Reply-To: <1479496971-19174-1-git-send-email-erik.stromdahl@gmail.com>
References: <1479496971-19174-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index e8decfa..be6cd55 100644
--- a/drivers/net/wireless/ath/ath10k/core.h
+++ b/drivers/net/wireless/ath/ath10k/core.h
@@ -74,6 +74,7 @@
 enum ath10k_bus {
 	ATH10K_BUS_PCI,
 	ATH10K_BUS_AHB,
+	ATH10K_BUS_SDIO,
 };
 
 static inline const char *ath10k_bus_str(enum ath10k_bus bus)
@@ -83,6 +84,8 @@ static inline const char *ath10k_bus_str(enum ath10k_bus bus)
 		return "pci";
 	case ATH10K_BUS_AHB:
 		return "ahb";
+	case ATH10K_BUS_SDIO:
+		return "sdio";
 	}
 
 	return "unknown";
-- 
1.7.9.5
