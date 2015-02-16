Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plaes.org ([188.166.43.21]:36838 "EHLO plaes.org"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755659AbbBPNIA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2015 08:08:00 -0500
From: Priit Laes <plaes@plaes.org>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Priit Laes <plaes@plaes.org>
Subject: [PATCH v3 1/7] rtlwifi: Remove unused defines from rtl8192cu driver
Date: Mon, 16 Feb 2015 14:59:54 +0200
Message-Id: <1424091600-13121-2-git-send-email-plaes@plaes.org> (sfid-20150216_141955_251218_A5A5A0DB)
In-Reply-To: <1424091600-13121-1-git-send-email-plaes@plaes.org>
References: <1424091600-13121-1-git-send-email-plaes@plaes.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/net/wireless/rtlwifi/rtl8192cu/hw.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
index c1e33b0..6758808 100644
--- a/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
+++ b/drivers/net/wireless/rtlwifi/rtl8192cu/hw.h
@@ -32,8 +32,6 @@
 
 #define H2C_RA_MASK	6
 
-#define LLT_POLLING_LLT_THRESHOLD		20
-#define LLT_POLLING_READY_TIMEOUT_COUNT		100
 #define LLT_LAST_ENTRY_OF_TX_PKT_BUFFER		255
 
 #define RX_PAGE_SIZE_REG_VALUE			PBP_128
-- 
2.3.0

