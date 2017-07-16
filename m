Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:48998 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751245AbdGPLqm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 16 Jul 2017 07:46:42 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 09/21] brcmfmac: tidy header a bit
Date: Sun, 16 Jul 2017 12:21:17 +0100
Message-Id: <20170716112129.10206-10-ian@mnementh.co.uk> (sfid-20170716_140043_229255_AAA1D4C0)
In-Reply-To: <20170716112129.10206-1-ian@mnementh.co.uk>
References: <20170716112129.10206-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

---
 .../net/wireless/broadcom/brcm80211/brcmfmac/sdio.h  | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
index 5220a878bed3..d582e39652b9 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.h
@@ -62,17 +62,19 @@
 
 #define brcm_sdio_func1_wb(sdiodev, addr, v, ret) \
 	sdio_writeb((sdiodev)->func[1], (v), (addr), (ret))
-#define SDIO_CCCR_BRCM_CARDCAP			0xf0
-#define SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT	0x02
-#define SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT	0x04
-#define SDIO_CCCR_BRCM_CARDCAP_CMD_NODEC	0x08
+
+#define SDIO_CCCR_BRCM_CARDCAP		0xf0
+#define  SDIO_CCCR_BRCM_CARDCAP_CMD14_SUPPORT	0x02
+#define  SDIO_CCCR_BRCM_CARDCAP_CMD14_EXT	0x04
+#define  SDIO_CCCR_BRCM_CARDCAP_CMD_NODEC	0x08
+
 #define SDIO_CCCR_BRCM_CARDCTRL		0xf1
-#define SDIO_CCCR_BRCM_CARDCTRL_WLANRESET	0x02
-#define SDIO_CCCR_BRCM_SEPINT			0xf2
+#define  SDIO_CCCR_BRCM_CARDCTRL_WLANRESET	0x02
 
-#define  SDIO_SEPINT_MASK		0x01
-#define  SDIO_SEPINT_OE			0x02
-#define  SDIO_SEPINT_ACT_HI		0x04
+#define SDIO_CCCR_BRCM_SEPINT		0xf2
+#define  SDIO_SEPINT_MASK			0x01
+#define  SDIO_SEPINT_OE				0x02
+#define  SDIO_SEPINT_ACT_HI			0x04
 
 /* function 1 miscellaneous registers */
 
-- 
2.11.0
