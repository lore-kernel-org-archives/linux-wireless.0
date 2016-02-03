Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44235 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965901AbcBCSkD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:03 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 04/28] rtl8xxxu: Add RQPN_[NE]PQ_SHIFT values
Date: Wed,  3 Feb 2016 13:39:38 -0500
Message-Id: <1454524802-26763-5-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_201501_507974_DF03EDA1)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index 23208f7..8b27a1c 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -352,6 +352,8 @@
 #define REG_TXDMA_OFFSET_CHK		0x020c
 #define REG_TXDMA_STATUS		0x0210
 #define REG_RQPN_NPQ			0x0214
+#define  RQPN_NPQ_SHIFT			0
+#define  RQPN_EPQ_SHIFT			16
 
 /* 0x0280 ~ 0x02FF	RXDMA Configuration */
 #define REG_RXDMA_AGG_PG_TH		0x0280
-- 
2.5.0

