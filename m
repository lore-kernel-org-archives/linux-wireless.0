Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f169.google.com ([209.85.212.169]:37011 "EHLO
	mail-wi0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011AbbJQKdW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Oct 2015 06:33:22 -0400
Received: by wicfv8 with SMTP id fv8so20383428wic.0
        for <linux-wireless@vger.kernel.org>; Sat, 17 Oct 2015 03:33:21 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 4/9] staging: vt6655: device.h remove typedef enum
Date: Sat, 17 Oct 2015 11:32:57 +0100
Message-Id: <1445077982-17832-4-git-send-email-tvboxspy@gmail.com> (sfid-20151017_123339_215897_4AE5DFC0)
In-Reply-To: <1445077982-17832-1-git-send-email-tvboxspy@gmail.com>
References: <1445077982-17832-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Covert values to macros.

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6655/device.h | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/vt6655/device.h b/drivers/staging/vt6655/device.h
index be6c42b..83bb68b 100644
--- a/drivers/staging/vt6655/device.h
+++ b/drivers/staging/vt6655/device.h
@@ -98,10 +98,8 @@
 #define PK_TYPE_11GB    2
 #define PK_TYPE_11GA    3
 
-typedef enum {
-	OWNED_BY_HOST = 0,
-	OWNED_BY_NIC = 1
-} DEVICE_OWNER_TYPE, *PDEVICE_OWNER_TYPE;
+#define OWNED_BY_HOST	0
+#define	OWNED_BY_NIC	1
 
 typedef struct __device_opt {
 	int         nRxDescs0;		/* Number of RX descriptors0 */
-- 
2.5.0

