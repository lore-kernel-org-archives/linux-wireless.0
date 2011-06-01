Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:2329 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758841Ab1FALqe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Jun 2011 07:46:34 -0400
From: "Roland Vossen" <rvossen@broadcom.com>
To: gregkh@suse.de
cc: devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: [PATCH 65/83] staging: brcm80211: removed lmac remnants
Date: Wed, 1 Jun 2011 13:45:50 +0200
Message-ID: <1306928768-7501-65-git-send-email-rvossen@broadcom.com> (sfid-20110601_134716_878165_59399C14)
In-Reply-To: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
References: <1306928768-7501-1-git-send-email-rvossen@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Code cleanup. LMAC (a Broadcom specific acronym) was not used.

Signed-off-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/staging/brcm80211/brcmsmac/wlc_pub.h |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
index 4f0fa20..a0c170b 100644
--- a/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
+++ b/drivers/staging/brcm80211/brcmsmac/wlc_pub.h
@@ -319,9 +319,6 @@ struct wlc_pub {
 	u32 boardflags;	/* Board specific flags from srom */
 	u32 boardflags2;	/* More board flags if sromrev >= 4 */
 	bool tempsense_disable;	/* disable periodic tempsense check */
-
-	bool _lmac;		/* lmac module included and enabled */
-	bool _lmacproto;	/* lmac protocol module included and enabled */
 	bool phy_11ncapable;	/* the PHY/HW is capable of 802.11N */
 	bool _ampdumac;		/* mac assist ampdu enabled or not */
 
-- 
1.7.4.1


