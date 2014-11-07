Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:53001 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161AbaKGTGr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Nov 2014 14:06:47 -0500
Received: by mail-wi0-f176.google.com with SMTP id h11so5501633wiw.15
        for <linux-wireless@vger.kernel.org>; Fri, 07 Nov 2014 11:06:45 -0800 (PST)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 06/10] staging: vt6655: dead code remove typedef enum _CARD_PHY_TYPE
Date: Fri,  7 Nov 2014 19:06:05 +0000
Message-Id: <1415387169-3843-6-git-send-email-tvboxspy@gmail.com> (sfid-20141107_200650_285726_A8BCFC27)
In-Reply-To: <1415387169-3843-1-git-send-email-tvboxspy@gmail.com>
References: <1415387169-3843-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Removing unused eCurrentPHYType

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/card.h   | 7 -------
 drivers/staging/vt6655/device.h | 1 -
 2 files changed, 8 deletions(-)

diff --git a/drivers/staging/vt6655/card.h b/drivers/staging/vt6655/card.h
index 306f7b7..30f3472 100644
--- a/drivers/staging/vt6655/card.h
+++ b/drivers/staging/vt6655/card.h
@@ -51,13 +51,6 @@
 #define CB_MAX_CHANNEL_5G       42
 #define CB_MAX_CHANNEL          (CB_MAX_CHANNEL_24G+CB_MAX_CHANNEL_5G)
 
-typedef enum _CARD_PHY_TYPE {
-	PHY_TYPE_11A = 0,
-	PHY_TYPE_11B,
-	PHY_TYPE_11G,
-	PHY_TYPE_AUTO
-} CARD_PHY_TYPE, *PCARD_PHY_TYPE;
-
 typedef enum _CARD_PKT_TYPE {
 	PKT_TYPE_802_11_BCN,
 	PKT_TYPE_802_11_MNG,
diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index 1393210..dab07e1 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -320,7 +320,6 @@ struct vnt_private {
 	unsigned char byEIFS;
 	unsigned char bySlot;
 	unsigned char byCWMaxMin;
-	CARD_PHY_TYPE		eCurrentPHYType;
 
 	VIA_BB_TYPE		byBBType; /* 0:11A, 1:11B, 2:11G */
 	VIA_PKT_TYPE            byPacketType; /*
-- 
2.1.0

