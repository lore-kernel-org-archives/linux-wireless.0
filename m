Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2305 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758818Ab1FALq3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:29 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 58/83] staging: brcm80211: clean up wl_iw.h in fullmac
Date: Wed, 1 Jun 2011 13:45:43 +0200
Message-ID: <1306928768-7501-58-git-send-email-rvossen@broadcom.com> (sfid-20110601_134931_192386_42477D0B)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Remove #include lines in wl_iw.h

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 .../staging/brcm80211/brcmfmac/dhd_custom_gpio.c   |    2 --
 drivers/staging/brcm80211/brcmfmac/wl_iw.c         |    1 +
 drivers/staging/brcm80211/brcmfmac/wl_iw.h         |    2 --
 3 files changed, 1 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c b/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
index a3ea415..a942333 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_custom_gpio.c
@@ -23,8 +23,6 @@
 #include <dngl_stats.h>
 #include <dhd.h>
 
-#include <wl_iw.h>
-
 #define WL_ERROR(fmt, args...) printk(fmt, ##args)
 #define WL_TRACE(fmt, args...) no_printk(fmt, ##args)
 
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.c b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
index da052e7e..47960de 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.c
@@ -19,6 +19,7 @@
 #include <bcmdefs.h>
 #include <linux/netdevice.h>
 #include <linux/etherdevice.h>
+#include <linux/wireless.h>
 
 #include <bcmutils.h>
 #include <bcmwifi.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.h b/drivers/staging/brcm80211/brcmfmac/wl_iw.h
index c92a8b5..aa8902c 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.h
@@ -17,8 +17,6 @@
 #ifndef _wl_iw_h_
 #define _wl_iw_h_
 
-#include <linux/wireless.h>
-
 #define WL_SCAN_PARAMS_SSID_MAX	10
 #define GET_SSID	"SSID="
 #define GET_CHANNEL	"CH="
-- 
1.7.4.1


