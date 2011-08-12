Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4842 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751996Ab1HLNfN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Aug 2011 09:35:13 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 05/14] staging: brcm80211: remove wext traces in fullmac
Date: Fri, 12 Aug 2011 15:34:52 +0200
Message-ID: <1313156101-16817-6-git-send-email-arend@broadcom.com> (sfid-20110812_153525_616893_0510CCB1)
In-Reply-To: <1313156101-16817-1-git-send-email-arend@broadcom.com>
References: <1313156101-16817-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

wext support code have been removed a while ago. This patch removes the
traces left behind.

Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/Kconfig                |    2 --
 drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c |    1 -
 2 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/Kconfig b/drivers/staging/brcm80211/Kconfig
index f4cf9b2..621570a 100644
--- a/drivers/staging/brcm80211/Kconfig
+++ b/drivers/staging/brcm80211/Kconfig
@@ -22,8 +22,6 @@ config BRCMFMAC
 	depends on WLAN && CFG80211
 	select BRCMUTIL
 	select FW_LOADER
-	select WIRELESS_EXT
-	select WEXT_PRIV
 	---help---
 	  This module adds support for embedded wireless adapters based on
 	  Broadcom IEEE802.11n FullMAC chipsets.  This driver uses the kernel's
diff --git a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
index 833defb..def1f77 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
+++ b/drivers/staging/brcm80211/brcmfmac/wl_cfg80211.c
@@ -21,7 +21,6 @@
 #include <linux/netdevice.h>
 #include <linux/sched.h>
 #include <linux/etherdevice.h>
-#include <linux/wireless.h>
 #include <linux/ieee80211.h>
 #include <linux/mmc/sdio_func.h>
 #include <linux/uaccess.h>
-- 
1.7.4.1


