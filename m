Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f51.google.com ([74.125.82.51]:55587 "EHLO
	mail-wg0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758632AbaGXWe5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jul 2014 18:34:57 -0400
Received: by mail-wg0-f51.google.com with SMTP id b13so3280494wgh.10
        for <linux-wireless@vger.kernel.org>; Thu, 24 Jul 2014 15:34:56 -0700 (PDT)
From: Malcolm Priestley <tvboxspy@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-wireless@vger.kernel.org,
	Malcolm Priestley <tvboxspy@gmail.com>
Subject: [PATCH 5/5] staging: vt6656: wcmd.h remove dead macros
Date: Thu, 24 Jul 2014 23:34:18 +0100
Message-Id: <1406241258-10025-5-git-send-email-tvboxspy@gmail.com> (sfid-20140725_003501_662772_5E9F5456)
In-Reply-To: <1406241258-10025-1-git-send-email-tvboxspy@gmail.com>
References: <1406241258-10025-1-git-send-email-tvboxspy@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

AUTHENTICATE_TIMEOUT
ASSOCIATE_TIMEOUT

Signed-off-by: Malcolm Priestley <tvboxspy@gmail.com>
---
 drivers/staging/vt6656/wcmd.h | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/vt6656/wcmd.h b/drivers/staging/vt6656/wcmd.h
index 79df04a..2b0ee28 100644
--- a/drivers/staging/vt6656/wcmd.h
+++ b/drivers/staging/vt6656/wcmd.h
@@ -31,9 +31,6 @@
 
 #include "device.h"
 
-#define AUTHENTICATE_TIMEOUT   1000 //ms
-#define ASSOCIATE_TIMEOUT      1000 //ms
-
 /* Command code */
 enum vnt_cmd {
 	WLAN_CMD_INIT_MAC80211,
-- 
2.0.1

