Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:50098 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751057AbdGZUrz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 16:47:55 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 13/34] brcmfmac: Tidy register definitions a little
Date: Wed, 26 Jul 2017 21:25:36 +0100
Message-Id: <20170726202557.15632-14-ian@mnementh.co.uk> (sfid-20170726_230050_616390_1FA5F3DA)
In-Reply-To: <20170726202557.15632-1-ian@mnementh.co.uk>
References: <20170726202557.15632-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Trivial tidy of register definitions.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index 4c81ea24d19c..fb4f24dfc99d 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -51,17 +51,18 @@
 
 /* function 0 vendor specific CCCR registers */
 
-#define SDIO_CCCR_BRCM_CARDCAP			0xf0
+#define SDIO_CCCR_BRCM_CARDCAP		0xf0
 #define SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT	0x02
 #define SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT	0x04
 #define SDIO_CCCR_BRCM_CARDCAP_CMD_NODEC	0x08
+
 #define SDIO_CCCR_BRCM_CARDCTRL		0xf1
 #define SDIO_CCCR_BRCM_CARDCTRL_WLANRESET	0x02
-#define SDIO_CCCR_BRCM_SEPINT			0xf2
 
-#define  SDIO_SEPINT_MASK		0x01
-#define  SDIO_SEPINT_OE			0x02
-#define  SDIO_SEPINT_ACT_HI		0x04
+#define SDIO_CCCR_BRCM_SEPINT		0xf2
+#define SDIO_SEPINT_MASK			0x01
+#define SDIO_SEPINT_OE				0x02
+#define SDIO_SEPINT_ACT_HI			0x04
 
 /* function 1 miscellaneous registers */
 
-- 
2.11.0
