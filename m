Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-we0-f175.google.com ([74.125.82.175]:52584 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950AbaGPVXX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 17:23:23 -0400
Received: by mail-we0-f175.google.com with SMTP id t60so1551168wes.20
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 14:23:22 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org, peter.senna@gmail.com,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 09/21] staging: vt6656: device_set_options fix opening function bracket
Date: Wed, 16 Jul 2014 22:21:59 +0100
Message-Id: <1405545731-6082-9-git-send-email-tvboxspy@gmail.com> (sfid-20140716_232334_099926_7C7A46BF)
In-Reply-To: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
References: <1405545731-6082-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/main_usb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/vt6656/main_usb.c b/drivers/staging/vt6656/main_usb.c
index e822572..40594a1 100644
--- a/drivers/staging/vt6656/main_usb.c
+++ b/drivers/staging/vt6656/main_usb.c
@@ -203,8 +203,8 @@ static bool device_alloc_bufs(struct vnt_private *pDevice);
 
 static void usb_device_reset(struct vnt_private *pDevice);
 
-static void
-device_set_options(struct vnt_private *pDevice) {
+static void device_set_options(struct vnt_private *pDevice)
+{
 	pDevice->cbTD = TX_DESC_DEF0;
 	pDevice->cbRD = RX_DESC_DEF0;
 	pDevice->byShortRetryLimit = SHORT_RETRY_DEF;
-- 
2.0.1

