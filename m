Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:42653 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754202AbeFKVKD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 11 Jun 2018 17:10:03 -0400
Received: by mail-pg0-f67.google.com with SMTP id c10-v6so4725755pgu.9
        for <linux-wireless@vger.kernel.org>; Mon, 11 Jun 2018 14:10:03 -0700 (PDT)
From: Brian Norris <briannorris@chromium.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        Govind Singh <govinds@codeaurora.org>,
        <linux-kernel@vger.kernel.org>,
        Brian Norris <briannorris@chromium.org>
Subject: [PATCH 3/4] ath10k: snoc: drop unused WCN3990_CE_ATTR_FLAGS
Date: Mon, 11 Jun 2018 14:09:45 -0700
Message-Id: <20180611210946.241341-3-briannorris@chromium.org> (sfid-20180611_231057_389647_48FB23D8)
In-Reply-To: <20180611210946.241341-1-briannorris@chromium.org>
References: <20180611210946.241341-1-briannorris@chromium.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

We started using a common CE_ATTR_FLAGS definition, so drop this one.

Signed-off-by: Brian Norris <briannorris@chromium.org>
---
 drivers/net/wireless/ath/ath10k/snoc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/ath/ath10k/snoc.c b/drivers/net/wireless/ath/ath10k/snoc.c
index c7cfc9c9b3d7..61967c2966e6 100644
--- a/drivers/net/wireless/ath/ath10k/snoc.c
+++ b/drivers/net/wireless/ath/ath10k/snoc.c
@@ -26,7 +26,7 @@
 #include <linux/platform_device.h>
 #include <linux/regulator/consumer.h>
 #include <linux/clk.h>
-#define  WCN3990_CE_ATTR_FLAGS 0
+
 #define ATH10K_SNOC_RX_POST_RETRY_MS 50
 #define CE_POLL_PIPE 4
 
-- 
2.18.0.rc1.242.g61856ae69a-goog
