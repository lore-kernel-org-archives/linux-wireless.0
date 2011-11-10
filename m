Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:4625 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705Ab1KJTau (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Nov 2011 14:30:50 -0500
From: "Arend van Spriel" <arend@broadcom.com>
To: linville@tuxdriver.com
cc: linux-wireless@vger.kernel.org,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 04/19] brcm80211: smac: remove duplicate definition of
 D11_PHY_HDR_LEN
Date: Thu, 10 Nov 2011 20:30:19 +0100
Message-ID: <1320953434-16859-6-git-send-email-arend@broadcom.com> (sfid-20111110_203105_057323_74FAD9DB)
In-Reply-To: <1320953434-16859-1-git-send-email-arend@broadcom.com>
References: <1320953434-16859-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The macro definition D11_PHY_HDR_LEN was defined in d11.h and pub.h.
It has been removed from pub.h.

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Roland Vossen <rvossen@broadcom.com>
Reviewed-by: Alwin Beukers <alwin@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 drivers/net/wireless/brcm80211/brcmsmac/pub.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/brcmsmac/pub.h b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
index 022523a..8f3da0e 100644
--- a/drivers/net/wireless/brcm80211/brcmsmac/pub.h
+++ b/drivers/net/wireless/brcm80211/brcmsmac/pub.h
@@ -248,7 +248,6 @@ enum brcms_srom_id {
 };
 
 #define	BRCMS_NUMRATES	16	/* max # of rates in a rateset */
-#define	D11_PHY_HDR_LEN	6	/* Phy header length - 6 bytes */
 
 /* phy types */
 #define	PHY_TYPE_A	0	/* Phy type A */
-- 
1.7.5.4


