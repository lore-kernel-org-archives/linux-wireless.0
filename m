Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43509 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965907AbcBCSkD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:03 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 11/28] rtl8xxxu: Add definitions for antenna selection registers for 8723BU
Date: Wed,  3 Feb 2016 13:39:45 -0500
Message-Id: <1454524802-26763-12-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_201501_985938_6CC5844E)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index f752602..997a857 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -756,6 +756,10 @@
 #define REG_FPGA1_RF_MODE		0x0900
 
 #define REG_FPGA1_TX_INFO		0x090c
+#define REG_DPDT_CTRL			0x092c	/* 8723BU */
+#define REG_RFE_CTRL_ANTA_SRC		0x0930	/* 8723BU */
+#define REG_RFE_PATH_SELECT		0x0940	/* 8723BU */
+#define REG_RFE_BUFFER			0x0944	/* 8723BU */
 
 #define REG_CCK0_SYSTEM			0x0a00
 #define  CCK0_SIDEBAND			BIT(4)
-- 
2.5.0

