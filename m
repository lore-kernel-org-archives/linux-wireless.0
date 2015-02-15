Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gn237.zone.eu ([217.146.67.237]:17918 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932402AbbBOUsd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 15 Feb 2015 15:48:33 -0500
From: Priit Laes <plaes@plaes.org>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Priit Laes <plaes@plaes.org>
Subject: [PATCH v2 5/7] rtlwifi: Remove unused defines from base.h
Date: Sun, 15 Feb 2015 22:46:49 +0200
Message-Id: <1424033211-11696-6-git-send-email-plaes@plaes.org> (sfid-20150215_214939_532921_4CAAE77D)
In-Reply-To: <1424033211-11696-1-git-send-email-plaes@plaes.org>
References: <1424033211-11696-1-git-send-email-plaes@plaes.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 drivers/net/wireless/rtlwifi/base.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.h b/drivers/net/wireless/rtlwifi/base.h
index c6cb49c..dee4ac2 100644
--- a/drivers/net/wireless/rtlwifi/base.h
+++ b/drivers/net/wireless/rtlwifi/base.h
@@ -45,9 +45,6 @@ enum ap_peer {
 #define RTL_TX_DESC_SIZE	32
 #define RTL_TX_HEADER_SIZE	(RTL_TX_DESC_SIZE + RTL_TX_DUMMY_SIZE)
 
-#define HT_AMSDU_SIZE_4K	3839
-#define HT_AMSDU_SIZE_8K	7935
-
 #define MAX_BIT_RATE_40MHZ_MCS15	300	/* Mbps */
 #define MAX_BIT_RATE_40MHZ_MCS7		150	/* Mbps */
 
@@ -61,9 +58,6 @@ enum ap_peer {
 #define MAX_BIT_RATE_LONG_GI_1NSS_80MHZ_MCS9	390	/* Mbps */
 #define MAX_BIT_RATE_LONG_GI_1NSS_80MHZ_MCS7	293	/* Mbps */
 
-#define RTL_RATE_COUNT_LEGACY		12
-#define RTL_CHANNEL_COUNT		14
-
 #define FRAME_OFFSET_FRAME_CONTROL	0
 #define FRAME_OFFSET_DURATION		2
 #define FRAME_OFFSET_ADDRESS1		4
-- 
2.3.0

