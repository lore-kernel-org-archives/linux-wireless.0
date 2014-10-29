Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f49.google.com ([74.125.82.49]:40383 "EHLO
	mail-wg0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756101AbaJ2Rpr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2014 13:45:47 -0400
Received: by mail-wg0-f49.google.com with SMTP id x13so2445335wgg.36
        for <linux-wireless@vger.kernel.org>; Wed, 29 Oct 2014 10:45:46 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH v2 21/34] staging: vt6655: switch driver over to mac80211
Date: Wed, 29 Oct 2014 17:43:56 +0000
Message-Id: <1414604649-9105-22-git-send-email-tvboxspy@gmail.com> (sfid-20141029_184606_868182_44ED1100)
In-Reply-To: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
References: <1414604649-9105-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/Kconfig | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/staging/vt6655/Kconfig b/drivers/staging/vt6655/Kconfig
index c3ba693..77cfc70 100644
--- a/drivers/staging/vt6655/Kconfig
+++ b/drivers/staging/vt6655/Kconfig
@@ -1,8 +1,6 @@
 config VT6655
    tristate "VIA Technologies VT6655 support"
-   depends on PCI && WLAN && m
-   select WIRELESS_EXT
-   select WEXT_PRIV
+   depends on PCI && MAC80211 && m
    ---help---
    This is a vendor-written driver for VIA VT6655.
 
-- 
2.1.0

