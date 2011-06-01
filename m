Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4830 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161272Ab1FALq1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:27 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 27/83] staging: brcm80211: removed 802.11.h
Date: Wed, 1 Jun 2011 13:45:12 +0200
Message-ID: <1306928768-7501-27-git-send-email-rvossen@broadcom.com> (sfid-20110601_134644_525912_28C248B0)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmfmac/dhd.h         |    1 -
 drivers/staging/brcm80211/brcmsmac/wlc_pub.h     |    1 -
 drivers/staging/brcm80211/include/proto/802.11.h |   20 --------------------
 3 files changed, 0 insertions(+), 22 deletions(-)
 delete mode 100644 drivers/staging/brcm80211/include/proto/802.11.h

diff --git a/drivers/staging/brcm80211/brcmfmac/dhd.h b/drivers/staging/brcm80211/brcmfmac/dhd.h
index 9583f57..eca6732 100644
--- a/drivers/staging/brcm80211/brcmfmac/dhd.h
+++ b/drivers/staging/brcm80211/brcmfmac/dhd.h
@@ -37,7 +37,6 @@
 #include "bcmdefs.h"
 /* The kernel threading is sdio-specific */
 #include "bcmwifi.h"
-#include "proto/802.11.h"
 #include "proto/bcmeth.h"
 #include "proto/bcmevent.h"
 
diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
index 2bbf995..bd0885e 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
@@ -17,7 +17,6 @@
 #ifndef _wlc_pub_h_
 #define _wlc_pub_h_
 
-#include "proto/802.11.h"	/* for MCSSET_LEN */
 #include "bcmwifi.h"		/* for chanspec_t */
 
 #define	WLC_NUMRATES	16	/* max # of rates in a rateset */
diff --git a/drivers/staging/brcm80211/include/proto/802.11.h b/drivers/staging/brcm80211/include/proto/802.11.h
deleted file mode 100644
index 048dae5..0000000
--- a/drivers/staging/brcm80211/include/proto/802.11.h
+++ /dev/null
@@ -1,20 +0,0 @@
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
-
-#ifndef _802_11_H_
-#define _802_11_H_
-
-#endif				/* _802_11_H_ */
-- 
1.7.4.1


