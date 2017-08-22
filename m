Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:60156 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S932550AbdHVLpd (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 22 Aug 2017 07:45:33 -0400
From: Ian Molton <ian@mnementh.co.uk>
To: linux-wireless@vger.kernel.org
Cc: arend.vanspriel@broadcom.com
Subject: [PATCH 19/30] brcmfmac: Remove unused macro.
Date: Tue, 22 Aug 2017 12:25:39 +0100
Message-Id: <20170822112550.60311-20-ian@mnementh.co.uk> (sfid-20170822_134538_828291_6E2FE53E)
In-Reply-To: <20170822112550.60311-1-ian@mnementh.co.uk>
References: <20170822112550.60311-1-ian@mnementh.co.uk>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This macro is used exactly nowhere in the code. Delete it.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index 8f3e99da871a..b095bb66fe96 100644
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
