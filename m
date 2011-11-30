Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:2515 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab1K3FL7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 00:11:59 -0500
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
Subject: [PATCH v2 02/17] ath9k_hw: add GPIO output MUX related macros
Date: Wed, 30 Nov 2011 10:41:14 +0530
Message-ID: <1322629889-19961-3-git-send-email-mohammed@qca.qualcomm.com> (sfid-20111130_061203_411604_4768541F)
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
 drivers/net/wireless/ath/ath9k/hw.h |   10 ++++++++++
 1 files changed, 10 insertions(+), 0 deletions(-)

diff --git a/drivers/net/wireless/ath/ath9k/hw.h b/drivers/net/wireless/ath/ath9k/hw.h
index 4f786cb..cd43d59 100644
--- a/drivers/net/wireless/ath/ath9k/hw.h
+++ b/drivers/net/wireless/ath/ath9k/hw.h
@@ -126,6 +126,16 @@
 #define AR_GPIO_OUTPUT_MUX_AS_RX_CLEAR_EXTERNAL  4
 #define AR_GPIO_OUTPUT_MUX_AS_MAC_NETWORK_LED    5
 #define AR_GPIO_OUTPUT_MUX_AS_MAC_POWER_LED      6
+#define AR_GPIO_OUTPUT_MUX_AS_MCI_WLAN_DATA      0x16
+#define AR_GPIO_OUTPUT_MUX_AS_MCI_WLAN_CLK       0x17
+#define AR_GPIO_OUTPUT_MUX_AS_MCI_BT_DATA        0x18
+#define AR_GPIO_OUTPUT_MUX_AS_MCI_BT_CLK         0x19
+#define AR_GPIO_OUTPUT_MUX_AS_WL_IN_TX           0x14
+#define AR_GPIO_OUTPUT_MUX_AS_WL_IN_RX           0x13
+#define AR_GPIO_OUTPUT_MUX_AS_BT_IN_TX           9
+#define AR_GPIO_OUTPUT_MUX_AS_BT_IN_RX           8
+#define AR_GPIO_OUTPUT_MUX_AS_RUCKUS_STROBE      0x1d
+#define AR_GPIO_OUTPUT_MUX_AS_RUCKUS_DATA        0x1e
 
 #define AR_GPIOD_MASK               0x00001FFF
 #define AR_GPIO_BIT(_gpio)          (1 << (_gpio))
-- 
1.7.0.4

