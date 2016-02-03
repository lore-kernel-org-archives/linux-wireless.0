Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42060 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965644AbcBCSkD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Feb 2016 13:40:03 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 06/28] rtl8xxxu: Add REG_TX_REPORT_* defines
Date: Wed,  3 Feb 2016 13:39:40 -0500
Message-Id: <1454524802-26763-7-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160203_201502_110940_42394642)
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
index 7c795ce..89547b6 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -456,6 +456,8 @@
 #define REG_NEED_CPU_HANDLE		0x04e0
 #define REG_PKT_LOSE_RPT		0x04e1
 #define REG_PTCL_ERR_STATUS		0x04e2
+#define REG_TX_REPORT_CTRL		0x04ec
+#define REG_TX_REPORT_TIME		0x04f0
 #define REG_DUMMY			0x04fc
 
 /* 0x0500 ~ 0x05FF	EDCA Configuration */
-- 
2.5.0

