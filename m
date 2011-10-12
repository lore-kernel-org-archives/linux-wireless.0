Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4328 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753980Ab1JLSvr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Oct 2011 14:51:47 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Alwin Beukers" <alwin@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 22/22] brcm80211: removed file wifi.c
Date: Wed, 12 Oct 2011 20:51:32 +0200
Message-ID: <1318445492-24207-23-git-send-email-arend@broadcom.com> (sfid-20111012_205231_795177_8B760EF6)
In-Reply-To: <1318445492-24207-1-git-send-email-arend@broadcom.com>
References: <1318445492-24207-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Alwin Beukers <alwin@broadcom.com>

Wifi.c was empty after previous cleanups, so it was removed.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmutil/Makefile |    3 +--
 drivers/net/wireless/brcm80211/brcmutil/wifi.c   |   16 ----------------
 2 files changed, 1 insertions(+), 18 deletions(-)
 delete mode 100644 drivers/net/wireless/brcm80211/brcmutil/wifi.c

diff --git a/drivers/net/wireless/brcm80211/brcmutil/Makefile b/drivers/net/wireless/brcm80211/brcmutil/Makefile
index 720e261..6281c41 100644
--- a/drivers/net/wireless/brcm80211/brcmutil/Makefile
+++ b/drivers/net/wireless/brcm80211/brcmutil/Makefile
@@ -20,8 +20,7 @@ ccflags-y :=				\
 	-Idrivers/net/wireless/brcm80211/include
 
 BRCMUTIL_OFILES := \
-	utils.o \
-	wifi.o
+	utils.o
 
 MODULEPFX := brcmutil
 
diff --git a/drivers/net/wireless/brcm80211/brcmutil/wifi.c b/drivers/net/wireless/brcm80211/brcmutil/wifi.c
deleted file mode 100644
index 8483f24..0000000
--- a/drivers/net/wireless/brcm80211/brcmutil/wifi.c
+++ /dev/null
@@ -1,16 +0,0 @@
-/*
- * Copyright (c) 2010 Broadcom Corporation
- *
- * Permission to use, copy, modify, and/or distribute this software for any
- * purpose with or without fee is hereby granted, provided that the above
- * copyright notice and this permission notice appear in all copies.
- *
- * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
- * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
- * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR ANY
- * SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
- * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION
- * OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN
- * CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
- */
-#include <brcmu_wifi.h>
-- 
1.7.4.1


