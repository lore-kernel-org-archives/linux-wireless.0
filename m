Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:49546 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751011AbdGZUqm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 26 Jul 2017 16:46:42 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com
Subject: [PATCH 17/34] brcmfmac: Remove unused macro.
Date: Wed, 26 Jul 2017 21:25:40 +0100
Message-Id: <20170726202557.15632-18-ian@mnementh.co.uk> (sfid-20170726_230043_443463_C13227AC)
In-Reply-To: <20170726202557.15632-1-ian@mnementh.co.uk>
References: <20170726202557.15632-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This macro is used exactly nowhere in the code. Delete it.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 82769276654d..b4fd832cdabe 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -159,8 +159,6 @@ struct rte_console {
 /* manfid tuple length, include tuple, link bytes */
 #define SBSDIO_CIS_MANFID_TUPLE_LEN	6
 
-#define CORE_BUS_REG(base, field) \
-		(base + offsetof(struct sdpcmd_regs, field))
 #define __sd_reg(field) \
 		(offsetof(struct sdpcmd_regs, field))
 
-- 
2.11.0
