Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plaes.org ([188.166.43.21]:36831 "EHLO plaes.org"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755577AbbBPNIA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 Feb 2015 08:08:00 -0500
From: Priit Laes <plaes@plaes.org>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Priit Laes <plaes@plaes.org>
Subject: [PATCH v3 4/7] rtlwifi: Remove unused defines from cam.h
Date: Mon, 16 Feb 2015 15:01:54 +0200
Message-Id: <1424091717-13212-2-git-send-email-plaes@plaes.org> (sfid-20150216_142158_106312_B3C8C5B5)
In-Reply-To: <1424091717-13212-1-git-send-email-plaes@plaes.org>
References: <1424091600-13121-1-git-send-email-plaes@plaes.org>
 <1424091717-13212-1-git-send-email-plaes@plaes.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Priit Laes <plaes@plaes.org>
---
 drivers/net/wireless/rtlwifi/cam.h | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/rtlwifi/cam.h b/drivers/net/wireless/rtlwifi/cam.h
index 3550808..e2e647d 100644
--- a/drivers/net/wireless/rtlwifi/cam.h
+++ b/drivers/net/wireless/rtlwifi/cam.h
@@ -28,13 +28,11 @@
 
 #define CAM_CONTENT_COUNT				8
 
-#define CFG_DEFAULT_KEY					BIT(5)
 #define CFG_VALID					BIT(15)
 
 #define PAIRWISE_KEYIDX					0
 #define CAM_PAIRWISE_KEY_POSITION			4
 
-#define	CAM_CONFIG_USEDK				1
 #define	CAM_CONFIG_NO_USEDK				0
 
 void rtl_cam_reset_all_entry(struct ieee80211_hw *hw);
-- 
2.3.0

