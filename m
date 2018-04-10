Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:33530 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752064AbeDJCwq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 9 Apr 2018 22:52:46 -0400
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v3 3/9] rtlwifi: btcoex: Add 8822b header files to precomp.h
Date: Tue, 10 Apr 2018 10:52:20 +0800
Message-ID: <20180410025226.5236-4-pkshih@realtek.com> (sfid-20180410_045252_706547_41BF80E1)
In-Reply-To: <20180410025226.5236-1-pkshih@realtek.com>
References: <20180410025226.5236-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Add 8822b header files to precomp.h for routing functions.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
index 02dff4c3f664..858318fd3d63 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/halbt_precomp.h
@@ -48,6 +48,9 @@
 #include "halbtc8723b2ant.h"
 #include "halbtc8821a2ant.h"
 #include "halbtc8821a1ant.h"
+#include "halbtc8822b1ant.h"
+#include "halbtc8822b2ant.h"
+#include "halbtc8822bwifionly.h"
 
 #define GetDefaultAdapter(padapter)	padapter
 
-- 
2.15.1
