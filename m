Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pb0-f49.google.com ([209.85.160.49]:64885 "EHLO
	mail-pb0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbaE1LlX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 May 2014 07:41:23 -0400
Received: by mail-pb0-f49.google.com with SMTP id jt11so10874039pbb.8
        for <linux-wireless@vger.kernel.org>; Wed, 28 May 2014 04:41:22 -0700 (PDT)
From: Sachin Kamat <sachin.kamat@linaro.org>
To: devel@driverdev.osuosl.org
Cc: linux-wireless@vger.kernel.org, Larry.Finger@lwfinger.net,
	Jes.Sorensen@redhat.com, gregkh@linuxfoundation.org,
	sachin.kamat@linaro.org
Subject: [PATCH 1/1] staging: rtl8723au: Remove duplicate inclusion of wlan_bssdef.h
Date: Wed, 28 May 2014 17:09:01 +0530
Message-Id: <1401277141-29710-1-git-send-email-sachin.kamat@linaro.org> (sfid-20140528_134126_456790_1FCE874C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

wlan_bssdef.h was included twice.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/staging/rtl8723au/include/drv_types.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/rtl8723au/include/drv_types.h b/drivers/staging/rtl8723au/include/drv_types.h
index 49add5f..a94857d 100644
--- a/drivers/staging/rtl8723au/include/drv_types.h
+++ b/drivers/staging/rtl8723au/include/drv_types.h
@@ -38,7 +38,6 @@ enum _NIC_VERSION {
 #include <rtw_ht.h>
 
 #include <rtw_cmd.h>
-#include <wlan_bssdef.h>
 #include <rtw_xmit.h>
 #include <rtw_recv.h>
 #include <hal_intf.h>
-- 
1.7.9.5

