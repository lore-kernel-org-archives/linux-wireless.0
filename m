Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:34219 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1424777AbdEYR2z (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 May 2017 13:28:55 -0400
Received: by mail-wm0-f65.google.com with SMTP id d127so54574111wmf.1
        for <linux-wireless@vger.kernel.org>; Thu, 25 May 2017 10:28:55 -0700 (PDT)
From: Marko Stankovic <dartnorris@gmail.com>
To: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Marko Stankovic <dartnorris@gmail.com>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: [PATCH 2/2] staging: wilc1000: add missing blank line after struct declaration
Date: Thu, 25 May 2017 19:28:31 +0200
Message-Id: <20170525172831.14596-2-dartnorris@gmail.com> (sfid-20170525_192956_703699_B5003D8B)
In-Reply-To: <20170525172831.14596-1-dartnorris@gmail.com>
References: <20170525172831.14596-1-dartnorris@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Fix a missing blank line issue reported by checkpatch.pl

Signed-off-by: Marko Stankovic <dartnorris@gmail.com>
---
 drivers/staging/wilc1000/wilc_wfi_cfgoperations.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
index 98316a45abd1..cae9c8ff80d8 100644
--- a/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
+++ b/drivers/staging/wilc1000/wilc_wfi_cfgoperations.c
@@ -167,6 +167,7 @@ struct add_key_params {
 	bool pairwise;
 	u8 *mac_addr;
 };
+
 static struct add_key_params g_add_gtk_key_params;
 static struct wilc_wfi_key g_key_gtk_params;
 static struct add_key_params g_add_ptk_key_params;
-- 
2.11.0
