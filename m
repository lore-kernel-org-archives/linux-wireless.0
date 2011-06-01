Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4919 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758827Ab1FALqc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:32 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 57/83] staging: brcm80211: clean up wl_cfg80211.h in
 fullmac
Date: Wed, 1 Jun 2011 13:45:42 +0200
Message-ID: <1306928768-7501-57-git-send-email-rvossen@broadcom.com> (sfid-20110601_134915_041723_FAFD8390)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Remove #include lines in wl_cfg80211.h

Signed-off-by: Franky Lin <frankyl@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 .../brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c        |    1 +
 drivers/staging/brcm80211/brcmfmac/dhd_linux.c     |    1 +
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h   |    4 ----
 3 files changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
index f495d4b..fbc9abd 100644
--- a/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/bcmsdh_sdmmc_linux.c
@@ -16,6 +16,7 @@
 #include <linux/types.h>
 #include <linux/sched.h>	/* request_irq() */
 #include <linux/netdevice.h>
+#include <net/cfg80211.h>
 #include <bcmdefs.h>
 #include <bcmutils.h>
 #include <bcmwifi.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
index b023fc8..6ba50bb 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_linux.c
@@ -31,6 +31,7 @@
 #include <linux/fcntl.h>
 #include <linux/fs.h>
 #include <linux/uaccess.h>
+#include <net/cfg80211.h>
 #include <bcmdefs.h>
 #include <bcmutils.h>
 #include <bcmwifi.h>
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
index 4bd0392..33fb03a 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.h
@@ -17,10 +17,6 @@
 #ifndef _wl_cfg80211_h_
 #define _wl_cfg80211_h_
 
-#include <linux/wireless.h>
-#include <linux/wireless.h>
-#include <net/cfg80211.h>
-
 struct wl_conf;
 struct wl_iface;
 struct wl_priv;
-- 
1.7.4.1


