Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4307 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753156Ab3K2LZk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 29 Nov 2013 06:25:40 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: linux-wireless <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/19] brcmfmac: add firmware and nvram file name for
 bcm4339
Date: Fri, 29 Nov 2013 12:25:09 +0100
Message-ID: <1385724324-6361-5-git-send-email-arend@broadcom.com> (sfid-20131129_123807_592579_A5FCBAE0)
In-Reply-To: <1385724324-6361-1-git-send-email-arend@broadcom.com>
References: <1385724324-6361-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Add firmware/nvram file name for bcm4339 so fmac can actually be functional with
the chip.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
index 510ab18..f017c92 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/dhd_sdio.c
@@ -499,6 +499,8 @@ enum brcmf_sdio_frmtype {
 #define BCM4334_NVRAM_NAME		"brcm/brcmfmac4334-sdio.txt"
 #define BCM4335_FIRMWARE_NAME		"brcm/brcmfmac4335-sdio.bin"
 #define BCM4335_NVRAM_NAME		"brcm/brcmfmac4335-sdio.txt"
+#define BCM4339_FIRMWARE_NAME		"brcm/brcmfmac4339-sdio.bin"
+#define BCM4339_NVRAM_NAME		"brcm/brcmfmac4339-sdio.txt"
 
 MODULE_FIRMWARE(BCM43143_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM43143_NVRAM_NAME);
@@ -514,6 +516,8 @@ MODULE_FIRMWARE(BCM4334_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM4334_NVRAM_NAME);
 MODULE_FIRMWARE(BCM4335_FIRMWARE_NAME);
 MODULE_FIRMWARE(BCM4335_NVRAM_NAME);
+MODULE_FIRMWARE(BCM4339_FIRMWARE_NAME);
+MODULE_FIRMWARE(BCM4339_NVRAM_NAME);
 
 struct brcmf_firmware_names {
 	u32 chipid;
@@ -537,7 +541,8 @@ static const struct brcmf_firmware_names brcmf_fwname_data[] = {
 	{ BCM4329_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4329) },
 	{ BCM4330_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4330) },
 	{ BCM4334_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4334) },
-	{ BCM4335_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4335) }
+	{ BCM4335_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4335) },
+	{ BCM4339_CHIP_ID, 0xFFFFFFFF, BRCMF_FIRMWARE_NVRAM(BCM4339) }
 };
 
 
-- 
1.7.10.4


