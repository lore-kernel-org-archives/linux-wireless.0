Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2035 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757608Ab1F2Xsm (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:42 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 101/119] staging: brcm80211: removed last global
 function declaration in .c file
Date: Wed, 29 Jun 2011 16:48:05 -0700
Message-ID: <1309391303-22741-102-git-send-email-frankyl@broadcom.com> (sfid-20110630_014917_468722_BB93AEEC)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Roland Vossen <rvossen@broadcom.com>

Code cleanup.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index 0a632f5..cdaa042 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -252,7 +252,6 @@ int brcmf_sdio_function_init(void)
 /*
  * module cleanup
 */
-extern int brcmf_sdio_remove(struct device *dev);
 void brcmf_sdio_function_cleanup(void)
 {
 	sd_trace(("%s Enter\n", __func__));
-- 
1.7.1


