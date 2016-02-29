Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52327 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753512AbcB2WGD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 17:06:03 -0500
From: Jes.Sorensen@redhat.com
To: linux-wireless@vger.kernel.org
Cc: kvalo@codeaurora.org, Larry.Finger@lwfinger.net,
	Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: [PATCH 073/113] rtl8xxxu: RF_T_METER is different on the newer chips
Date: Mon, 29 Feb 2016 17:05:11 -0500
Message-Id: <1456783551-28315-74-git-send-email-Jes.Sorensen@redhat.com> (sfid-20160229_232953_928069_AC5533B1)
In-Reply-To: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
References: <1456783551-28315-1-git-send-email-Jes.Sorensen@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Jes Sorensen <Jes.Sorensen@redhat.com>

Provide RF_T_METER register location for nextgen chips.

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
index d3f6fa3..a055362 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_regs.h
@@ -1104,9 +1104,10 @@
 /*
  * NextGen regs: 8723BU
  */
-#define	RF6052_REG_UNKNOWN_43		0x43
-#define	RF6052_REG_UNKNOWN_55		0x55
-#define	RF6052_REG_S0S1			0xb0
-#define	RF6052_REG_UNKNOWN_DF		0xdf
-#define	RF6052_REG_UNKNOWN_ED		0xed
-#define	RF6052_REG_WE_LUT		0xef
+#define RF6052_REG_T_METER_8723B	0x42
+#define RF6052_REG_UNKNOWN_43		0x43
+#define RF6052_REG_UNKNOWN_55		0x55
+#define RF6052_REG_S0S1			0xb0
+#define RF6052_REG_UNKNOWN_DF		0xdf
+#define RF6052_REG_UNKNOWN_ED		0xed
+#define RF6052_REG_WE_LUT		0xef
-- 
2.5.0

