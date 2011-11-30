Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:17930 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab1K3FOU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 00:14:20 -0500
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	<linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qualcomm.com>,
	Russell Hu <rhu@qca.qualcomm.com>,
	Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>,
	Wilson Tsao <wtsao@qca.qualcomm.com>
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
To: "John W. Linville" <linville@tuxdriver.com>,
	Felix Fietkau <nbd@openwrt.org>
Subject: [PATCH v2 17/17] ath9k: fix a typo
Date: Wed, 30 Nov 2011 10:41:29 +0530
Message-ID: <1322629889-19961-18-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111130_061424_027924_3EDF5E9A)
In-Reply-To: <1322629889-19961-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1322629889-19961-1-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>

Cc: Wilson Tsao <wtsao@qca.qualcomm.com>
Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
Signed-off-by: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
---
 drivers/net/wireless/ath/ath9k/btcoex.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/btcoex.c b/drivers/net/wireless/ath/ath9k/btcoex.c
index 9ac28d9..bbb2081 100644
--- a/drivers/net/wireless/ath/ath9k/btcoex.c
+++ b/drivers/net/wireless/ath/ath9k/btcoex.c
@@ -21,7 +21,7 @@ enum ath_bt_mode {
 	ATH_BT_COEX_MODE_LEGACY,        /* legacy rx_clear mode */
 	ATH_BT_COEX_MODE_UNSLOTTED,     /* untimed/unslotted mode */
 	ATH_BT_COEX_MODE_SLOTTED,       /* slotted mode */
-	ATH_BT_COEX_MODE_DISALBED,      /* coexistence disabled */
+	ATH_BT_COEX_MODE_DISABLED,      /* coexistence disabled */
 };
 
 struct ath_btcoex_config {
-- 
1.7.0.4

