Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from szxga07-in.huawei.com ([45.249.212.35]:41147 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1729096AbeIMTQw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 13 Sep 2018 15:16:52 -0400
From: YueHaibing <yuehaibing@huawei.com>
To: <ath10k@lists.infradead.org>, <kvalo@codeaurora.org>
CC: <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>,
        <davem@davemloft.net>, <linux-wireless@vger.kernel.org>,
        YueHaibing <yuehaibing@huawei.com>
Subject: [PATCH] ath10k: Remove duplicated includes
Date: Thu, 13 Sep 2018 22:01:21 +0800
Message-ID: <20180913140121.23152-1-yuehaibing@huawei.com> (sfid-20180913_160949_229227_D4B6DB45)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

remove duplicated include from ath10k driver.

Signed-off-by: YueHaibing <yuehaibing@huawei.com>
---
 drivers/net/wireless/ath/ath10k/htt.h     | 1 -
 drivers/net/wireless/ath/ath10k/mac.c     | 1 -
 drivers/net/wireless/ath/ath10k/wmi-tlv.c | 1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/net/wireless/ath/ath10k/htt.h b/drivers/net/wireless/ath/ath10k/htt.h
index 5d3ff80..eaf3a00 100644
--- a/drivers/net/wireless/ath/ath10k/htt.h
+++ b/drivers/net/wireless/ath/ath10k/htt.h
@@ -29,7 +29,6 @@
 #include "htc.h"
 #include "hw.h"
 #include "rx_desc.h"
-#include "hw.h"
 
 enum htt_dbg_stats_type {
 	HTT_DBG_STATS_WAL_PDEV_TXRX = 1 << 0,
diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 496772d..e37ea39 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -30,7 +30,6 @@
 #include "htt.h"
 #include "txrx.h"
 #include "testmode.h"
-#include "wmi.h"
 #include "wmi-tlv.h"
 #include "wmi-ops.h"
 #include "wow.h"
diff --git a/drivers/net/wireless/ath/ath10k/wmi-tlv.c b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
index cdc1e64..6c6656d6 100644
--- a/drivers/net/wireless/ath/ath10k/wmi-tlv.c
+++ b/drivers/net/wireless/ath/ath10k/wmi-tlv.c
@@ -19,7 +19,6 @@
 #include "debug.h"
 #include "mac.h"
 #include "hw.h"
-#include "mac.h"
 #include "wmi.h"
 #include "wmi-ops.h"
 #include "wmi-tlv.h"
-- 
2.7.0
