Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49151 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab0JKJHz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 11 Oct 2010 05:07:55 -0400
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Cc: Nohee Ko <noheek@broadcom.com>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCHv2 1/2] staging: brcm80211: clean up custom ctype library again
Date: Mon, 11 Oct 2010 12:07:34 +0300
Message-Id: <9134fce655e27d36628ab508127a6d3f2d8fbfb8.1286787946.git.andy.shevchenko@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The similar cleanup was done before for softmac implementation.  But the
fullmac driver brings this back. Remove it again.

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_iw.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.h b/drivers/staging/brcm80211/brcmfmac/wl_iw.h
index 1488657..d15abc0 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.h
@@ -58,7 +58,6 @@ typedef struct wl_iw_extra_params {
 #define	WL_IW_RSSI_EXCELLENT	-57
 #define	WL_IW_RSSI_INVALID	 0
 #define MAX_WX_STRING 80
-#define isprint(c) bcm_isprint(c)
 #define WL_IW_SET_ACTIVE_SCAN	(SIOCIWFIRSTPRIV+1)
 #define WL_IW_GET_RSSI			(SIOCIWFIRSTPRIV+3)
 #define WL_IW_SET_PASSIVE_SCAN	(SIOCIWFIRSTPRIV+5)
-- 
1.7.2.3

