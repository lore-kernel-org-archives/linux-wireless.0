Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:36840 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754818AbeDCHyI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 3 Apr 2018 03:54:08 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 02/17] rtlwifi: add debug ID COMP_HALMAC
Date: Tue, 3 Apr 2018 15:53:17 +0800
Message-ID: <20180403075332.3344-3-pkshih@realtek.com> (sfid-20180403_095412_074193_6B6911A1)
In-Reply-To: <20180403075332.3344-1-pkshih@realtek.com>
References: <20180403075332.3344-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Add a debug ID for the module halmac

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/debug.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/debug.h b/drivers/net/wireless/realtek/rtlwifi/debug.h
index ad6834af618b..90c41c17d678 100644
--- a/drivers/net/wireless/realtek/rtlwifi/debug.h
+++ b/drivers/net/wireless/realtek/rtlwifi/debug.h
@@ -106,6 +106,7 @@
 #define COMP_BT_COEXIST			BIT(30)
 #define COMP_IQK			BIT(31)
 #define COMP_TX_REPORT			BIT_ULL(32)
+#define COMP_HALMAC			BIT_ULL(33)
 
 /*--------------------------------------------------------------
 		Define the rt_print components
-- 
2.15.1
