Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f42.google.com ([209.85.192.42]:36088 "EHLO
	mail-qg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751432AbcBNV6G (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2016 16:58:06 -0500
Received: by mail-qg0-f42.google.com with SMTP id y9so100074165qgd.3
        for <linux-wireless@vger.kernel.org>; Sun, 14 Feb 2016 13:58:05 -0800 (PST)
From: Fabio Estevam <festevam@gmail.com>
To: kvalo@codeaurora.org
Cc: arend@broadcom.com, linux-wireless@vger.kernel.org,
	Fabio Estevam <fabio.estevam@nxp.com>
Subject: [PATCH] brcmfmac: of: Include "of.h" header file
Date: Sun, 14 Feb 2016 19:57:49 -0200
Message-Id: <1455487069-2721-1-git-send-email-festevam@gmail.com> (sfid-20160214_225842_106945_BBDCBF0E)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Fabio Estevam <fabio.estevam@nxp.com>

Include "of.h" header file to fix the following sparse warning:

drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c:27:6: warning: symbol 'brcmf_of_probe' was not declared. Should it be static?

Signed-off-by: Fabio Estevam <fabio.estevam@nxp.com>
---
Resending to linux-wireless@vger.kernel.org

 drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
index 03f35e0..6231b36 100644
--- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
+++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/of.c
@@ -23,6 +23,7 @@
 #include <defs.h>
 #include "debug.h"
 #include "sdio.h"
+#include "of.h"
 
 void brcmf_of_probe(struct brcmf_sdio_dev *sdiodev)
 {
-- 
1.9.1

