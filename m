Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:41911 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965911AbcBCSkD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:03 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 05/28] rtl8xxxu: Define SYS_CFG_SW_OFFLOAD_EN
Date: Wed,  3 Feb 2016 13:39:39 -0500
Message-Id: <1454524802-26763-6-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_194813_125847_BB4843FB)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

This is needed for chips with IOL support.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index 8b27a1c..7c795ce 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -213,6 +213,7 @@
 #define  SYS_CFG_PCIRSTB		BIT(4)
 #define  SYS_CFG_V15_VLD		BIT(5)
 #define  SYS_CFG_TRP_B15V_EN		BIT(7)
+#define  SYS_CFG_SW_OFFLOAD_EN		BIT(7)	/* For chips with IOL support */
 #define  SYS_CFG_SIC_IDLE		BIT(8)
 #define  SYS_CFG_BD_MAC2		BIT(9)
 #define  SYS_CFG_BD_MAC1		BIT(10)
-- 
2.5.0

