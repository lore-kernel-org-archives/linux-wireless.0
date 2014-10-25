Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:59914 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752026AbaJYTJJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 25 Oct 2014 15:09:09 -0400
Received: by mail-wi0-f179.google.com with SMTP id h11so1513225wiw.0
        for <linux-wireless@vger.kernel.org>; Sat, 25 Oct 2014 12:09:08 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, forest@alittletooquiet.net,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 21/31] staging: vt6655: switch driver over to mac80211
Date: Sat, 25 Oct 2014 09:20:31 +0100
Message-Id: <1414225241-5480-22-git-send-email-tvboxspy@gmail.com> (sfid-20141025_210912_973165_A647DDB0)
In-Reply-To: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
References: <1414225241-5480-1-git-send-email-tvboxspy@gmail.com>
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
1.9.1

