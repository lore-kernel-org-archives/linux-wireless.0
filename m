Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:43369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753057AbcB2WF4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:05:56 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 068/113] rtl8xxxu: Add REG_DWBCN1_CTRL_8723B define
Date: Mon, 29 Feb 2016 17:05:06 -0500
Message-Id: <1456783551-28315-69-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_230911_993828_F730C8D3)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

List yet another new register found on the 8723b.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index 8209830..ec6f40f 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -397,6 +397,8 @@
 #define REG_AUTO_LLT			0x0224
 #define  AUTO_LLT_INIT_LLT		BIT(16)
 
+#define REG_DWBCN1_CTRL_8723B		0x0228
+
 /* 0x0280 ~ 0x02FF	RXDMA Configuration */
 #define REG_RXDMA_AGG_PG_TH		0x0280
 #define  RXDMA_USB_AGG_ENABLE		BIT(31)
-- 
2.5.0

