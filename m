Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:35292 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S936582AbdEYRZ5 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 May 2017 13:25:57 -0400
Received: by mail-wm0-f67.google.com with SMTP id g15so35030542wmc.2
        for <linux-wireless@vger.kernel.org>; Thu, 25 May 2017 10:25:56 -0700 (PDT)
From: Marko Stankovic <dartnorris@gmail.com>
To: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Marko Stankovic <dartnorris@gmail.com>,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org
Subject: 
Date: Thu, 25 May 2017 19:25:07 +0200
Message-Id: <20170525172507.14356-2-dartnorris@gmail.com> (sfid-20170525_192652_495740_B69F1572)
In-Reply-To: <20170525172507.14356-1-dartnorris@gmail.com>
References: <20170525172507.14356-1-dartnorris@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Subject: [PATCH 2/2] staging: wilc1000: add missing blank line after struct
 declaration

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
