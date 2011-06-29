Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4518 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757736Ab1F2Xso (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2011 19:48:44 -0400
From: "Franky Lin" <frankyl@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 103/119] staging: brcm80211: remove unused macros from
 dhd_dbg.h
Date: Wed, 29 Jun 2011 16:48:07 -0700
Message-ID: <1309391303-22741-104-git-send-email-frankyl@broadcom.com> (sfid-20110630_014938_705438_B4BEAF68)
In-Reply-To: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
References: <1309391303-22741-1-git-send-email-frankyl@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Arend van Spriel <arend@broadcom.com>

cleanup of some unused macros.

Signed-off-by: Arend van Spriel <arend@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Franky Lin <frankyl@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd_dbg.h |   26 +-------------------------
 1 files changed, 1 insertions(+), 25 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h b/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
index 678a7e2..4733de7 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd_dbg.h
@@ -42,24 +42,12 @@
 					printk args; } while (0)
 #define DHD_EVENT(args)		do {if (brcmf_msg_level & BRCMF_EVENT_VAL) \
 					printk args; } while (0)
-#define DHD_BTA(args)		do {if (brcmf_msg_level & BRCMF_BTA_VAL) \
-					printk args; } while (0)
-#define DHD_ISCAN(args)		do {if (brcmf_msg_level & BRCMF_ISCAN_VAL) \
-					printk args; } while (0)
 
-#define DHD_ERROR_ON()		(brcmf_msg_level & BRCMF_ERROR_VAL)
-#define DHD_TRACE_ON()		(brcmf_msg_level & BRCMF_TRACE_VAL)
-#define DHD_INFO_ON()		(brcmf_msg_level & BRCMF_INFO_VAL)
 #define DHD_DATA_ON()		(brcmf_msg_level & BRCMF_DATA_VAL)
 #define DHD_CTL_ON()		(brcmf_msg_level & BRCMF_CTL_VAL)
-#define DHD_TIMER_ON()		(brcmf_msg_level & BRCMF_TIMER_VAL)
 #define DHD_HDRS_ON()		(brcmf_msg_level & BRCMF_HDRS_VAL)
 #define DHD_BYTES_ON()		(brcmf_msg_level & BRCMF_BYTES_VAL)
-#define DHD_INTR_ON()		(brcmf_msg_level & BRCMF_INTR_VAL)
 #define DHD_GLOM_ON()		(brcmf_msg_level & BRCMF_GLOM_VAL)
-#define DHD_EVENT_ON()		(brcmf_msg_level & BRCMF_EVENT_VAL)
-#define DHD_BTA_ON()		(brcmf_msg_level & BRCMF_BTA_VAL)
-#define DHD_ISCAN_ON()		(brcmf_msg_level & BRCMF_ISCAN_VAL)
 
 #else	/* (defined BCMDBG) || (defined BCMDBG) */
 
@@ -74,27 +62,15 @@
 #define DHD_INTR(args)
 #define DHD_GLOM(args)
 #define DHD_EVENT(args)
-#define DHD_BTA(args)
-#define DHD_ISCAN(args)
 
-#define DHD_ERROR_ON()		0
-#define DHD_TRACE_ON()		0
-#define DHD_INFO_ON()		0
 #define DHD_DATA_ON()		0
 #define DHD_CTL_ON()		0
-#define DHD_TIMER_ON()		0
 #define DHD_HDRS_ON()		0
 #define DHD_BYTES_ON()		0
-#define DHD_INTR_ON()		0
 #define DHD_GLOM_ON()		0
-#define DHD_EVENT_ON()		0
-#define DHD_BTA_ON()		0
-#define DHD_ISCAN_ON()		0
-#endif				/* defined(BCMDBG) */
 
-#define DHD_LOG(args)
+#endif				/* defined(BCMDBG) */
 
-#define DHD_NONE(args)
 extern int brcmf_msg_level;
 
 #endif				/* _dhd_dbg_ */
-- 
1.7.1


