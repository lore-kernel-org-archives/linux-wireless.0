Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40047 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965908AbcBCSkD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:03 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 12/28] rtl8xxxu: Add mbox extension register definitions for 8723B
Date: Wed,  3 Feb 2016 13:39:46 -0500
Message-Id: <1454524802-26763-13-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_201502_362468_5458B9C4)
In-Reply-To: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1454524802-26763-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index 997a857..991b366 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -341,6 +341,11 @@
 #define REG_BB_ACCEESS_CTRL		0x01e8
 #define REG_BB_ACCESS_DATA		0x01ec
 
+#define REG_HMBOX_EXT0_8723B		0x01f0
+#define REG_HMBOX_EXT1_8723B		0x01f4
+#define REG_HMBOX_EXT2_8723B		0x01f8
+#define REG_HMBOX_EXT3_8723B		0x01fc
+
 /* 0x0200 ~ 0x027F	TXDMA Configuration */
 #define REG_RQPN			0x0200
 #define  RQPN_HI_PQ_SHIFT		0
-- 
2.5.0

