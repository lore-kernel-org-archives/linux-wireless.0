Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965909AbcBCSkD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:03 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 13/28] rtl8xxxu: Add REG_OFDM0_RX_D_SYNC_PATH definitions
Date: Wed,  3 Feb 2016 13:39:47 -0500
Message-Id: <1454524802-26763-14-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_194813_731682_1FDF81CE)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index 991b366..d2995f8a3 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -793,6 +793,9 @@
 
 #define REG_OFDM0_ENERGY_CCA_THRES	0x0c4c
 
+#define REG_OFDM0_RX_D_SYNC_PATH	0x0c40
+#define  OFDM0_SYNC_PATH_NOTCH_FILTER	BIT(1)
+
 #define REG_OFDM0_XA_AGC_CORE1		0x0c50
 #define REG_OFDM0_XA_AGC_CORE2		0x0c54
 #define REG_OFDM0_XB_AGC_CORE1		0x0c58
-- 
2.5.0

