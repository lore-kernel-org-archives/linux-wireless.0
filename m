Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from gn237.zone.eu ([217.146.67.237]:36826 "EHLO gn237.zone.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751790AbbA0G6L (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 27 Jan 2015 01:58:11 -0500
From: Priit Laes <plaes@plaes.org>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Priit Laes <plaes@plaes.org>
Subject: [PATCH 6/7] rtlwifi: Remove unused defines from base.h
Date: Tue, 27 Jan 2015 08:49:32 +0200
Message-Id: <1422341373-22196-6-git-send-email-plaes@plaes.org> (sfid-20150127_075842_285862_D48E1046)
In-Reply-To: <1422341373-22196-1-git-send-email-plaes@plaes.org>
References: <1422341373-22196-1-git-send-email-plaes@plaes.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/net/wireless/rtlwifi/base.h | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/base.h b/drivers/net/wireless/rtlwifi/base.h
index 982f245..ea3e3fc 100644
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
2.2.2

