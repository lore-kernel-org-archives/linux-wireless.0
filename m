Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:3444 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754911Ab2DKJxa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Apr 2012 05:53:30 -0400
From: "Arend van Spriel" <arend@broadcom.com>
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Linux Wireless List" <linux-wireless@vger.kernel.org>,
	"Franky Lin" <frankyl@broadcom.com>,
	"Arend van Spriel" <arend@broadcom.com>
Subject: [PATCH 6/9] brcm80211: fmac: clean up chip id table
Date: Wed, 11 Apr 2012 11:52:48 +0200
Message-ID: <1334137971-3972-7-git-send-email-arend@broadcom.com> (sfid-20120411_115347_216020_E529ACD7)
In-Reply-To: <1334137971-3972-1-git-send-email-arend@broadcom.com>
References: <1334137971-3972-1-git-send-email-arend@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Franky Lin <frankyl@broadcom.com>

Remove unsupported chip ID and rearrange the list in alphabetical
order

Reviewed-by: Pieter-Paul Giesberts <pieterpg@broadcom.com>
Reviewed-by: Arend van Spriel <arend@broadcom.com>
Signed-off-by: Franky Lin <frankyl@broadcom.com>
Signed-off-by: Arend van Spriel <arend@broadcom.com>
---
 .../net/wireless/brcm80211/include/brcm_hw_ids.h   |   40 +++++--------------
 1 files changed, 11 insertions(+), 29 deletions(-)

diff --git a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
index 5fb17d5..333193f 100644
--- a/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
+++ b/drivers/net/wireless/brcm80211/include/brcm_hw_ids.h
@@ -17,17 +17,7 @@
 #ifndef	_BRCM_HW_IDS_H_
 #define	_BRCM_HW_IDS_H_
 
-#define	BCM4325_D11DUAL_ID	0x431b
-#define	BCM4325_D11G_ID		0x431c
-#define	BCM4325_D11A_ID		0x431d
-
-#define BCM4329_D11N2G_ID	0x432f	/* 4329 802.11n 2.4G device */
-#define BCM4329_D11N5G_ID	0x4330	/* 4329 802.11n 5G device */
-#define BCM4329_D11NDUAL_ID	0x432e
-
-#define BCM4319_D11N_ID		0x4337	/* 4319 802.11n dualband device */
-#define BCM4319_D11N2G_ID	0x4338	/* 4319 802.11n 2.4G device */
-#define BCM4319_D11N5G_ID	0x4339	/* 4319 802.11n 5G device */
+#define BCM4313_D11N2G_ID	0x4727	/* 4313 802.11n 2.4G device */
 
 #define BCM43224_D11N_ID	0x4353	/* 43224 802.11n dualband device */
 #define BCM43224_D11N_ID_VEN1	0x0576	/* Vendor specific 43224 802.11n db */
@@ -37,23 +27,15 @@
 #define BCM43236_D11N_ID	0x4346	/* 43236 802.11n dualband device */
 #define BCM43236_D11N2G_ID	0x4347	/* 43236 802.11n 2.4GHz device */
 
-#define BCM4313_D11N2G_ID	0x4727	/* 4313 802.11n 2.4G device */
-
-/* Chip IDs */
-#define BCM4313_CHIP_ID		0x4313	/* 4313 chip id */
-#define	BCM4319_CHIP_ID		0x4319	/* 4319 chip id */
-
-#define	BCM43224_CHIP_ID	43224	/* 43224 chipcommon chipid */
-#define	BCM43225_CHIP_ID	43225	/* 43225 chipcommon chipid */
-#define	BCM43421_CHIP_ID	43421	/* 43421 chipcommon chipid */
-#define	BCM43235_CHIP_ID	43235	/* 43235 chipcommon chipid */
-#define	BCM43236_CHIP_ID	43236	/* 43236 chipcommon chipid */
-#define	BCM43238_CHIP_ID	43238	/* 43238 chipcommon chipid */
-#define	BCM4329_CHIP_ID		0x4329	/* 4329 chipcommon chipid */
-#define	BCM4325_CHIP_ID		0x4325	/* 4325 chipcommon chipid */
-#define	BCM4331_CHIP_ID		0x4331	/* 4331 chipcommon chipid */
-#define BCM4336_CHIP_ID		0x4336	/* 4336 chipcommon chipid */
-#define BCM4330_CHIP_ID		0x4330	/* 4330 chipcommon chipid */
-#define BCM6362_CHIP_ID		0x6362	/* 6362 chipcommon chipid */
+/* Chipcommon Core Chip IDs */
+#define BCM4313_CHIP_ID		0x4313
+#define BCM43224_CHIP_ID	43224
+#define BCM43225_CHIP_ID	43225
+#define BCM43235_CHIP_ID	43235
+#define BCM43236_CHIP_ID	43236
+#define BCM43238_CHIP_ID	43238
+#define BCM4329_CHIP_ID		0x4329
+#define BCM4330_CHIP_ID		0x4330
+#define BCM4331_CHIP_ID		0x4331
 
 #endif				/* _BRCM_HW_IDS_H_ */
-- 
1.7.5.4


