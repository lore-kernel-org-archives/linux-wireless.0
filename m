Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:35815 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751648AbbIPLMJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Sep 2015 07:12:09 -0400
Received: by pacfv12 with SMTP id fv12so210912734pac.2
        for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2015 04:12:09 -0700 (PDT)
From: Chaehyun Lim <chaehyun.lim@gmail.com>
To: gregkh@linuxfoundation.org
Cc: johnny.kim@atmel.com, rachel.kim@atmel.com, chris.park@atmel.com,
	tony.cho@atmel.com, leo.kim@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	Chaehyun Lim <chaehyun.lim@gmail.com>
Subject: [PATCH 10/10] staging: wilc1000: remove declaration of wilc_get_chipid
Date: Wed, 16 Sep 2015 20:11:35 +0900
Message-Id: <1442401895-7463-10-git-send-email-chaehyun.lim@gmail.com> (sfid-20150916_131217_711504_AEBA2423)
In-Reply-To: <1442401895-7463-1-git-send-email-chaehyun.lim@gmail.com>
References: <1442401895-7463-1-git-send-email-chaehyun.lim@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch removes the declaration of wilc_get_chipid function.
It is included wilc_wlan_if.h that has declaration of wilc_get_chipid.

Signed-off-by: Chaehyun Lim <chaehyun.lim@gmail.com>
---
 drivers/staging/wilc1000/host_interface.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index e12c95d..4c88a60 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -1,5 +1,6 @@
 #include "host_interface.h"
 #include "coreconfigurator.h"
+#include "wilc_wlan_if.h"
 
 extern u8 connecting;
 
@@ -7424,7 +7425,6 @@ s32 host_int_edit_station(tstrWILC_WFIDrv *hWFIDrv, tstrWILC_AddStaParam *pstrSt
 	return s32Error;
 }
 #endif /*WILC_AP_EXTERNAL_MLME*/
-u32 wilc_get_chipid(u8);
 
 s32 host_int_set_power_mgmt(tstrWILC_WFIDrv *hWFIDrv, bool bIsEnabled, u32 u32Timeout)
 {
-- 
2.5.1

