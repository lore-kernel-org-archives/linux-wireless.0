Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw1-out.broadcom.com ([216.31.210.62]:50821 "EHLO
	mail-gw1-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756353AbbCRMZg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Mar 2015 08:25:36 -0400
From: Arend van Spriel <arend@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
Subject: [PATCH 5/8] brcmfmac: add MODULE_FIRMWARE() macros for bcm4356 PCIe device
Date: Wed, 18 Mar 2015 13:25:25 +0100
Message-ID: <1426681528-15831-6-git-send-email-arend@broadcom.com> (sfid-20150318_132620_866045_3F895870)
In-Reply-To: <1426681528-15831-1-git-send-email-arend@broadcom.com>
References: <1426681528-15831-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The BCM4356 PCIe wireless device was added recently but overlooked
the fact that the MODULE_FIRMWARE() macros were missing for the
firmwares needed by this device.

Reviewed-by: Hante Meuleman <meuleman@broadcom.com>
Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmfmac/pcie.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
index ec426f3..d4066e8 100644
--- a/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
+++ b/drivers/net/wireless/brcm80211/brcmfmac/pcie.c
@@ -189,6 +189,8 @@ MODULE_FIRMWARE(BRCMF_PCIE_43602_FW_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_43602_NVRAM_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_4354_FW_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_4354_NVRAM_NAME);
+MODULE_FIRMWARE(BRCMF_PCIE_4356_FW_NAME);
+MODULE_FIRMWARE(BRCMF_PCIE_4356_NVRAM_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_43570_FW_NAME);
 MODULE_FIRMWARE(BRCMF_PCIE_43570_NVRAM_NAME);
 
-- 
1.9.1

