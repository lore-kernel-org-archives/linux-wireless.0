Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:47322 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751291AbdGQQnJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 17 Jul 2017 12:43:09 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 13/29] brcmfmac: Tidy register definitions a little
Date: Mon, 17 Jul 2017 17:16:21 +0100
Message-Id: <20170717161637.4652-14-ian@mnementh.co.uk> (sfid-20170717_184312_352384_11E72592)
In-Reply-To: <20170717161637.4652-1-ian@mnementh.co.uk>
References: <20170717161637.4652-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Trivial tidy of register definitions.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index 2f32c9270eaa..e2324a78249b 100644
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
