Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lf0-f66.google.com ([209.85.215.66]:35627 "EHLO
        mail-lf0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933511AbcKNQfi (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 14 Nov 2016 11:35:38 -0500
Received: by mail-lf0-f66.google.com with SMTP id p100so7512941lfg.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Nov 2016 08:35:37 -0800 (PST)
From: Erik Stromdahl <erik.stromdahl@gmail.com>
To: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
        ath10k@lists.infradead.org
Cc: Erik Stromdahl <erik.stromdahl@gmail.com>
Subject: [RFC 08/12] ath10k: Added ATH10K_BUS_SDIO enum
Date: Mon, 14 Nov 2016 17:33:38 +0100
Message-Id: <1479141222-8493-9-git-send-email-erik.stromdahl@gmail.com> (sfid-20161114_173558_335454_995B3EFC)
In-Reply-To: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com>
References: <1479141222-8493-1-git-send-email-erik.stromdahl@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Erik Stromdahl <erik.stromdahl@gmail.com>
---
 drivers/net/wireless/ath/ath10k/core.h |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/ath/ath10k/core.h b/drivers/net/wireless/ath/ath10k/core.h
index b7067cc..8c7b080 100644
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
