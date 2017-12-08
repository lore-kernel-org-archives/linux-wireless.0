Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rnd-relay.smtp.broadcom.com ([192.19.229.170]:43785 "EHLO
        rnd-relay.smtp.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753047AbdLHMKp (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Dec 2017 07:10:45 -0500
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: linux-wireless@vger.kernel.org, Ian Molton <ian@mnementh.co.uk>,
        Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: [PATCH 09/10] brcmfmac: Remove unused macro.
Date: Fri,  8 Dec 2017 13:10:34 +0100
Message-Id: <1512735035-342-10-git-send-email-arend.vanspriel@broadcom.com> (sfid-20171208_131109_096944_E6AF79B3)
In-Reply-To: <1512735035-342-1-git-send-email-arend.vanspriel@broadcom.com>
References: <1512735035-342-1-git-send-email-arend.vanspriel@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Ian Molton <ian@mnementh.co.uk>

This macro is used exactly nowhere in the code. Delete it.

Signed-off-by: Ian Molton <ian@mnementh.co.uk>
Reviewed-by: Arend van Spriel <arend.vanspriel@broadcom.com>
Signed-off-by: Arend van Spriel <arend.vanspriel@broadcom.com>
---
 drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
index b938407..1e1e198 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/sdio.c
@@ -159,8 +159,6 @@ struct rte_console {
 /* manfid tuple length, include tuple, link bytes */
 #define SBSDIO_CIS_MANFID_TUPLE_LEN	6
 
-#define CORE_BUS_REG(base, field) \
-		(base + offsetof(struct sdpcmd_regs, field))
 #define SD_REG(field) \
 		(offsetof(struct sdpcmd_regs, field))
 
-- 
1.9.1
