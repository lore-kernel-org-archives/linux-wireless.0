Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rtits2.realtek.com ([211.75.126.72]:38503 "EHLO
        rtits2.realtek.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752162AbeCFB0Q (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 5 Mar 2018 20:26:16 -0500
From: <pkshih@realtek.com>
To: <kvalo@codeaurora.org>
CC: <Larry.Finger@lwfinger.net>, <linux-wireless@vger.kernel.org>
Subject: [PATCH v2 14/15] rtlwifi: btcoex: Add 8822b to Makefile
Date: Tue, 6 Mar 2018 09:25:53 +0800
Message-ID: <20180306012554.3108-15-pkshih@realtek.com> (sfid-20180306_022619_518172_FB9E404D)
In-Reply-To: <20180306012554.3108-1-pkshih@realtek.com>
References: <20180306012554.3108-1-pkshih@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ping-Ke Shih <pkshih@realtek.com>

Add btcoex of 8822b to Makefile.

Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
---
 drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile b/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile
index d15c58737388..37108c379bd0 100644
--- a/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile
+++ b/drivers/net/wireless/realtek/rtlwifi/btcoexist/Makefile
@@ -4,6 +4,9 @@ btcoexist-objs :=	halbtc8192e2ant.o	\
 			halbtc8723b2ant.o	\
 			halbtc8821a1ant.o	\
 			halbtc8821a2ant.o	\
+			halbtc8822b1ant.o	\
+			halbtc8822b2ant.o	\
+			halbtc8822bwifionly.o	\
 			halbtcoutsrc.o		\
 			rtl_btc.o
 
-- 
2.15.1
